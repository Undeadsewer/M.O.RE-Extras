Hooks:PostHook( PlayerStandard , "_start_action_running" , "MeleeOverhaulExtrasPlayerStandardPostStartActionRunning" , function( self , t )

	if MeleeOverhaul:HasSetting( "MeleeSprinting" ) then
		if not self._move_dir then
			self._running_wanted = true
			return
		end
		
		if self:on_ladder() or self:_on_zipline() then
			return
		end
		
		if self._shooting and not managers.player.RUN_AND_SHOOT or self:_changing_weapon() or self._use_item_expire_t or self._state_data.in_air or self:_is_throwing_projectile() or self:_is_charging_weapon() then
			self._running_wanted = true
			return
		end
		
		if self._state_data.ducking and not self:_can_stand() then
			self._running_wanted = true
			return
		end
		
		if not self:_can_run_directional() then
			return
		end
		
		if not self:_is_meleeing() and self._camera_unit:base()._melee_item_units then
			self._running_wanted = true
			return
		end
		
		self._running_wanted = false
		
		if managers.player:get_player_rule( "no_run" ) then
			return
		end
		
		if not self._unit:movement():is_above_stamina_threshold() then
			return
		end
		
		if (not self._state_data.shake_player_start_running or not self._ext_camera:shaker():is_playing( self._state_data.shake_player_start_running ) ) and managers.user:get_setting( "use_headbob" ) then
			self._state_data.shake_player_start_running = self._ext_camera:play_shaker( "player_start_running" , 0.75 )
		end
		
		self:set_running( true )
		
		self._end_running_expire_t = nil
		self._start_running_t = t
		
		if not self.RUN_AND_RELOAD then
			self:_interupt_action_reload( t )
		end
		
		self:_interupt_action_steelsight( t )
		self:_interupt_action_ducking( t )
	end

end )

function PlayerStandard:_end_action_running( t )
	if not self._end_running_expire_t then
		local speed_multiplier = self._equipped_unit:base():exit_run_speed_multiplier()
		
		self._end_running_expire_t = t + 0.4 / speed_multiplier
		if not self:_is_meleeing() then
			if not managers.player.RUN_AND_SHOOT and ( not managers.player.RUN_AND_RELOAD or not self:_is_reloading() ) then
				self._ext_camera:play_redirect( self.IDS_STOP_RUNNING , speed_multiplier )
			end
		end
	end
end

Hooks:PreHook( PlayerStandard , "_start_action_melee" , "MeleeOverhaulExtrasPlayerStandardPreStartActionMelee" , function( self , t , input , instant )

	self._state_data.melee_running_wanted = MeleeOverhaul:HasSetting( "MeleeSprinting" ) and self._running and not self._end_running_expire_t

end )

Hooks:PostHook( PlayerStandard , "_start_action_melee" , "MeleeOverhaulExtrasPlayerStandardPostStartActionMelee" , function( self , t , input , instant )

	if self._state_data.melee_running_wanted then
		self._running_wanted = true
	end
	self._state_data.melee_running_wanted = nil

end )

Hooks:PreHook( PlayerStandard , "_update_melee_timers" , "MeleeOverhaulExtrasPlayerStandardPreUpdateMeleeTimers" , function( self , t , input )

	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local instant = tweak_data.blackmarket.melee_weapons[ melee_entry ].instant
	
	if not instant and not self._state_data.melee_repeat_expire_t and self._state_data.melee_expire_t and t >= self._state_data.melee_expire_t then
		if self._running and not self._end_running_expire_t then
			if not self:_is_reloading() or not self.RUN_AND_RELOAD then
				if not managers.player.RUN_AND_SHOOT and not self._state_data.meleeing then
					self._ext_camera:play_redirect( self.IDS_START_RUNNING )
				else
					if not self._state_data.meleeing then
						self._ext_camera:play_redirect( self.IDS_IDLE )
					end
				end
			end
		end
	end
	
	if instant and self._state_data.melee_expire_t and t >= self._state_data.melee_expire_t then
		if self._running and not self._end_running_expire_t then
			if not self:_is_reloading() or not self.RUN_AND_RELOAD then
				if not managers.player.RUN_AND_SHOOT and not self._state_data.meleeing then
					self._ext_camera:play_redirect( self.IDS_START_RUNNING )
				else
					if not self._state_data.meleeing then
						self._ext_camera:play_redirect( self.IDS_IDLE )
					end
				end
			end
		end
	end

end )

