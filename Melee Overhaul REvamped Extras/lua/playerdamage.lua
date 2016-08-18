Hooks:PreHook( PlayerDamage , "_calc_health_damage" , "MeleeOverhaulExtrasPlayerDamagePostCalcHealthDamage", function( self , attack_data )

	if self._unit:key() == managers.player:player_unit():key() then
		if managers.player:player_unit():movement():current_state():_is_meleeing() and managers.blackmarket:equipped_melee_weapon() == "buck" then
			attack_data.damage = attack_data.damage * 0.5
		end
	end

end )

Hooks:PreHook( PlayerDamage , "_calc_armor_damage" , "MeleeOverhaulExtrasPlayerDamagePostCalcArmorDamage" , function( self , attack_data )

	if self._unit:key() == managers.player:player_unit():key() then
		if managers.player:player_unit():movement():current_state():_is_meleeing() and managers.blackmarket:equipped_melee_weapon() == "buck" then
			attack_data.damage = attack_data.damage * 0.3
		end
	end

end )