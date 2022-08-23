local PANEL = {}

local baseSizeW, baseSizeH = 300, 20

function PANEL:Init()
	self.message = markup.Parse("")
	self:SetSize(baseSizeW, baseSizeH)
	self.startTime = CurTime()
	self.endTime = CurTime() + 7.5
end

function PANEL:SetMessage(...)
	-- Encode message into markup
	local msg = "<font=UI-19-Shadow>"

	for k, v in ipairs({...}) do
		if type(v) == "table" then
			msg = msg.."<color="..v.r..","..v.g..","..v.b..">"
		elseif type(v) == "Player" then
			local col = team.GetColor(v:Team())
			msg= msg.."<color="..col.r..","..col.g..","..col.b..">"..tostring(v:Name()):gsub("<", "&lt;"):gsub(">", "&gt;").."</color>"
		else
			msg = msg..tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;")
		end
	end
	msg = msg.."</font>"

	-- parse
	self.message = markup.Parse(msg, baseSizeW-20)

	-- set frame position and height to suit the markup
	local shiftHeight = self.message:GetHeight()
	self:SetHeight(shiftHeight+baseSizeH)
	surface.PlaySound("buttons/lightswitch2.wav")
end

local gradient = Material("vgui/gradient-r")
local darkCol = Color(2, 2, 4, 145)
local lifetime = 10

function PANEL:Paint(w,h)
	-- draw frame
	Sierra.BlurPanel(self, 10, 20, 255)
	surface.SetDrawColor(darkCol)
	surface.DrawRect(0,0,w,h)
	surface.SetDrawColor(darkCol)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(0,0,w,h)

    surface.SetDrawColor(Color(0,0,0))
    surface.DrawOutlinedRect(0,0,5,h,6)
    surface.SetDrawColor(Sierra.Theme.White)
    surface.DrawRect(0,0,5,h)

	-- draw message
	self.message:Draw(15,10, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	-- draw timebar
	local w2 = math.TimeFraction(self.startTime, self.endTime, CurTime()) * w
	surface.SetDrawColor(Color(255,255,255))
	surface.DrawRect(w2, h-2, w - w2, 2)
end

vgui.Register("SierraNotify", PANEL, "DPanel")