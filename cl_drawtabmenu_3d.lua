TableInfo2D3DParams = {}

function TableInfo2D3D(vector,ang,id)

  if !TableInfo2D3DParams[id] then
    TableInfo2D3DParams[id] = {vector,ang,{}}
  else
    TableInfo2D3DParams[id][1] = vector
    TableInfo2D3DParams[id][2] = ang
  end

end

function TableInfo2D3DRemove(id)

  TableInfo2D3DParams[id] = nil

end

function InsertButtonTable(id,button)

  table.insert(TableInfo2D3DParams[id][3],button)

end

function GetCursorPosition3DX()

  return LocalPlayer().GetRenderPos3D.x/0.02

end

function GetCursorPosition3DY()

  return LocalPlayer().GetRenderPos3D.y/-0.02

end

function Create3D2DButton()

  local button = {}
  button.x = 0
  button.y = 0
  button.w = 0
  button.h = 0
  button.VectorView = Vector(0,0,0)
  button.RenderViewID = nil

  local Meta = {
    SetPos = function(self,x,y)

      self.x = x
      self.y = y
      return self

    end,
    SetSize = function(self,w,h)

      self.w = w
      self.h = h
      return self

    end,
    GetPos = function(self)

      return self.x, self.y

    end,
    GetWide = function(self)

      return self.w

    end,
    GetTall = function(self)

      return self.h

    end,
    SetIdView = function(self,id)

      self.RenderViewID = id
      InsertButtonTable(id,self)
      return self

    end,
    Remove = function(self)

      table.RemoveByValue(TableInfo2D3DParams[self.RenderViewID][3],self)

    end,
    IsHovered = function(self)

      if GetCursorPosition3DX() > self.x and GetCursorPosition3DX() < self.x + self.w and GetCursorPosition3DY() > self.y and GetCursorPosition3DY() < self.y + self.h then

        if input.IsMouseDown(MOUSE_LEFT) and !LocalPlayer().MousePresseAntiSpam then
          if isfunction(self.DoClick) then
            self.DoClick(self)
            LocalPlayer().MousePresseAntiSpam = true
          end
        elseif !input.IsMouseDown(MOUSE_LEFT) then
          LocalPlayer().MousePresseAntiSpam = false
        end

        return true

      else

        return false

      end

    end,
    Render3D = function(self)

      if isfunction(self.Paint) then self.Paint(self,self.w,self.h,self.x,self.y) end
      self:IsHovered()
      if isfunction(self.Think) then self.Think(self) end
      if self.StartAnimation then self:AnimThink() end

    end,
    AnimThink = function(self)

      local vector = LerpVector(self.AnimTime,Vector(self.x,self.y,0),Vector(self.EndPosX,self.EndPosY,0))
      self:SetPos(vector.x,vector.y)

    end,
    MoveTo = function(self,x,y,second)

      self.EndPosX = x
      self.EndPosY = y

      self.AnimTime = second ^ -3

      self.StartAnimation = true
      return self

    end,
  }

  Meta.__index = Meta

  setmetatable(button, Meta)

  return button

end

local Mat = Material("materials/menu_c/souris.png")

hook.Add("PostDrawTranslucentRenderables","PostDrawTranslucentRenderables::Draw3D2DTabMenu",function()

  local ang = LocalPlayer():EyeAngles()
  ang:RotateAroundAxis(ang:Right(),0)
  ang:RotateAroundAxis(ang:Up(),-90)
  ang:RotateAroundAxis(ang:Forward(),90)

  local vector = LocalPlayer():EyePos() + LocalPlayer():GetForward()*30
  local vector2 = util.IntersectRayWithPlane(LocalPlayer():GetShootPos() + EyeAngles():Forward()*(8.1),gui.ScreenToVector(gui.MousePos()),vector,ang:Up())
  local ang2

  if vector2 then
    LocalPlayer().GetRenderPos3D, ang2 = WorldToLocal(vector2,Angle(0,0,0),vector,ang)
  end

  for k,v in pairs(TableInfo2D3DParams) do

    cam.Start3D2D(v[1],v[2],0.02)

      for i,j in pairs(v[3]) do

        j:Render3D()

      end

      surface.SetDrawColor(255,255,255,255)
      surface.SetMaterial(Mat)
      surface.DrawTexturedRect(GetCursorPosition3DX()-18,GetCursorPosition3DY(),50,50)

    cam.End3D2D()

  end

end)
