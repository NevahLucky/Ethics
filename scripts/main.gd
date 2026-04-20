extends Control
## Main scene controller.
## Builds the presentation UI programmatically and manages
## era transitions, navigation, and animations.

# ── State ──────────────────────────────────────────────────────────
var current_era: int = 0
var transitioning: bool = false
var eras: Array = []

# ── Node references ────────────────────────────────────────────────
var bg_rect: TextureRect
var color_overlay: ColorRect
var dark_gradient: TextureRect

var content_panel: PanelContainer
var era_label_node: Label
var title_label: Label
var decade_label: Label
var divider: ColorRect
var summary_label: RichTextLabel

var char_header: Label
var char_container: VBoxContainer
var char_labels: Array[Label] = []

var behavior_header: Label
var behavior_container: VBoxContainer
var behavior_labels: Array[Label] = []

var manipulation_header: Label
var manipulation_container: VBoxContainer
var manipulation_labels: Array[Label] = []

var example_header: Label
var example_label: Label

var ethical_badge: Label
var reflection_header: Label
var reflection_label: RichTextLabel

var comparison_label: Label

var pressure_bar_bg: ColorRect
var pressure_bar_fill: ColorRect
var pressure_label_node: Label
var pressure_value_label: Label

var nav_prev: Button
var nav_next: Button
var nav_dots: Array[Button] = []

var transition_overlay: ColorRect
var title_screen_container: Control

# ── Preloaded textures ─────────────────────────────────────────────
var bg_textures: Array = []

# ── Constants ──────────────────────────────────────────────────────
const TRANSITION_DURATION := 0.5
const CONTENT_STAGGER := 0.08
const PRESSURE_BAR_HEIGHT := 220.0
const PRESSURE_BAR_WIDTH := 18.0

func _ready() -> void:
	eras = EraData.get_eras()

	for era in eras:
		var tex = load(era.bg_image)
		bg_textures.append(tex)

	_build_ui()
	_show_title_screen()


func _input(event: InputEvent) -> void:
	if transitioning:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_RIGHT, KEY_SPACE, KEY_ENTER:
				if title_screen_container and title_screen_container.visible:
					_dismiss_title_screen()
				else:
					_go_to_era(current_era + 1)
			KEY_LEFT:
				_go_to_era(current_era - 1)
			KEY_R:
				if not title_screen_container:
					_go_to_era(0)
			KEY_ESCAPE:
				get_tree().quit()


# ═══════════════════════════════════════════════════════════════════
# UI CONSTRUCTION
# ═══════════════════════════════════════════════════════════════════

func _build_ui() -> void:
	_build_background()
	_build_content_panel()
	_build_pressure_meter()
	_build_nav_bar()
	_build_transition_overlay()
	_build_title_screen()


func _build_background() -> void:
	bg_rect = TextureRect.new()
	bg_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg_rect)

	color_overlay = ColorRect.new()
	color_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_overlay.color = Color(0, 0, 0, 0.3)
	color_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(color_overlay)

	dark_gradient = TextureRect.new()
	dark_gradient.set_anchors_preset(Control.PRESET_FULL_RECT)
	dark_gradient.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var gradient_tex := GradientTexture2D.new()
	var grad := Gradient.new()
	grad.set_color(0, Color(0, 0, 0, 0.0))
	grad.set_color(1, Color(0, 0, 0, 0.78))
	grad.set_offset(0, 0.3)
	grad.set_offset(1, 1.0)
	gradient_tex.gradient = grad
	gradient_tex.fill_from = Vector2(0.5, 0.0)
	gradient_tex.fill_to = Vector2(0.5, 1.0)
	gradient_tex.width = 4
	gradient_tex.height = 256

	dark_gradient.texture = gradient_tex
	dark_gradient.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(dark_gradient)


