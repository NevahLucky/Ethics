extends Node
## Central data store for all era definitions.
## Autoload this script as "EraData" in Project Settings > Autoload.

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
			"summary": "The arcade era introduced gaming to the masses through coin-operated machines. Players paid per play through a direct and visible transaction. While difficulty was often tuned to encourage replay spending, the price of participation was transparent and easy to understand.",
			"characteristics": [
				"Coin-per-play was a clear and tangible cost model",
				"Difficulty encouraged retries and repeat spending",
				"Public arcade spaces made gaming social",
				"Costs were immediate, visible, and limited"
			],
			"user_behavior": [
				"Players inserted another coin immediately after failing",
				"Sessions stayed short and spending happened in small bursts",
				"Losing felt frustrating, but the cost was obvious"
			],
			"manipulation": [
				"Difficulty spikes",
				"Short failure loops",
				"Replay pressure"
			],
			"examples": [
				"Pac-Man",
				"Space Invaders",
				"Donkey Kong"
			],
			"ethical_label": "Low Concern",
			"reflection": "When does challenge become a tool to increase spending rather than enjoyment?",
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
			"summary": "The retail era brought gaming into the home. Players usually paid once for a complete product and could access the full experience without repeated transactions. Compared with later eras, this model gave players more certainty, ownership, and control over spending.",
			"characteristics": [
				"One-time purchase unlocked the full game",
				"No recurring payments were expected after purchase",
				"Physical ownership added perceived value",
				"Game quality, not spending loops, drove success"
			],
			"user_behavior": [
				"Players focused on finishing or mastering a game they already owned",
				"Spending decisions happened before play, not during it",
				"Replay value came from content, not monetization pressure"
			],
			"manipulation": [
				"Limited expansion sales",
				"Brand loyalty",
				"Hardware lock-in"
			],
			"examples": [
				"Super Mario Bros.",
				"The Legend of Zelda",
				"Final Fantasy VII"
			],
			"ethical_label": "Lower Concern",
			"reflection": "What changed when games stopped being sold as complete products?",
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
			"summary": "Digital distribution lowered the barrier to entry and popularized free-to-play games, but it also normalized microtransactions for cosmetics, progression, and chance-based rewards. Design increasingly shifted from selling a full experience to encouraging repeated in-game purchases.",
			"characteristics": [
				"Free-to-play often became pay-to-progress",
				"Loot boxes introduced chance-based spending",
				"Small purchases felt harmless but accumulated over time",
				"Content design increasingly pushed players toward spending"
			],
			"user_behavior": [
				"Players spent impulsively because prices seemed small",
				"Progress frustration encouraged purchases to save time",
				"Rare cosmetic items triggered repeated spending attempts",
				"Players returned for rotating content and rewards"
			],
			"manipulation": [
				"Variable rewards",
				"Loot boxes",
				"Progress gating",
				"Scarcity framing"
			],
			"examples": [
				"FIFA Ultimate Team",
				"Clash of Clans",
				"Overwatch loot boxes"
			],
			"ethical_label": "High Concern",
			"reflection": "Are players making free choices, or are they being nudged by frustration and uncertainty?",
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
			"summary": "Modern live-service games rely on subscriptions, battle passes, timed events, rotating shops, and seasonal rewards. The business model no longer depends only on a purchase, but on maintaining long-term engagement and turning attention, habit, and anxiety into revenue.",
			"characteristics": [
				"Battle passes create recurring spending cycles",
				"FOMO drives engagement through limited-time rewards",
				"Subscriptions stack costs over time",
				"Players become long-term revenue sources instead of one-time customers"
			],
			"user_behavior": [
				"Players log in daily to avoid missing rewards",
				"Time-limited offers trigger impulse purchases",
				"Social comparison encourages cosmetic spending",
				"Many keep playing out of obligation rather than enjoyment"
			],
			"manipulation": [
				"FOMO",
				"Daily streaks",
				"Timed exclusives",
				"Social pressure",
				"Recurring monetization layers"
			],
			"examples": [
				"Fortnite Battle Pass",
				"Call of Duty seasonal bundles",
				"Genshin Impact gacha system"
			],
			"ethical_label": "Very High Concern",
			"reflection": "When a game pressures people to keep paying and returning, is it still just entertainment?",
			"pressure": 1.0,
			"bg_image": "res://assets/backgrounds/era_4_esports.png",
		},
		{
			"title": "ETHICAL TAKEAWAY",
			"era_label": "CONCLUSION",
			"decade": "Today",
			"color_primary": Color("#3C096C"),
			"color_secondary": Color("#5A189A"),
			"color_accent": Color("#C77DFF"),
			"color_bg_tint": Color(0.12, 0.05, 0.18, 0.45),
			"summary": "Gaming monetization evolved from visible payment into systems that often shape habits, attention, and spending behavior. The ethical issue is not whether games make money, but whether they do so in a way that respects player autonomy, especially for younger and more vulnerable players.",
			"characteristics": [
				"Modern monetization often targets behavior, not just purchases",
				"Psychological design can weaken informed choice",
				"Awareness helps players recognize manipulative systems",
				"Ethical design should respect time, money, and well-being"
			],
			"user_behavior": [
				"Players may confuse habit with enjoyment",
				"Awareness can reduce impulsive spending",
				"Reflection helps identify manipulative design patterns"
			],
			"manipulation": [
				"Psychological pressure",
				"Behavior shaping",
				"Artificial urgency"
			],
			"examples": [
				"Battle passes",
				"Rotating shops",
				"Daily reward systems"
			],
			"ethical_label": "Key Reflection",
			"reflection": "Next time you spend in a game, ask: was it your choice, or was the system designed to push you there?",
			"pressure": 0.9,
			"bg_image": "res://assets/backgrounds/era_5_conclusion.png",
		},
	]


static func get_era_count() -> int:
	return get_eras().size()
