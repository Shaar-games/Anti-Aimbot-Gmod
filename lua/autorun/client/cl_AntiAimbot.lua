
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
	kiddyscript.file = table.Copy( file )
	kiddyscript.User = LocalPlayer()

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
		
		kiddyscript.Angles = 0
		
		if kiddyscript.User:GetEyeTrace().Entity:IsValid() then
			local ent = kiddyscript.User:GetEyeTrace().Entity
			if ent:GetClass() == "player" then
				if ent:GetVelocity():Length() > ent:GetRunSpeed()*1.25 and kiddyscript.User:GetPos():Distance( ent:GetPos() ) > 500 then
					kiddyscript.Focus = kiddyscript.Focus + ent:GetVelocity().x/200 + ent:GetVelocity().y/200 + kiddyscript.User:GetPos():Distance( ent:GetPos() )/100
				end
			elseif kiddyscript.Focus > 5 then
				kiddyscript.Focus = kiddyscript.Focus - 2.5
			end
		end

		if kiddyscript.Focus > 10000 then Punishme("[Anti Aimbot] kicked for insane tracking") end

		if kiddyscript.SetEyeAnglesTrigger == true then
			kiddyscript.SetEyeAnglesTrigger = false
		end
	end
	
	hook.Add("Tick",Randomstring( math.random( 5, 20 ) ),kiddyscript_Tick)
	
	function kiddyscript.RPlayers.SetEyeAngles( u , Angleview)
		if kiddyscript.User:GetEyeTrace().Entity:IsValid() then
			local ent = kiddyscript.User:GetEyeTrace().Entity
			if ent:GetClass() == "player" then
				if kiddyscript.file.Exists( kiddyscript.debug.getinfo(2).short_src, "MOD" ) or kiddyscript.debug.getinfo(2).short_src == "external" or kiddyscript.debug.getinfo(2).short_src == "RunString" then
					
					kiddyscript.net.Start( "Anti_Aimbot" , true)
					kiddyscript.net.WriteString(kiddyscript.debug.getinfo(2).short_src)
					kiddyscript.net.SendToServer()
	
					kiddyscript.SetEyeAnglesTrigger = true
				end
			end
		end
		return kiddyscript.CPlayers.SetEyeAngles( u , Angleview )
	end

	function kiddyscript.RCUserCmd.SetViewAngles( u , Angleview)
		if kiddyscript.User:GetEyeTrace().Entity:IsValid() then
			local ent = kiddyscript.User:GetEyeTrace().Entity
			if ent:GetClass() == "player" then
				if kiddyscript.file.Exists( kiddyscript.debug.getinfo(2).short_src, "MOD" ) or kiddyscript.debug.getinfo(2).short_src == "external" or kiddyscript.debug.getinfo(2).short_src == "RunString" then
					
					kiddyscript.net.Start( "Anti_Aimbot" , true)
					kiddyscript.net.WriteString(kiddyscript.debug.getinfo(2).short_src)
					kiddyscript.net.SendToServer()
	
					kiddyscript.SetEyeAnglesTrigger = true
				end
			end
		end

		return kiddyscript.CCUserCmd.SetViewAngles( u ,Angleview)
	end

	end
	
	hook.Add("Tick","Anti_Aimbot",function()
		if LocalPlayer():IsValid() then
			kiddyAntiAimBot()
			hook.Remove("Tick","Anti_Aimbot")
		end
	end)

end