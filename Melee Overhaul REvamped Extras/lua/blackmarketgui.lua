function MeleeOverhaul:ShowEnhanceMenu( gui , data )

	local menu_title = managers.localization:text( "more_options_toggle_melee_enhancer_title" ) .. ": " .. managers.localization:text( tweak_data.blackmarket.melee_weapons[ data.name ].name_id )
	local menu_desc = ""
	local menu_options = {}
	
	for k , v in pairs( MeleeOverhaul.Enhancements ) do
		menu_desc = menu_desc .. "\n" .. managers.localization:text( "more_options_enhancement_" .. v .. "_title" ):upper() .. ": " .. managers.localization:text( "more_options_enhancement_" .. v .. "_desc" ) .. "\n"
		table.insert( menu_options , {
			text = ( MeleeOverhaul.Options[ data.name ] == v and managers.localization:text( "more_options_enhancement_remove" ) or managers.localization:text( "more_options_enhancement_apply" ) ) .. " \"" .. managers.localization:text( "more_options_enhancement_" .. v .. "_title" ) .. "\"",
			callback = function()
				if MeleeOverhaul.Options[ data.name ] and MeleeOverhaul.Options[ data.name ] == v then
					MeleeOverhaul.Options[ data.name ] = nil
				else
					MeleeOverhaul.Options[ data.name ] = v
				end
				
				MeleeOverhaul:Save()
				managers.menu_component:post_event( "finalize_mask" )
				gui:reload()
			end
		})
	end
	
	table.insert( menu_options , {
		text = managers.localization:text( "more_options_enhancement_cancel" ),
		is_cancel_button = true
	})
	
	self.EnhanceMenu = QuickMenu:new( menu_title , menu_desc , menu_options )
	self.EnhanceMenu:Show()

end

function BlackMarketGui:update_enhance_text()

	local tab_data = self._tabs[ self._selected ]._data
	local identifier = tab_data.identifier
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		if identifier == self.identifiers.melee_weapon and self._panel:child( "custom_name_text" ) and not MeleeOverhaul.Options[ self._slot_data.name ] then
			self._panel:child( "custom_name_text" ):set_text( "" )
		elseif identifier == self.identifiers.melee_weapon and self._panel:child( "custom_name_text" ) and MeleeOverhaul.Options[ self._slot_data.name ] then
			self._panel:child( "custom_name_text" ):set_text( managers.localization:text( "more_options_enhancement_" .. MeleeOverhaul.Options[ data.name ] .. "_title" ) )
			self._panel:child( "custom_name_text" ):set_color( tweak_data.screen_colors.community_color )
		end
	end

end

function BlackMarketGui:enhance_melee_weapon( data )
	MeleeOverhaul:ShowEnhanceMenu( self , data )
end

Hooks:PostHook( BlackMarketGui , "_setup" , "MeleeOverhaulExtrasBlackMarketGuiPostSetup" , function( self , is_start_page , component_data )
	
	local lo_mw_enhance = {
		prio 		= 6,
		btn 		= "BTN_Y",
		pc_btn 		= nil,
		name 		= "bm_menu_btn_enhance_melee_weapon",
		callback 	= callback( self , self , "enhance_melee_weapon" )
	}
	
	self._btns[ "lo_mw_enhance" ] = BlackMarketGuiButtonItem:new( self._buttons , lo_mw_enhance , 10 )
	
	if self._selected_slot then
		self:show_btns( self._selected_slot )
	end
	
end )

Hooks:PostHook( BlackMarketGui , "populate_melee_weapons_new" , "MeleeOverhaulExtrasBlackMarketGuiPostPopulateMeleeWeaponsNew" , function( self , data )
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		local restrictions = {
			[ "taser" ] = true,
			[ "cqc" ] = true,
			[ "zeus" ] = true
		}
		
		for i , melee_weapon_data in ipairs( data.on_create_data ) do
			if data.allow_preview and melee_weapon_data[ 2 ].unlocked and not restrictions[ melee_weapon_data[ 1 ] ] then
				table.insert( data[ i ] , "lo_mw_enhance" )
			end
		end
	end

end )

Hooks:PostHook( BlackMarketGui , "update_info_text" , "MeleeOverhaulExtrasBlackMarketGuiPostUpdateInfoText" , function( self )

	self:update_enhance_text()

end )

Hooks:PostHook( BlackMarketGui , "_post_reload" , "MeleeOverhaulExtrasBlackMarketGuiPostPostReload" , function( self )

	if self._selected_slot then
		self:show_btns( self._selected_slot )
	end

end )

Hooks:PreHook( BlackMarketGuiSlotItem , "init" , "MeleeOverhaulExtrasBlackMarketGuiSlotItemPreInit" , function( self , main_panel , data , x , y , w , h )
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		if not data.custom_name_text and MeleeOverhaul.Options[ data.name ] then
			data.custom_name_text = managers.localization:text( "more_options_enhancement_" .. MeleeOverhaul.Options[ data.name ] .. "_title" )
		end
	end

end )

Hooks:PostHook( BlackMarketGuiSlotItem , "init" , "MeleeOverhaulExtrasBlackMarketGuiSlotItemPostInit" , function( self , main_panel , data , x , y , w , h )
	
	if MeleeOverhaul:HasSetting( "MeleeEnhancers" ) then
		if data.custom_name_text and MeleeOverhaul.Options[ data.name ] then
			self._panel:child( "custom_name_text" ):set_color( tweak_data.screen_colors.community_color )
		end
	end

end )