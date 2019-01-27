
if CLIENT then

	local function kiddyAntiAimBot()

	local kiddyscript = {}

	kiddyAntiAim = {}
	
	kiddyscript.Focus = 0
	kiddyscript.SetEyeAnglesTrigger = false
	kiddyscript.RWeapon = FindMetaTable("Weapon")
	kiddyscript.REntitys = FindMetaTable("Entity")
	kiddyscript.RPlayers = FindMetaTable("Player")
	kiddyscript.RCUserCmd = FindMetaTable("CUserCmd")
	kiddyscript.CCUserCmd = table.Copy( FindMetaTable("CUserCmd") )
	kiddyscript.CPlayers = table.Copy( FindMetaTable("Player") )
	kiddyscript.CEntitys = table.Copy( FindMetaTable("Entity") )
	kiddyscript.net = table.Copy( net )
	kiddyscript.debug = table.Copy( debug )
	kiddyscript.User = LocalPlayer()

	kiddyscript.RPlayers.Seteye = kiddyscript.CPlayers.SetEyeAngles
	kiddyscript.RPlayers.Trace = kiddyscript.CPlayers.GetEyeTrace
	print(kiddyscript.CPlayers.GetEyeTrace)
	function kiddyscript.RPlayers:Lookent() return self:GetEyeTrace() end
	kiddyscript.REntitys.GetThing = kiddyscript.CEntitys.GetClass
	kiddyscript.REntitys.vel = kiddyscript.CEntitys.GetVelocity 
	kiddyscript.RCUserCmd.Seteye = kiddyscript.CCUserCmd.SetViewAngles

	local function Punishme(reason)
		kiddyscript.net.Start( "Anti_Aimbot_Signal" , false)
		kiddyscript.net.WriteString(reason)
		kiddyscript.net.SendToServer()
	end

	local function Randomstring( length )

    	local length = tonumber( length )
	
    	if length < 1 then return end
	
    	local result = "" -- The empty string we start with
	
    	for i = 1, length do
	
    	    result = result .. string.char( math.random( 32, 126 ) )
	
    	end
	
    	return result

	end

	local function kiddyscript_Tick()
		
		kiddyAntiAim[CurTime()] = EyeAngles()
		kiddyscript.Angles = 0


		for k,v in pairs(player.GetAll()) do
			if v:GetThing() == "player" and v:GetModel() != "models/error.mdl" then
        		local head = v:LookupBone("ValveBiped.Bip01_Head1")
        		local headpos = v:GetBonePosition(head)
        		local Noang = ((headpos - LocalPlayer():GetShootPos()):Angle())

        		if EyeAngles() == Noang then print("eyes pos") end
        	end
		end

		if LocalPlayer():Lookent().Entity:GetThing() == "player" then
			if LocalPlayer():Lookent().Entity:GetVelocity():Length() > 200 and LocalPlayer():GetPos():Distance( LocalPlayer():Lookent().Entity:GetPos() ) > 300 then
				kiddyscript.Focus = kiddyscript.Focus + LocalPlayer():Lookent().Entity:vel():Length()/100 + LocalPlayer():GetPos():Distance( LocalPlayer():Lookent().Entity:GetPos() )/100
			end
		elseif kiddyscript.Focus > 5 then
			kiddyscript.Focus = kiddyscript.Focus - 5
		end

		if kiddyscript.Focus > 10000 then Punishme("Lock Aimbot") end

		--if kiddyscript.debug.getinfo(kiddyscript.RPlayers.Lookent).short_src != "gamemodes/base/gamemode/obj_player_extend.lua" then print(debug.getinfo(kiddyscript.RPlayers.Lookent).short_src) end
		--if kiddyscript.debug.getinfo(kiddyscript.RPlayers.Seteye).short_src != "[C]" then print(debug.getinfo(kiddyscript.RPlayers.Seteye).short_src,"Seteye") end
		--if kiddyscript.debug.getinfo(kiddyscript.REntitys.GetThing).short_src != "[C]" then print(debug.getinfo(kiddyscript.REntitys.GetThing).short_src) end

		if kiddyscript.SetEyeAnglesTrigger == true then
			kiddyscript.SetEyeAnglesTrigger = false
		end
	end
	
	hook.Add("Tick",Randomstring( math.random( 5, 20 ) ),kiddyscript_Tick)
	
	function kiddyscript.RPlayers:SetEyeAngles(Angleview)
		
		if LocalPlayer():Lookent().Entity:GetThing() == "player" then
			if file.Exists( kiddyscript.debug.getinfo(2).short_src, "MOD" ) or kiddyscript.debug.getinfo(2).short_src == "external" or kiddyscript.debug.getinfo(2).short_src == "RunString" then
				kiddyscript.SetEyeAnglesTrigger = true
				kiddyscript.net.Start( "Anti_Aimbot" , true)
				kiddyscript.net.WriteString(kiddyscript.debug.getinfo(2).short_src)
				kiddyscript.net.SendToServer()
				hook.Add("Tick","Anti_Aimbot",kiddyscript_Tick)
			end
		end

		return LocalPlayer():Seteye(Angleview)
	end

	hook.Add("Tick","Anti_Aimbot",kiddyscript_Tick)

	function kiddyscript.RCUserCmd:SetViewAngles(Angleview)
		
		if LocalPlayer():Lookent().Entity:GetThing() == "player" then
			if file.Exists( kiddyscript.debug.getinfo(2).short_src, "MOD" ) or kiddyscript.debug.getinfo(2).short_src == "external" or kiddyscript.debug.getinfo(2).short_src == "RunString" then
				kiddyscript.SetEyeAnglesTrigger = true
				kiddyscript.net.Start( "Anti_Aimbot" , true)
				kiddyscript.net.WriteString(kiddyscript.debug.getinfo(2).short_src)
				kiddyscript.net.SendToServer()
			end
		end
		
		self:Seteye(Angleview)
	end

	end
	
	hook.Add("Tick","Anti_Aimbot",function()
		if LocalPlayer():IsValid() then
			kiddyAntiAimBot()
			hook.Remove("Tick","Anti_Aimbot")
		end
	end)

end