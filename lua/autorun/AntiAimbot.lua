
if SERVER then

	AddCSLuaFile("autorun/client/cl_AntiAimbot.lua")
	AddCSLuaFile("autorun/client/cl_derma.lua")
	
	local kiddyscript = {}

	util.AddNetworkString( "Anti_Aimbot" )
	util.AddNetworkString( "Anti_Aimbot_Signal" )
	util.AddNetworkString( "Anti_Aimbot_menu" )
	util.AddNetworkString( "Anti_Aimbot_menu_Elements" )

	function kiddyscript_TakeDamage( ply, attacker )
		if kiddyscript[attacker] then
			if kiddyscript[attacker].SetEyeAnglesTrigger == true then return false end
		end
	end

	local function GetAimAngles()
	 	for k,v in pairs(player.GetAll()) do
	 		if v:IsValid() then
	 			if !kiddyscript[v] then kiddyscript[v] = {} end
	 			if !kiddyscript[v].Focus then kiddyscript[v].Focus = 0 end
	 			--if kiddyscript[v].Focus > 0 then  print(kiddyscript[v].Focus) end
	 			if istable( v:GetEyeTrace() ) then
	 				if v:GetEyeTrace().Entity:IsValid() then
	 					if v:GetEyeTrace().Entity:GetClass() == "player" then
							if v:GetEyeTrace().Entity:GetVelocity():Length() > 400 and v:GetPos():Distance( v:GetEyeTrace().Entity:GetPos() ) > 500 then
								kiddyscript[v].Focus = kiddyscript[v].Focus + v:GetEyeTrace().Entity:GetVelocity():Length()/100 + v:GetPos():Distance( v:GetEyeTrace().Entity:GetPos() )/100
							end
						elseif kiddyscript[v].Focus > 5 then
							kiddyscript[v].Focus = kiddyscript[v].Focus - 2.5
						end
					end
				end
	
				if kiddyscript[v].Focus > 1000 then  v:Kick("Aimbot") end
			end
		end
	 end

	hook.Add("Tick","Anti_Aimbot",GetAimAngles)

	hook.Add("PlayerShouldTakeDamage","Anti_Aimbot",kiddyscript_TakeDamage)

	net.Receive( "Anti_Aimbot", function( len, ply )
		if !kiddyscript[ply] then kiddyscript[ply] = {} end
		kiddyscript[ply].Script = net.ReadString()
		kiddyscript[ply].SetEyeAnglesTrigger = true
		if !timer.Exists( ply:SteamID() ) then
			timer.Create( ply:SteamID(), 2, 0, function() kiddyscript[ply].SetEyeAnglesTrigger = false timer.Remove( ply:SteamID() ) end )
		else
			timer.Adjust( ply:SteamID(), 2, 0, function() kiddyscript[ply].SetEyeAnglesTrigger = false timer.Remove( ply:SteamID() ) end )
		end
		--PrintTable(kiddyscript)

		if file.Exists( kiddyscript[ply].Script, "MOD" ) then end
	end )


	net.Receive( "Anti_Aimbot_Signal", function( len, ply )
		ply:Kick(net.ReadString())
	end )

	net.Receive( "Anti_Aimbot_menu", function( len, ply )
		if ply:IsAdmin() or ply:IsSuperAdmin() then
			net.Start( "Anti_Aimbot_menu_Elements" , true)
			net.WriteTable(kiddyscript)
			net.Send( ply )
		end
	end )

end

include("autorun/client/cl_AntiAimbot.lua")
include("autorun/client/cl_derma.lua")