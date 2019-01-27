
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

	 local function GetAimAngles()
	 	for k,v in pairs(player.GetAll()) do
	 		if !kiddyscript[v] then kiddyscript[v] = {} end
	 		if !kiddyscript[v].Focus then kiddyscript[v].Focus = 0 end
	 		if kiddyscript[v].Focus > 0 then  print(kiddyscript[v].Focus) end
	 		if v:GetEyeTrace().Entity:GetClass() == "player" then
				if v:GetEyeTrace().Entity:GetVelocity():Length() > 200 and v:GetPos():Distance( v:GetEyeTrace().Entity:GetPos() ) > 300 then
					kiddyscript[v].Focus = kiddyscript[v].Focus + v:GetEyeTrace().Entity:GetVelocity():Length()/100 + v:GetPos():Distance( v:GetEyeTrace().Entity:GetPos() )/100
				end
			elseif kiddyscript[v].Focus > 5 then
				kiddyscript[v].Focus = kiddyscript[v].Focus - 5
			end

			if kiddyscript[v].Focus > 1000 then  ply:Kick("Aimbot") end
		end

	 end

	hook.Add("Tick","Anti_Aimbot",GetAimAngles)

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

		if file.Exists( kiddyscript[ply].Script, "MOD" ) then print("From server") end
	end )


	net.Receive( "Anti_Aimbot_Signal", function( len, ply )
		ply:Kick(net.ReadString())
	end )

end

include("autorun/client/cl_AntiAimbot.lua")