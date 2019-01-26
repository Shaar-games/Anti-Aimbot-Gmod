



if SERVER then

	AddCSLuaFile("autorun/client/cl_AntiAimbot.lua")
	
	local kiddyscript = {}

	util.AddNetworkString( "Anti_Aimbot" )
	util.AddNetworkString( "Anti_Aimbot_Signal" )

	function kiddyscript_TakeDamage( ply, attacker )
		if kiddyscript[attacker] then
			if kiddyscript[attacker].SetEyeAnglesTrigger == true then return false end
		end
	 end

	hook.Add("PlayerShouldTakeDamage","Anti_Aimbot",kiddyscript_TakeDamage)

	net.Receive( "Anti_Aimbot", function( len, ply )
		if !kiddyscript[ply] then kiddyscript[ply] = {} end
		kiddyscript[ply].Script = net.ReadString()
		kiddyscript[ply].SetEyeAnglesTrigger = true
		if !timer.Exists( ply:SteamID() ) then
			timer.Create( ply:SteamID(), 2, 0, function() kiddyscript[ply].SetEyeAnglesTrigger = false print("reactivate") timer.Remove( ply:SteamID() ) end )
		else
			timer.Adjust( ply:SteamID(), 2, 0, function() kiddyscript[ply].SetEyeAnglesTrigger = false print("reactivate") timer.Remove( ply:SteamID() ) end )
		end
		PrintTable(kiddyscript)
	end )


	net.Receive( "Anti_Aimbot_Signal", function( len, ply )
		ply:Kick(net.ReadString())
	end )

end

include("autorun/client/cl_AntiAimbot.lua")