func _build_content_panel() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 170)
	margin.add_theme_constant_override("margin_right", 170)
	margin.add_theme_constant_override("margin_top", 50)
	margin.add_theme_constant_override("margin_bottom", 95)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(margin)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(center)

	content_panel = PanelContainer.new()
	content_panel.custom_minimum_size = Vector2(860, 0)
	content_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.04, 0.04, 0.08, 0.9)
	panel_style.corner_radius_top_left = 20
	panel_style.corner_radius_top_right = 20
	panel_style.corner_radius_bottom_left = 20
	panel_style.corner_radius_bottom_right = 20
	panel_style.content_margin_left = 46
	panel_style.content_margin_right = 46
	panel_style.content_margin_top = 38
	panel_style.content_margin_bottom = 34
	panel_style.border_width_left = 1
	panel_style.border_width_right = 1
	panel_style.border_width_top = 1
	panel_style.border_width_bottom = 1
	panel_style.border_color = Color(1, 1, 1, 0.08)
	panel_style.shadow_color = Color(0, 0, 0, 0.42)
	panel_style.shadow_size = 24
	panel_style.shadow_offset = Vector2(0, 8)
	content_panel.add_theme_stylebox_override("panel", panel_style)

	center.add_child(content_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	content_panel.add_child(vbox)

	era_label_node = Label.new()
	era_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	era_label_node.add_theme_font_size_override("font_size", 15)
	era_label_node.add_theme_color_override("font_color", Color(0.6, 0.8, 0.7))
	era_label_node.uppercase = true
	vbox.add_child(era_label_node)

	title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title_label.add_theme_font_size_override("font_size", 42)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(title_label)

	decade_label = Label.new()
	decade_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	decade_label.add_theme_font_size_override("font_size", 19)
	decade_label.add_theme_color_override("font_color", Color(0.6, 0.8, 0.7))
	vbox.add_child(decade_label)

	var spacer1 := Control.new()
	spacer1.custom_minimum_size = Vector2(0, 6)
	vbox.add_child(spacer1)

	divider = ColorRect.new()
	divider.custom_minimum_size = Vector2(0, 2)
	divider.color = Color(1, 1, 1, 0.12)
	vbox.add_child(divider)

	var spacer2 := Control.new()
	spacer2.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer2)

	summary_label = RichTextLabel.new()
	summary_label.bbcode_enabled = true
	summary_label.fit_content = true
	summary_label.scroll_active = false
	summary_label.custom_minimum_size = Vector2(720, 0)
	summary_label.add_theme_font_size_override("normal_font_size", 17)
	summary_label.add_theme_color_override("default_color", Color(0.84, 0.84, 0.88))
	summary_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(summary_label)

	var spacer3 := Control.new()
	spacer3.custom_minimum_size = Vector2(0, 10)
	vbox.add_child(spacer3)

	ethical_badge = Label.new()
	ethical_badge.add_theme_font_size_override("font_size", 14)
	ethical_badge.add_theme_color_override("font_color", Color.WHITE)
	ethical_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	vbox.add_child(ethical_badge)

	var spacer4 := Control.new()
	spacer4.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer4)

	char_header = _make_section_header("KEY CHARACTERISTICS")
	vbox.add_child(char_header)

	char_container = VBoxContainer.new()
	char_container.add_theme_constant_override("separation", 6)
	vbox.add_child(char_container)

	var spacer5 := Control.new()
	spacer5.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer5)

	behavior_header = _make_section_header("HOW PLAYER BEHAVIOR CHANGES")
	vbox.add_child(behavior_header)

	behavior_container = VBoxContainer.new()
	behavior_container.add_theme_constant_override("separation", 6)
	vbox.add_child(behavior_container)

	var spacer6 := Control.new()
	spacer6.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer6)

	manipulation_header = _make_section_header("DESIGN TECHNIQUES / PRESSURES")
	vbox.add_child(manipulation_header)

	manipulation_container = VBoxContainer.new()
	manipulation_container.add_theme_constant_override("separation", 6)
	vbox.add_child(manipulation_container)

	var spacer7 := Control.new()
	spacer7.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer7)

	example_header = _make_section_header("EXAMPLES")
	vbox.add_child(example_header)

	example_label = Label.new()
	example_label.add_theme_font_size_override("font_size", 16)
	example_label.add_theme_color_override("font_color", Color(0.80, 0.80, 0.84))
	example_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(example_label)

	var spacer8 := Control.new()
	spacer8.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer8)

	reflection_header = _make_section_header("REFLECTION")
	vbox.add_child(reflection_header)

	reflection_label = RichTextLabel.new()
	reflection_label.bbcode_enabled = true
	reflection_label.fit_content = true
	reflection_label.scroll_active = false
	reflection_label.custom_minimum_size = Vector2(720, 0)
	reflection_label.add_theme_font_size_override("normal_font_size", 16)
	reflection_label.add_theme_color_override("default_color", Color(0.92, 0.92, 0.96))
	reflection_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(reflection_label)

	var spacer9 := Control.new()
	spacer9.custom_minimum_size = Vector2(0, 10)
	vbox.add_child(spacer9)

	comparison_label = Label.new()
	comparison_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	comparison_label.add_theme_font_size_override("font_size", 14)
	comparison_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.55))
	comparison_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(comparison_label)


