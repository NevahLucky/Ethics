extends Node
## Central data store for all era definitions.
## Autoloaded as "EraData" so any script can access it.

## Returns the array of all era dictionaries.
static func get_eras() -> Array:
	return [
		{
			"title": "PAY TO PLAY",
			"era_label": "ERA I",
			"decade": "1970s",
			"color_primary": Color("#2D6A4F"),
			"color_secondary": Color("#40916C"),
			"color_accent": Color("#52B788"),
			"color_bg_tint": Color(0.05, 0.15, 0.1, 0.35),
			"summary": "The arcade era introduced gaming to the masses through coin-operated machines. Players paid per play — a direct, visible transaction. While difficulty was tuned to encourage spending, the cost was transparent and the experience was shared in public social spaces.",
			"characteristics": [
				"Coin-per-play: a transparent, tangible cost model",
				"Difficulty tuned to drive replay spending",
				"Shared social spaces fostered community",
				"No hidden costs or ongoing commitments"
			],
			"pressure": 0.25,
			"bg_image": "res://assets/backgrounds/era_1_arcade.png",
		},
		{
			"title": "RETAIL & BOXED",
			"era_label": "ERA II",
			"decade": "1980s – 1990s",
			"color_primary": Color("#1B4965"),
			"color_secondary": Color("#5FA8D3"),
			"color_accent": Color("#BEE9E8"),
			"color_bg_tint": Color(0.05, 0.1, 0.18, 0.35),
			"summary": "The retail era brought gaming home. Players purchased a complete experience for a fixed price — one transaction unlocked the entire game. This model respected the consumer with no hidden costs, delivering full value upfront.",
			"characteristics": [
				"One-time purchase for the complete experience",
				"No additional payments required after purchase",
				"Physical ownership gave tangible value",
				"Game quality drove sales, not spending hooks"
			],
			"pressure": 0.45,
			"bg_image": "res://assets/backgrounds/era_2_living_room.png",
		},
		{
			"title": "DIGITAL & MICROTRANSACTIONS",
			"era_label": "ERA III",
			"decade": "2000s – 2010s",
			"color_primary": Color("#E09F3E"),
			"color_secondary": Color("#D4770B"),
			"color_accent": Color("#FFBA49"),
			"color_bg_tint": Color(0.2, 0.12, 0.03, 0.4),
			"summary": "Digital distribution lowered barriers to entry with free-to-play models, but introduced microtransactions — small, frequent purchases for cosmetics, power, or progression. Game design increasingly funneled players toward spending.",
			"characteristics": [
				"'Free to play' masks pay-to-progress design",
				"Loot boxes introduce gambling mechanics",
				"Psychological triggers exploit impulse spending",
				"Endless content drip replaces complete experiences"
			],
			"pressure": 0.75,
			"bg_image": "res://assets/backgrounds/era_3_bedroom.png",
		},
		{
			"title": "SUBSCRIPTIONS & LIVE SERVICE",
			"era_label": "ERA IV",
			"decade": "2020s",
			"color_primary": Color("#AE2012"),
			"color_secondary": Color("#D00000"),
			"color_accent": Color("#FF5C5C"),
			"color_bg_tint": Color(0.22, 0.04, 0.04, 0.45),
			"summary": "Modern gaming demands perpetual spending through subscriptions, battle passes, and seasonal content. FOMO-driven design creates constant pressure to stay current, turning leisure into obligation and players into revenue streams.",
			"characteristics": [
				"Battle passes create time-pressured spending cycles",
				"FOMO drives engagement through artificial scarcity",
				"Subscription layers stack recurring costs",
				"Players become ongoing revenue streams, not customers"
			],
			"pressure": 1.0,
			"bg_image": "res://assets/backgrounds/era_4_esports.png",
		},
	]


## Returns how many eras are defined.
static func get_era_count() -> int:
	return get_eras().size()