Hooks:PostHook( PlayerStandard , "_do_melee_damage" , "MeleeOverhaulExtrasPlayerStandardPostDoMeleeDamage" , function( self , t , bayonet_melee , melee_hit_ray )

	if MeleeOverhaul:HasSetting( "MeleeBreaching" ) then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		local sphere_cast_radius = 20
		local col_ray
		
		if melee_hit_ray then
			col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
		else
			col_ray = self:_calc_melee_hit_ray( t , sphere_cast_radius )
		end
		
		if col_ray and alive( col_ray.unit ) then
			if MeleeOverhaul:CheckBreach( col_ray.unit ) then
				if not self._state_data.breach_expire_t then
					self._state_data.breach_expire_t = t + 1
					InstantBulletBase:on_collision( col_ray , managers.player:player_unit() , managers.player:player_unit() , 1 )
				end
			end
		end
		
		if managers.interaction:active_unit() and melee_entry == "cutters" then
			if managers.interaction:active_unit():interaction().tweak_data == "cut_fence" then
				managers.interaction:active_unit():interaction():interact( managers.player:player_unit() )
			end
		end
	end
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		
		if not self._state_data.melee_enhancement_expire_t then
			if MeleeOverhaul.Options[ melee_entry ] == "aftershock" and not managers.groupai:state():whisper_mode() then
				local sphere_cast_radius = 20
				local col_ray
				
				if melee_hit_ray then
					col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
				else
					col_ray = self:_calc_melee_hit_ray( t , sphere_cast_radius )
				end
				
				if col_ray and alive( col_ray.unit ) then
					self._state_data.melee_enhancement_expire_t = t + MeleeOverhaul.EnhancementCooldown[ "aftershock" ]
					
					local targets = World:find_units_quick( "sphere" , self._unit:movement():m_pos() , 1500 , managers.slot:get_mask( "trip_mine_targets" ) )
					for _ , unit in ipairs( targets ) do
						if alive( unit ) and not managers.enemy:is_civilian( self._unit ) then
							local action_data = {
								variant 		= "counter_spooc",
								damage 			= 0,
								damage_effect 	= 1,
								attacker_unit 	= self._unit,
								col_ray 		= {
													body 		= unit:body( "body" ),
													position 	= unit:position() + math.UP * 100
												},
								attack_dir 		= self._unit:movement():m_head_rot():y()
							}
							unit:character_damage():damage_melee( action_data )
						end
					end
					self._ext_camera:play_shaker( "player_fall_damage" , 5 )
				end
			end
		end
	end
		
end )

Hooks:PostHook( PlayerStandard , "_update_melee_timers" , "MeleeOverhaulExtrasPlayerStandardPostUpdateMeleeTimers" , function( self , t , input )

	if self._state_data.breach_expire_t and t >= self._state_data.breach_expire_t then
		self._state_data.breach_expire_t = nil
	end
	
	if self._state_data.melee_enhancement_expire_t and t >= self._state_data.melee_enhancement_expire_t then
		self._state_data.melee_enhancement_expire_t = nil
	end

end )

Hooks:PostHook( PlayerStandard , "_interupt_action_melee" , "MeleeOverhaulExtrasPlayerStandardPostInteruptActionMelee" , function( self , t )

	if MeleeOverhaul:HasSetting( "MeleeSprinting" ) then
		local running = self._running and not self._end_running_expire_t
		
		self:_interupt_action_running( t )
		
		if running then
			self._running_wanted = true
		end
	end

end )