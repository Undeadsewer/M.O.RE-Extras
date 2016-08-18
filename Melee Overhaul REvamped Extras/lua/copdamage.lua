Hooks:PreHook( CopDamage , "damage_melee" , "MeleeOverhaulExtrasCopDamagePreDamageMelee" , function( self , attack_data )

	if MeleeOverhaul:HasSetting( "MeleeHeadshots" ) then
		local body = attack_data.body_name or attack_data.col_ray.body:name()
		local head = body:key() == Idstring( "head" ):key() or body:key() == Idstring( "hit_Head" ):key() or body:key() == Idstring( "rag_Head" ):key()
		
		if head and attack_data.attacker_unit and attack_data.attacker_unit:key() == managers.player:player_unit():key() then
			attack_data.damage = attack_data.damage * 1.25
		end
	end
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		
		if not self._dead and attack_data.attacker_unit and attack_data.attacker_unit:key() == managers.player:player_unit():key() and MeleeOverhaul.Options[ melee_entry ] and not PlayerDamage.is_friendly_fire( self , attack_data.attacker_unit ) and not CopDamage.is_civilian( self._unit:base()._tweak_table ) then
			if not managers.player:player_unit():movement():current_state()._state_data.melee_enhancement_expire_t then
			
				if MeleeOverhaul.Options[ melee_entry ] == "incinerated" then
					managers.player:player_unit():movement():current_state()._state_data.melee_enhancement_expire_t = managers.player:player_timer():time() + MeleeOverhaul.EnhancementCooldown[ "incinerated" ]
				
					managers.fire:add_doted_enemy( self._unit , managers.player:player_timer():time() , managers.player:player_unit() , 5 , attack_data.damage * 0.25 )
					
					managers.network:session():send_to_peers_synched( "sync_add_doted_enemy" , self._unit , managers.player:player_timer():time() , managers.player:player_unit() , 5 , attack_data.damage * 0.25 )
					managers.fire:start_burn_body_sound( { enemy_unit = self._unit } , 5 )
					
					World:effect_manager():spawn({
						effect = Idstring( "effects/payday2/particles/explosions/molotov_grenade_enemy_on_fire_5s" ),
						parent = self._unit:get_object( Idstring( "Spine" ) )
					})
				elseif MeleeOverhaul.Options[ melee_entry ] == "blood_lust" then
					if 0.5 >= math.rand( 1 ) then
						managers.player:player_unit():movement():current_state()._state_data.melee_enhancement_expire_t = managers.player:player_timer():time() + MeleeOverhaul.EnhancementCooldown[ "blood_lust" ]
						
						managers.player:player_unit():character_damage():restore_health( math.rand( 3 , 5 ) , true )
					end
				elseif MeleeOverhaul.Options[ melee_entry ] == "kleptomaniac" then
					if 0.75 >= math.rand( 1 ) then
						managers.player:player_unit():movement():current_state()._state_data.melee_enhancement_expire_t = managers.player:player_timer():time() + MeleeOverhaul.EnhancementCooldown[ "kleptomaniac" ]
						
						for id , weapon in pairs( managers.player:player_unit():inventory():available_selections() ) do
							weapon.unit:base():add_ammo( 3 )
							managers.hud:set_ammo_amount( id , weapon.unit:base():ammo_info() )
						end
						managers.player:player_unit():sound():play( "pickup_ammo_health_boost" )
					end
				end
			
			end
		end
	end

end )

Hooks:PostHook( CopDamage , "damage_melee" , "MeleeOverhaulExtrasCopDamagePostDamageMelee" , function( self , attack_data )

	if MeleeOverhaul:HasSetting( "PagerSnatch" ) then
		if attack_data.attacker_unit and attack_data.attacker_unit:key() == managers.player:player_unit():key() and attack_data.result and attack_data.result.type == "death" then
			if self._unit:unit_data().has_alarm_pager and 0.3 >= math.rand( 1 ) then
				self._unit:brain()._pager_snatched = true
			end
		end
	end
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		
		if attack_data.result and attack_data.result.type == "death" and attack_data.attacker_unit and attack_data.attacker_unit:key() == managers.player:player_unit():key() and MeleeOverhaul.Options[ melee_entry ] and not PlayerDamage.is_friendly_fire( self , attack_data.attacker_unit ) and not CopDamage.is_civilian( self._unit:base()._tweak_table ) then
			if not managers.player:player_unit():movement():current_state()._state_data.melee_enhancement_expire_t then
			
				if MeleeOverhaul.Options[ melee_entry ] == "swiftness" then
					managers.player:player_unit():movement():current_state()._state_data.melee_enhancement_expire_t = managers.player:player_timer():time() + MeleeOverhaul.EnhancementCooldown[ "swiftness" ]
					
					managers.player:player_unit():movement():on_morale_boost( managers.player:player_unit() )
				end
				
			end
		end
	end

end )