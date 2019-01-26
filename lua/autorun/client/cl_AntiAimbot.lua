
if CLIENT then

	local kiddyscript = {}

	kiddyAntiAim = {}
	
	kiddyscript.Focus = 0
	kiddyscript.SetEyeAnglesTrigger = false
	kiddyscript.User = LocalPlayer()
	kiddyscript.RWeapon = FindMetaTable("Weapon")
	kiddyscript.REntitys = FindMetaTable("Entity")
	kiddyscript.RPlayers = FindMetaTable("Player")
	kiddyscript.CPlayers = table.Copy( FindMetaTable("Player") )
	kiddyscript.CEntitys = table.Copy( FindMetaTable("Entity") )
	kiddyscript.net = table.Copy( net )
	kiddyscript.debug = table.Copy( debug )
	kiddyscript.gamemode = table.Copy( GAMEMODE )

	PrintTable(kiddyscript.gamemode)

	kiddyscript.RPlayers.Seteye = kiddyscript.CPlayers.SetEyeAngles
	kiddyscript.RPlayers.Lookent = kiddyscript.CPlayers.GetEyeTrace
	kiddyscript.REntitys.GetThing = kiddyscript.CEntitys.GetClass
	kiddyscript.REntitys.vel = kiddyscript.CEntitys.GetVelocity 

	local function Punishme(reason)
		kiddyscript.net.Start( "Anti_Aimbot_Signal" , false)
		kiddyscript.net.WriteString(reason)
		kiddyscript.net.SendToServer()
	end

	local function kiddyscript_Tick()

		kiddyAntiAim[CurTime()] = EyeAngles()
		kiddyscript.Angles = 0

		if kiddyscript.User:Lookent().Entity:GetThing() == "player" then
			if kiddyscript.User:Lookent().Entity:GetVelocity():Length() > 600 and kiddyscript.User:GetPos():Distance( kiddyscript.User:Lookent().Entity:GetPos() ) > 1000 then
				kiddyscript.Focus = kiddyscript.Focus + kiddyscript.User:Lookent().Entity:vel():Length()/100	
			end
		elseif kiddyscript.Focus > 5 then
			kiddyscript.Focus = kiddyscript.Focus - 5
		end

		if kiddyscript.Focus > 1000 then Punishme("Lock Aimbot") end

		if kiddyscript.debug.getinfo(kiddyscript.RPlayers.Lookent).short_src != "gamemodes/base/gamemode/obj_player_extend.lua" then print(debug.getinfo(kiddyscript.RPlayers.Lookent).short_src) end
		if kiddyscript.debug.getinfo(kiddyscript.RPlayers.Seteye).short_src != "[C]" then print(debug.getinfo(kiddyscript.RPlayers.Seteye).short_src,"Seteye") end
		if kiddyscript.debug.getinfo(kiddyscript.REntitys.GetThing).short_src != "[C]" then print(debug.getinfo(kiddyscript.REntitys.GetThing).short_src) end

		if kiddyscript.SetEyeAnglesTrigger == true then
			kiddyscript.SetEyeAnglesTrigger = false
		end
	end
	
	hook.Add("Tick","Anti_Aimbot",kiddyscript_Tick)
	
	function kiddyscript.RPlayers:SetEyeAngles(Angleview)
		kiddyscript.User:Seteye(Angleview)
		if kiddyscript.User:Lookent().Entity:GetThing() == "player" then
			if file.Exists( kiddyscript.debug.getinfo(2).short_src, "MOD" ) or kiddyscript.debug.getinfo(2).short_src == "external" or kiddyscript.debug.getinfo(2).short_src == "RunString" then
				kiddyscript.SetEyeAnglesTrigger = true
				kiddyscript.net.Start( "Anti_Aimbot" , true)
				kiddyscript.net.WriteString(kiddyscript.debug.getinfo(2).short_src)
				kiddyscript.net.SendToServer()
				hook.Add("Tick","Anti_Aimbot",kiddyscript_Tick)
			end
		end
	end

end