
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

	kiddyscript.RPlayers.Seteye = kiddyscript.CPlayers.SetEyeAngles
	kiddyscript.RPlayers.Trace = kiddyscript.CPlayers.GetEyeTrace
	kiddyscript.RPlayers.Lookent = kiddyscript.CPlayers.GetEyeTrace
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

		--for k,v in pairs(player.GetAll()) do
		--	if v:GetClass() == "player" and v:GetModel() != "models/error.mdl" then
        --		local head = v:LookupBone("ValveBiped.Bip01_Head1")
        --		local headpos = v:GetBonePosition(head)
        --		local Noang = ((headpos - kiddyscript.User:GetShootPos()):Angle())
        --
        --		if EyeAngles() == Noang then end
        --	end
		--end
		
		if kiddyscript.User:GetEyeTrace().Entity:IsValid() then
			local ent = kiddyscript.User:GetEyeTrace().Entity
			if ent:GetClass() == "player" then
				if ent:GetVelocity():Length() > 200 and kiddyscript.User:GetPos():Distance( ent:GetPos() ) > 300 then
					kiddyscript.Focus = kiddyscript.Focus + ent:vel():Length()/100 + kiddyscript.User:GetPos():Distance( ent:GetPos() )/100
				end
			elseif kiddyscript.Focus > 5 then
				kiddyscript.Focus = kiddyscript.Focus - 2.5
			end
		end

		if kiddyscript.Focus > 10000 then Punishme("Lock Aimbot") end

		if kiddyscript.SetEyeAnglesTrigger == true then
			kiddyscript.SetEyeAnglesTrigger = false
		end
	end
	
	hook.Add("Tick",Randomstring( math.random( 5, 20 ) ),kiddyscript_Tick)
	
	function kiddyscript.RPlayers:SetEyeAngles(Angleview)
		
		if kiddyscript.User:GetEyeTrace().Entity:GetClass() == "player" then
			if kiddyscript.file.Exists( kiddyscript.debug.getinfo(2).short_src, "MOD" ) or kiddyscript.debug.getinfo(2).short_src == "external" or kiddyscript.debug.getinfo(2).short_src == "RunString" then
				
				kiddyscript.net.Start( "Anti_Aimbot" , true)
				kiddyscript.net.WriteString(kiddyscript.debug.getinfo(2).short_src)
				kiddyscript.net.SendToServer()

				kiddyscript.SetEyeAnglesTrigger = true
			end
		end

		return kiddyscript.User:Seteye(Angleview)
	end

	hook.Add("Tick","Anti_Aimbot",kiddyscript_Tick)

	function kiddyscript.RCUserCmd:SetViewAngles(Angleview)
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