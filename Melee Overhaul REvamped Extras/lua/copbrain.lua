Hooks:PostHook( CopBrain , "clbk_alarm_pager" , "MeleeOverhaulExtrasCopBrainPostClbkAlarmPager" , function( self , ignore_this , data )

	if self._pager_snatched and managers.groupai:state():get_nr_successful_alarm_pager_bluffs() < 4 then
		self._pager_snatched = nil
		self._unit:interaction():interact( managers.player:player_unit() )
	end

end )