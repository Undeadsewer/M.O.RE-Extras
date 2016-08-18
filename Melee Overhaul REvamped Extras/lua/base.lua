if not _G.MeleeOverhaul then
	_G.MeleeOverhaul = {}
	dofile( "mods/Melee Overhaul REvamped/lua/options.lua" )
	dofile( "mods/Melee Overhaul REvamped/lua/base.lua" )
end

MeleeOverhaul.ExtrasModPath = ModPath
MeleeOverhaul.ExtrasMenu = "MeleeOverhaulExtrasMenu"

dofile( MeleeOverhaul.ExtrasModPath .. "lua/options.lua" )

local HookFiles = {

	[ "lib/managers/menu/blackmarketgui" ] 					= "lua/blackmarketgui.lua",
	[ "lib/tweak_data/blackmarket/meleeweaponstweakdata" ] 	= "lua/meleeweaponstweakdata.lua",
	[ "lib/units/beings/player/playerdamage" ] 				= "lua/playerdamage.lua",
	[ "lib/units/beings/player/states/playerbleedout" ] 	= "lua/playerbleedout.lua",
	[ "lib/units/beings/player/states/playerstandard" ] 	= "lua/playerstandard.lua",
	[ "lib/units/enemies/cop/copbrain" ] 					= "lua/copbrain.lua",
	[ "lib/units/enemies/cop/copdamage" ] 					= "lua/copdamage.lua"

}

function MeleeOverhaul:ExtrasDefaultSettings()

	for k , v in pairs( MeleeOverhaul.ExtrasMenuOptions.Toggle ) do
		if self:HasSetting( k ) == nil then MeleeOverhaul.Options[ k ] = v[ 3 ] end
	end
	
	self:Save()

end

function MeleeOverhaul:CheckBreach( unit )

	local n = unit:name():t()
	
	for k , v in ipairs( self.BreachUnits ) do
		if v == n then return true end
	end

end

Hooks:Add( "MenuManagerSetupCustomMenus" , "MeleeOverhaulExtrasMenuManagerPostSetupCustomMenus" , function( self , nodes )

	MenuHelper:NewMenu( MeleeOverhaul.ExtrasMenu )

end )

Hooks:Add( "LocalizationManagerPostInit" , "MeleeOverhaulExtrasLocalizationManagerPostInit" , function( self )

	self:load_localization_file( MeleeOverhaul.ExtrasModPath .. "loc/english.txt" )
	
	for _ , file in pairs( file.GetFiles( MeleeOverhaul.ExtrasModPath .. "loc/" ) ) do
		local loc = file:match( '^(.*).txt$' )
		
		if loc and Idstring( loc ) and Idstring( loc ):key() == SystemInfo:language():key() then
			self:load_localization_file( MeleeOverhaul.ExtrasModPath .. "loc/" .. file )
		end
	end
	
	MeleeOverhaul:Load()
	MeleeOverhaul:ExtrasDefaultSettings()

end )

Hooks:Add( "MenuManagerBuildCustomMenus" , "MeleeOverhaulExtrasMenuManagerPostBuildCustomMenus" , function( self , nodes )
	
	nodes[ MeleeOverhaul.ExtrasMenu ] = MenuHelper:BuildMenu( MeleeOverhaul.ExtrasMenu )
    MenuHelper:AddMenuItem( nodes[ MeleeOverhaul.Menu ] , MeleeOverhaul.ExtrasMenu , "more_options_extras_options_menu_title" , "more_options_extras_options_menu_desc" , "MeleeOverhaulMenuMainOptions" , "after" )
	
end )

Hooks:Add( "MenuManagerPopulateCustomMenus" , "MeleeOverhaulExtrasMenuManagerPostPopulateCustomMenus" , function( self , nodes )
	
	for k , v in pairs( MeleeOverhaul.ExtrasMenuOptions.Toggle ) do
	
		MenuCallbackHandler[ k .. "Toggle" ] = function( self , item )
			MeleeOverhaul.Options[ k ] = item:value() == "on" or false
			MeleeOverhaul:Save()
		end
		
		MenuHelper:AddToggle({
			id 			= "ID" .. k .. "Toggle",
			title 		= v[ 1 ],
			desc 		= v[ 2 ],
			callback 	= k .. "Toggle",
			menu_id 	= MeleeOverhaul.ExtrasMenu,
			value 		= MeleeOverhaul.Options[ k ]
		})
		
	end
	
end )

if RequiredScript then

	local requiredScript = RequiredScript:lower()
	
	if HookFiles[ requiredScript ] then
		dofile( MeleeOverhaul.ExtrasModPath .. HookFiles[ requiredScript ] )
		log( "M.O.RE. Extras: mod loaded required script - \"" .. HookFiles[ requiredScript ] .. "\"" )
	end
	
end