func _make_section_header(text_value: String) -> Label:
	var lbl := Label.new()
	lbl.text = text_value
	lbl.uppercase = true
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.52))
	return lbl


func _build_pressure_meter() -> void:
	var container := Control.new()
	container.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	container.position = Vector2(44, -PRESSURE_BAR_HEIGHT - 100)
	container.size = Vector2(70, PRESSURE_BAR_HEIGHT + 60)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(container)

	pressure_label_node = Label.new()
	pressure_label_node.text = "PRESSURE"
	pressure_label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pressure_label_node.add_theme_font_size_override("font_size", 11)
	pressure_label_node.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	pressure_label_node.position = Vector2(-4, -4)
	pressure_label_node.size = Vector2(76, 20)
	container.add_child(pressure_label_node)

	pressure_bar_bg = ColorRect.new()
	pressure_bar_bg.position = Vector2(20, 20)
	pressure_bar_bg.size = Vector2(PRESSURE_BAR_WIDTH, PRESSURE_BAR_HEIGHT)
	pressure_bar_bg.color = Color(1, 1, 1, 0.08)
	container.add_child(pressure_bar_bg)

	pressure_bar_fill = ColorRect.new()
	pressure_bar_fill.position = Vector2(20, 20 + PRESSURE_BAR_HEIGHT)
	pressure_bar_fill.size = Vector2(PRESSURE_BAR_WIDTH, 0)
	pressure_bar_fill.color = Color("#52B788")
	container.add_child(pressure_bar_fill)

	pressure_value_label = Label.new()
	pressure_value_label.text = "25%"
	pressure_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pressure_value_label.add_theme_font_size_override("font_size", 13)
	pressure_value_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.45))
	pressure_value_label.position = Vector2(2, PRESSURE_BAR_HEIGHT + 26)
	pressure_value_label.size = Vector2(50, 20)
	container.add_child(pressure_value_label)


func _build_nav_bar() -> void:
	var bar := HBoxContainer.new()
	bar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	bar.position = Vector2(-180, -42)
	bar.size = Vector2(360, 44)
	bar.add_theme_constant_override("separation", 14)
	bar.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(bar)

	nav_prev = _make_nav_button("←")
	nav_prev.pressed.connect(_on_prev_pressed)
	bar.add_child(nav_prev)

	for i in range(eras.size()):
		var dot := Button.new()
		dot.text = "●"
		dot.flat = true
		dot.add_theme_font_size_override("font_size", 18)
		dot.add_theme_color_override("font_color", Color(1, 1, 1, 0.25))
		dot.add_theme_color_override("font_hover_color", Color(1, 1, 1, 0.6))
		dot.custom_minimum_size = Vector2(28, 28)
		dot.pressed.connect(_on_dot_pressed.bind(i))
		bar.add_child(dot)
		nav_dots.append(dot)

	nav_next = _make_nav_button("→")
	nav_next.pressed.connect(_on_next_pressed)
	bar.add_child(nav_next)


func _make_nav_button(label_text: String) -> Button:
	var btn := Button.new()
	btn.text = label_text
	btn.custom_minimum_size = Vector2(52, 40)

	var style_normal := StyleBoxFlat.new()
	style_normal.bg_color = Color(1, 1, 1, 0.07)
	style_normal.corner_radius_top_left = 10
	style_normal.corner_radius_top_right = 10
	style_normal.corner_radius_bottom_left = 10
	style_normal.corner_radius_bottom_right = 10
	btn.add_theme_stylebox_override("normal", style_normal)

	var style_hover := StyleBoxFlat.new()
	style_hover.bg_color = Color(1, 1, 1, 0.15)
	style_hover.corner_radius_top_left = 10
	style_hover.corner_radius_top_right = 10
	style_hover.corner_radius_bottom_left = 10
	style_hover.corner_radius_bottom_right = 10
	btn.add_theme_stylebox_override("hover", style_hover)

	var style_pressed := StyleBoxFlat.new()
	style_pressed.bg_color = Color(1, 1, 1, 0.22)
	style_pressed.corner_radius_top_left = 10
	style_pressed.corner_radius_top_right = 10
	style_pressed.corner_radius_bottom_left = 10
	style_pressed.corner_radius_bottom_right = 10
	btn.add_theme_stylebox_override("pressed", style_pressed)

	btn.add_theme_font_size_override("font_size", 22)
	btn.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)

	return btn


