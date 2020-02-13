local Wide = 870
local Height = 550

hook.Add("OnContextMenuOpen","OnContextMenuOpen::Draw3D2DMenuC",function()

  hook.Add("PostDrawTranslucentRenderables","PostDrawTranslucentRenderables::Draw3D2DMenuC",function()

    local ang = Angle(0,LocalPlayer():EyeAngles().y-90,90)
    local vector = LocalPlayer():EyePos() + LocalPlayer():GetForward()*20
    local vector2 = util.IntersectRayWithPlane(LocalPlayer():GetShootPos() + EyeAngles():Forward()*(8.1),gui.ScreenToVector(gui.MousePos()),vector,ang:Up())
    local ang2

    if vector2 then
      LocalPlayer().GetRenderPos3D, ang2 = WorldToLocal(vector2,Angle(0,0,0),vector,ang)
    end
    TableInfo2D3D(vector,ang,"Menu C")

  end)

  timer.Simple(0.1,function()

    local Bouton1 = Create3D2DButton()
    Bouton1:SetSize(500,70)
    Bouton1:SetPos(550,150)
    Bouton1.x2, Bouton1.y2 = Bouton1:GetPos()
    Bouton1:SetIdView("Menu C")
    Bouton1.Paint = function(self,w,h,x,y)

      draw.RoundedBox(0,0,0,Wide,Height,Color(255,255,255))

      draw.RoundedBox(0,0,0,Wide,Height/10,Color(0,0,0))
      draw.SimpleTextOutlined("Context Menu", "Trebuchet24", Wide/2, 4, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP,2,Color(0,0,0))

      draw.RoundedBoxEx(39,x,y,w-(self.x2-373),h,Color(0,0,0),true,false,true,false)
      draw.RoundedBoxEx(32,x+w/2-(w/1.020/2),y+h/2-(h-(w-w/1.020))/2,w/1.020-(self.x2-375),h-(w-w/1.020),Color(255,255,255),true,false,true,false)
      draw.SimpleTextOutlined("Commandes","Trebuchet24",x+w/8,y+h/7,Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,2,Color(0,0,0))

      if self:IsHovered() then
        if Vector(ScrW()-self:GetWide()/3,self.y,0):Distance(Vector(self.x2,self.y2,0)) < 80 then return end
        self.x2 = Lerp(FrameTime()*5,self.x2,500)
        self:SetPos(self.x2,self.y2)
      else
        self.x2 = Lerp(FrameTime()*5,self.x2,550)
        self:SetPos(self.x2,self.y2)
      end
    end
    Bouton1.DoClick = function(self)
      print("omgggggggg")
    end

  end)

end)

hook.Add("OnContextMenuClose","OnContextMenuClose::Draw3D2DMenuC",function()

  hook.Remove("PostDrawTranslucentRenderables","PostDrawTranslucentRenderables::Draw3D2DMenuC")
  TableInfo2D3DRemove("Menu C")

end)
