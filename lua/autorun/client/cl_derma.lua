if CLIENT then
net.Receive( "Anti_Aimbot_menu_Elements", function( len, ply )

	local kiddyscript = net.ReadTable()

	PrintTable(kiddyscript)

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW()/1.5, ScrH()/1.5 )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( "" )
	
	frame.Paint = function (s , w , h)
		draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 , Color( 30 , 30 , 30 , 255 ) )
	end
	
	local DScrollPanel = vgui.Create( "DScrollPanel", frame )
	DScrollPanel:Dock( FILL )
	
	for k,v in pairs(player.GetAll()) do
		if v:IsValid() then
			local DLabel = DScrollPanel:Add( "DButton" )
			DLabel:SetText( "     "..v:Name() )
			DLabel:Dock( TOP )
			DLabel:SetContentAlignment( 4 )
			DLabel:DockMargin( 0, 5, 0, 0 )
			DLabel:SetSize(10,50)
			DLabel:SetTextColor( Color( 200, 200, 200 ) )
		
			DLabel.Paint = function (s , w , h)
				draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 , Color( 00 , 00 , 00 , 255 ) )
			end

			if kiddyscript[v].Script then 
				local Label = DScrollPanel:Add( "DButton" )
				Label:SetText( "     ".."Script : "..kiddyscript[v].Script )
				Label:Dock( TOP )
				Label:SetContentAlignment( 4 )
				Label:SetTextColor( Color( 255, 0, 0 ) )
				Label:DockMargin( 0, 1, 0, 1 )
				Label:SetSize(10,30)
			
				Label.Paint = function (s , w , h)
					draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 , Color( 00 , 00 , 00 , 255 ) )
				end
			end
			if kiddyscript[v].Focus then 
				local Label = DScrollPanel:Add( "DButton" )
				Label:SetText( "     ".."Aimbot Rate : "..kiddyscript[v].Focus )
				Label:Dock( TOP )
				Label:SetContentAlignment( 4 )
				Label:DockMargin( 0, 0, 0, 1 )
				Label:SetTextColor( Color( 200, 200, 200 ) )
				Label:SetSize(10,30)
			
				Label.Paint = function (s , w , h)
					draw.RoundedBox(0 ,0 ,0 ,w + 120 ,h + 120 , Color( 00 , 00 , 00 , 255 ) )
				end
			end
		end
	end

end )

concommand.Add( "AntiAimbot_menu", function( ply, cmd, args )
	net.Start( "Anti_Aimbot_menu" , true)
	net.SendToServer()
end )
end