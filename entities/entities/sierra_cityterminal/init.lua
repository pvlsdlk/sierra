AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_smallmonitor001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self.TerminalLoop = nil--CreateSound(self, "ambient/machines/combine_terminal_idle3.wav")
end

function ENT:Think()
    if(IsValid(self)) then
        self.TerminalLoop:Play()
        self.TerminalLoop:ChangeVolume(0.4,0)
    else
        self.TerminalLoop:Stop()
    end

    if (IsValid(self:GetPhysicsObject())) then
        self:GetPhysicsObject():EnableMotion(false)
    end

    function ENT:OnRemove()
		self.TerminalLoop:Stop()
	end

	function ENT:OnRemove()
		if (self.TerminalLoop) then
			self.TerminalLoop:Stop()
			self.TerminalLoop = nil
		end
	end
end