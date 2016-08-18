Hooks:PostHook( PlayerBleedOut , "update" , "MeleeOverhaulExtrasPlayerBleedOutPostUpdate" , function( self , t , dt )

	local input = self:_get_input()
	
	self:_update_melee_timers( t , input )
	self:_check_action_melee( t , input )

end )