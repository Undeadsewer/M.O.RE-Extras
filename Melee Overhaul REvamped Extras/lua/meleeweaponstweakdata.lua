Hooks:PostHook( BlackMarketTweakData , "_init_melee_weapons" , "MeleeOverhaulExtrasBlackMarketTweakDataPostInitMeleeWeapons" , function( self , tweak_data )

	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		for k , v in pairs( self.melee_weapons ) do
			if MeleeOverhaul.Options[ k ] then
				if MeleeOverhaul.Options[ k ] == "electric" then
					v.special_weapon = "taser"
					v.stats.min_damage = v.stats.min_damage * 0.5
					v.stats.max_damage = v.stats.min_damage
				elseif MeleeOverhaul.Options[ k ] == "poison" then
					v.dot_data = {
						type = "poison",
						custom_data = { dot_length = 1 , hurt_animation_chance = 0.7 }
					}
					v.stats.min_damage = v.stats.min_damage * 0.75
					v.stats.max_damage = v.stats.max_damage * 0.75
				end
			end
		end
	end

end )