func _build_transition_overlay() -> void:
	transition_overlay = ColorRect.new()
	transition_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	transition_overlay.color = Color(0, 0, 0, 0)
	transition_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(transition_overlay)


func _build_title_screen() -> void:
	title_screen_container = Control.new()
	title_screen_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(title_screen_container)

	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.02, 0.03, 0.05, 0.95)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_screen_container.add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_screen_container.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 12)
	center.add_child(vbox)

	var sub := Label.new()
	sub.text = "ETHICS IN COMPUTING"
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.add_theme_font_size_override("font_size", 16)
	sub.add_theme_color_override("font_color", Color(0.5, 0.7, 0.6, 0.7))
	sub.uppercase = true
	vbox.add_child(sub)

	var main_title := Label.new()
	main_title.text = "The Cost of Play"
	main_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_title.add_theme_font_size_override("font_size", 72)
	main_title.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(main_title)

	var tagline := Label.new()
	tagline.text = "How Gaming Monetization Evolved to Shape Player Behavior"
	tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tagline.add_theme_font_size_override("font_size", 20)
	tagline.add_theme_color_override("font_color", Color(0.65, 0.65, 0.7, 0.8))
	vbox.add_child(tagline)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 36)
	vbox.add_child(spacer)

	var prompt := Label.new()
	prompt.text = "Press SPACE or → to begin"
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.add_theme_font_size_override("font_size", 16)
	prompt.add_theme_color_override("font_color", Color(1, 1, 1, 0.35))
	vbox.add_child(prompt)

	var tween := create_tween().set_loops()
	tween.tween_property(prompt, "modulate:a", 0.4, 1.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(prompt, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE)


# ═══════════════════════════════════════════════════════════════════
# TITLE SCREEN
# ═══════════════════════════════════════════════════════════════════

func _show_title_screen() -> void:
	title_screen_container.visible = true
	content_panel.modulate.a = 0.0

	if bg_textures.size() > 0:
		bg_rect.texture = bg_textures[0]
	color_overlay.color = eras[0].color_bg_tint


func _dismiss_title_screen() -> void:
	if transitioning:
		return

	transitioning = true
	var tween := create_tween()
	tween.tween_property(title_screen_container, "modulate:a", 0.0, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished

	title_screen_container.visible = false
	title_screen_container.queue_free()
	title_screen_container = null

	_show_era(0)

	content_panel.modulate.a = 0.0
	var fade_in := create_tween()
	fade_in.tween_property(content_panel, "modulate:a", 1.0, 0.5)
	await fade_in.finished

	transitioning = false
	_animate_content_in()


# ═══════════════════════════════════════════════════════════════════
# ERA DISPLAY
# ═══════════════════════════════════════════════════════════════════

func _show_era(index: int) -> void:
	current_era = index
	var era: Dictionary = eras[index]

	bg_rect.texture = bg_textures[index]
	color_overlay.color = era.color_bg_tint

	era_label_node.text = era.era_label
	era_label_node.add_theme_color_override("font_color", era.color_accent)

	title_label.text = era.title

	decade_label.text = era.decade
	decade_label.add_theme_color_override("font_color", era.color_accent)

	divider.color = Color(era.color_accent.r, era.color_accent.g, era.color_accent.b, 0.32)

	summary_label.clear()
	summary_label.push_color(Color(0.84, 0.84, 0.88))
	summary_label.append_text(era.summary)

	ethical_badge.text = "Ethical concern: " + str(era.ethical_label)
	ethical_badge.add_theme_color_override("font_color", era.color_accent)

	_rebuild_list(char_container, char_labels, era.characteristics, "◆ ", 15, Color(0.76, 0.76, 0.80))
	_rebuild_list(behavior_container, behavior_labels, era.user_behavior, "• ", 15, Color(0.82, 0.82, 0.88))
	_rebuild_list(manipulation_container, manipulation_labels, era.manipulation, "• ", 15, Color(1.0, 0.88, 0.88))

	example_label.text = ", ".join(era.examples)

	reflection_label.clear()
	reflection_label.push_color(Color(0.93, 0.93, 0.97))
	reflection_label.append_text(era.reflection)

	comparison_label.text = _get_comparison_text(index)

	_update_pressure(era.pressure, era.color_accent)
	_update_nav_dots(index)

	nav_prev.disabled = (index == 0)
	nav_prev.modulate.a = 0.3 if index == 0 else 1.0

	nav_next.disabled = (index >= eras.size() - 1)
	nav_next.modulate.a = 0.3 if index >= eras.size() - 1 else 1.0


func _rebuild_list(container: VBoxContainer, label_array: Array[Label], items: Array, prefix: String, font_size: int, text_color: Color) -> void:
	for child in container.get_children():
		child.queue_free()

	label_array.clear()

	for item in items:
		var lbl := Label.new()
		lbl.text = prefix + str(item)
		lbl.add_theme_font_size_override("font_size", font_size)
		lbl.add_theme_color_override("font_color", text_color)
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		container.add_child(lbl)
		label_array.append(lbl)


func _get_comparison_text(index: int) -> String:
	match index:
		0:
			return "Then: You paid to play."
		1:
			return "Then: You paid once and owned the experience."
		2:
			return "Shift: Games began earning through repeated in-game spending."
		3:
			return "Now: You often play in order to keep up, stay current, and keep paying."
		4:
			return "Takeaway: Ethical concern rises when design shapes behavior more than it respects choice."
		_:
			return ""


func _update_pressure(level: float, accent_color: Color) -> void:
	var fill_height: float = PRESSURE_BAR_HEIGHT * level
	var fill_y: float = 20 + PRESSURE_BAR_HEIGHT - fill_height

	var tween := create_tween().set_parallel(true)
	tween.tween_property(pressure_bar_fill, "position:y", fill_y, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(pressure_bar_fill, "size:y", fill_height, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(pressure_bar_fill, "color", accent_color, 0.5)

	pressure_value_label.text = str(int(level * 100)) + "%"


func _update_nav_dots(active: int) -> void:
	for i in range(nav_dots.size()):
		if i == active:
			nav_dots[i].add_theme_color_override("font_color", Color.WHITE)
			nav_dots[i].add_theme_font_size_override("font_size", 22)
		elif i < active:
			nav_dots[i].add_theme_color_override("font_color", Color(1, 1, 1, 0.45))
			nav_dots[i].add_theme_font_size_override("font_size", 18)
		else:
			nav_dots[i].add_theme_color_override("font_color", Color(1, 1, 1, 0.18))
			nav_dots[i].add_theme_font_size_override("font_size", 18)


# ═══════════════════════════════════════════════════════════════════
# TRANSITIONS
# ═══════════════════════════════════════════════════════════════════

func _go_to_era(index: int) -> void:
	if transitioning:
		return
	if index < 0 or index >= eras.size():
		return
	if index == current_era:
		return

	transitioning = true

	var fade_out := create_tween()
	fade_out.tween_property(transition_overlay, "color:a", 1.0, TRANSITION_DURATION * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await fade_out.finished

	_show_era(index)

	var fade_in := create_tween()
	fade_in.tween_property(transition_overlay, "color:a", 0.0, TRANSITION_DURATION * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await fade_in.finished

	transitioning = false
	_animate_content_in()


func _animate_content_in() -> void:
	var elements: Array[Control] = [
		era_label_node,
		title_label,
		decade_label,
		divider,
		summary_label,
		ethical_badge,
		char_header
	]

	for lbl in char_labels:
		elements.append(lbl)

	elements.append(behavior_header)
	for lbl in behavior_labels:
		elements.append(lbl)

	elements.append(manipulation_header)
	for lbl in manipulation_labels:
		elements.append(lbl)

	elements.append(example_header)
	elements.append(example_label)
	elements.append(reflection_header)
	elements.append(reflection_label)
	elements.append(comparison_label)

	for el in elements:
		el.modulate.a = 0.0
		el.position.y += 10

	for i in range(elements.size()):
		var el := elements[i]
		var delay := i * CONTENT_STAGGER
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(el, "modulate:a", 1.0, 0.30).set_delay(delay).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(el, "position:y", el.position.y - 10, 0.30).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


# ═══════════════════════════════════════════════════════════════════
# NAVIGATION CALLBACKS
# ═══════════════════════════════════════════════════════════════════

func _on_prev_pressed() -> void:
	_go_to_era(current_era - 1)


func _on_next_pressed() -> void:
	_go_to_era(current_era + 1)


func _on_dot_pressed(index: int) -> void:
	_go_to_era(index)
