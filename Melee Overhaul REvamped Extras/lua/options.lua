MeleeOverhaul.ExtrasMenuOptions = MeleeOverhaul.ExtrasMenuOptions or {}
MeleeOverhaul.ExtrasMenuOptions.Toggle = {
	
	[ "MeleeSprinting" ] = {
		"more_options_toggle_melee_sprinting_title",
		"more_options_toggle_melee_sprinting_desc",
		false
	},
	
	[ "MeleeHeadshots" ] = {
		"more_options_toggle_melee_headshots_title",
		"more_options_toggle_melee_headshots_desc",
		false
	},
	
	[ "MeleeBreaching" ] = {
		"more_options_toggle_melee_breaching_title",
		"more_options_toggle_melee_breaching_desc",
		false
	},
	
	[ "MeleeEnhancers" ] = {
		"more_options_toggle_melee_enhancer_title",
		"more_options_toggle_melee_enhancer_desc",
		false
	},
	
	[ "PagerSnatch" ] = {
		"more_options_toggle_pager_snatch_title",
		"more_options_toggle_pager_snatch_desc",
		false
	}
	
}

MeleeOverhaul.Enhancements = {
	"electric",
	"poison",
	"incinerated",
	"blood_lust",
	"kleptomaniac",
	"aftershock",
	"swiftness"
}
table.sort( MeleeOverhaul.Enhancements )

MeleeOverhaul.EnhancementCooldown = {
	[ "incinerated" ] 	= 10,
	[ "blood_lust" ] 	= 0.5,
	[ "kleptomaniac" ] 	= 3,
	[ "aftershock" ] 	= 10,
	[ "swiftness" ] 	= 3.5
}

MeleeOverhaul.BreachUnits = {
	-- Doors
	"@ID08a33537c9d0673a@",
	"@ID18a7caca12899b38@",
	"@ID851f3239dec9d210@",
	"@ID622b34ce3cd1d3bb@",
	"@ID1d283db01fc4a72b@",
	"@IDcffcea35596d6b53@",
	
	-- Barricades
	"@IDb55faf1195846400@",
	"@IDb524e472a247f6ff@",
	"@IDb71bf75755b6181b@",
	"@IDe86b68a126c540da@",
	"@ID945dcbc3586178cd@"
}