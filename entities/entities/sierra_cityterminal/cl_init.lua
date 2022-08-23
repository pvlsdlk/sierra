AddCSLuaFile("imgui.lua")
local imgui = include("imgui.lua")
include("shared.lua")

local temp = Sierra.GetCachedMaterial("sierra/temp_alyxterminal.jpg")
local background = Sierra.GetCachedMaterial("sierra/combinelines.png")
local secBackground = Sierra.GetCachedMaterial("sierra/background.png")
local barcode = Sierra.GetCachedMaterial("sierra/barcode.png")
local uuLogo = Sierra.GetCachedMaterial("sierra/uu_roundel.png")
local vig = Sierra.GetCachedMaterial("sierra/screen_vignette.png")

local uiColor = Color(2,183,255)
local uiSecond = Color(2,183,255,150)
local uiClick = Color(142,221,252)
local socScore = math.random(0,100)
local uiHover = Color(2,183,255,20)

local isMenuOpen = false

sound.Add( {
	name = "terminal_confirm",
	channel = CHAN_STATIC,
	volume = 1.0,
	sound = "sierra/terminal_prompt_confirm.wav"
} )

local function openMenu()
    if(isMenuOpen) then return end

    isMenuOpen = true 
    local w,h = ScrW(), ScrH()

    surface.PlaySound("sierra/machines/terminal_on.wav")

    local mainFrame = Interface("DPanel")
    mainFrame:SetSize(800,500)
    mainFrame:Center()
    mainFrame:ClearPaint()
    mainFrame:On("Paint", function(me,w,h)
        
        surface.SetDrawColor(color_white)
        surface.SetMaterial(secBackground)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetDrawColor(uiColor)
        surface.DrawRect(0,0,10,h)
        surface.DrawRect(0,55,w,5)

        surface.SetFont("Terminal-25")
        surface.SetTextPos(20,5)
        surface.SetTextColor(uiColor)
        surface.DrawText("CITY TERMINAL R:482")

        surface.SetFont("Terminal-17")
        surface.SetTextPos(20,28)
        surface.SetTextColor(uiSecond)
        surface.DrawText("NEXUS DATA-STREAM: x"..math.random(1000,200).."R:"..math.random(0,9))
    
        surface.SetFont("Terminal-17")
        surface.SetTextPos(25,75)
        surface.SetTextColor(uiSecond)
        surface.DrawText("LOCAL REGISTER:\n\n\n\n".."Edward Robin House")

        draw.DrawText("INDIVIDUAL ALLOCTION:     City-17: URBAN CENTER\nSOCIAL-RATION SCORE:      "..socScore, "Terminal-17", 25,95,uiSecond)

        surface.SetMaterial(vig)
        surface.SetDrawColor(Color(0,0,0,155))
        surface.DrawTexturedRect(0,0,w,h)
    end)
    mainFrame:MakePopup(true)

    local nameChange = Interface("DButton", mainFrame)
    nameChange:SetSize(270,30)
    nameChange:SetPos(25,200)
    nameChange:ClearPaint()
    nameChange:SetText(" ")
    nameChange:CircleClick(uiClick)
    nameChange:FillHover(uiHover)
    nameChange:SideBlock(uiColor, 8)
    nameChange:On("Paint", function(me,w,h)
        surface.SetDrawColor(uiSecond)
        surface.DrawOutlinedRect(0,0,w,h,2)
        
        surface.SetFont("Terminal-20")
        surface.SetTextPos(15,3)
        surface.SetTextColor(uiColor)
        surface.DrawText("REQUEST NAME CHANGE")
    end)
    nameChange:On("DoClick", function()
        surface.PlaySound("sierra/machines/terminal_prompt.wav")
    end)

    local modelChange = Interface("DButton", mainFrame)
    modelChange:SetSize(270,30)
    modelChange:SetPos(25,240)
    modelChange:ClearPaint()
    modelChange:SetText(" ")
    modelChange:CircleClick(uiClick)
    modelChange:FillHover(uiHover)
    modelChange:SideBlock(uiColor, 8)
    modelChange:On("Paint", function(me,w,h)
        surface.SetDrawColor(uiSecond)
        surface.DrawOutlinedRect(0,0,w,h,2)
        
        surface.SetFont("Terminal-20")
        surface.SetTextPos(15,3)
        surface.SetTextColor(uiColor)
        surface.DrawText("REQUEST APPEARANCE CHANGE")
    end)
    modelChange:On("DoClick", function()
        surface.PlaySound("sierra/machines/terminal_prompt.wav")
    end)

    local gDebug = Interface("DButton", mainFrame)
    gDebug:SetSize(270,30)
    gDebug:SetPos(25,300)
    gDebug:ClearPaint()
    gDebug:SetText(" ")
    gDebug:CircleClick(uiClick)
    gDebug:FillHover(uiHover)
    gDebug:SideBlock(uiColor, 8)
    gDebug:On("Paint", function(me,w,h)
        surface.SetDrawColor(uiSecond)
        surface.DrawOutlinedRect(0,0,w,h,2)
        
        surface.SetFont("Terminal-20")
        surface.SetTextPos(15,3)
        surface.SetTextColor(uiColor)
        surface.DrawText("DEBUG: REMINDER")
    end)
    gDebug:On("DoClick", function()
        surface.PlaySound("sierra/machines/terminal_prompt.wav")

        timer.Simple(1.8, function()
            surface.PlaySound("sierra/announcementalarm.wav")
        end)

        timer.Simple(2.9, function()
            surface.PlaySound("sierra/dispatch/disp_civilized.mp3")
        end)
    end)

    local gDebug2 = Interface("DButton", mainFrame)
    gDebug2:SetSize(270,30)
    gDebug2:SetPos(25,340)
    gDebug2:ClearPaint()
    gDebug2:SetText(" ")
    gDebug2:CircleClick(uiClick)
    gDebug2:FillHover(uiHover)
    gDebug2:SideBlock(uiColor, 8)
    gDebug2:On("Paint", function(me,w,h)
        surface.SetDrawColor(uiSecond)
        surface.DrawOutlinedRect(0,0,w,h,2)
        
        surface.SetFont("Terminal-20")
        surface.SetTextPos(15,3)
        surface.SetTextColor(uiColor)
        surface.DrawText("DEBUG: ANTI-CIVIL VIOLATION")
    end)
    gDebug2:On("DoClick", function()
        surface.PlaySound("sierra/machines/terminal_prompt.wav")

        timer.Simple(0, function()
            surface.PlaySound("sierra/fightalarm.mp3")
        end)

        timer.Simple(2, function()
            surface.PlaySound("sierra/dispatch/disp_anticivil.mp3")
        end)

        timer.Create("AlarmLoop", 4.5, 2, function()
            surface.PlaySound("sierra/fightalarm.mp3")
        end)
    end)

    local gDebug3 = Interface("DButton", mainFrame)
    gDebug3:SetSize(270,30)
    gDebug3:SetPos(25,390)
    gDebug3:ClearPaint()
    gDebug3:SetText(" ")
    gDebug3:CircleClick(uiClick)
    gDebug3:FillHover(uiHover)
    gDebug3:SideBlock(uiColor, 8)
    gDebug3:On("Paint", function(me,w,h)
        surface.SetDrawColor(uiSecond)
        surface.DrawOutlinedRect(0,0,w,h,2)
        
        surface.SetFont("Terminal-20")
        surface.SetTextPos(15,3)
        surface.SetTextColor(uiColor)
        surface.DrawText("DEBUG: ANTI-CIVIL VIOLATION")
    end)
    gDebug3:On("DoClick", function()
        surface.PlaySound("sierra/machines/terminal_prompt.wav")

        timer.Simple(2, function()
            surface.PlaySound("sierra/alarm_loud.wav")
        end)

        timer.Simple(3, function()
            surface.PlaySound("sierra/dispatch/disp_emergencycodevoid.mp3")
        end)

        timer.Create("AlertLoop", 10, 3, function()
            surface.PlaySound("sierra/fightalarm.mp3")
        end)

        timer.Simple(12, function()
            surface.PlaySound("sierra/dispatch/disp_updatecode.mp3")
        end)
    end)

    local closeButton = Interface("DButton", mainFrame)
    closeButton:SetPos(700,20)
    closeButton:SetSize(80,20)
    closeButton:SetText("CONFIRM")
    closeButton:ClearPaint()
    closeButton:Background(Color(0,0,0,0))
    closeButton:SetTextColor(color_white)
    closeButton:FillHover(uiHover)
    closeButton:SetFont("Terminal-17")
    closeButton:On("DoClick", function()
        surface.PlaySound("sierra/machines/terminal_off.wav")
        mainFrame:Remove()
        isMenuOpen = false
    end)
end

function ENT:Draw()
    self:DrawModel()

    if imgui.Entity3D2D(self,Vector(15,0,0), Angle(0,90,90), 0.1) then
        surface.SetMaterial(background)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(-100,-250,210,300)

        surface.SetDrawColor(uiColor)
        surface.SetMaterial(uuLogo)
        surface.DrawTexturedRect(-92,-240,57,50)

        surface.SetDrawColor(uiColor)
        surface.DrawRect(-100,-250, 5,300)

        surface.SetFont("Terminal-15-ShadowBold")
        surface.SetTextPos(-35,-240)
        surface.SetTextColor(uiColor)
        surface.DrawText("CITY TERMINAL R:482")

        surface.SetFont("Terminal-12")
        surface.SetTextPos(-35,-227)
        surface.SetTextColor(uiSecond)
        surface.DrawText("NEXUS DATA-STREAM: x"..math.random(1000,200).."R:"..math.random(0,9))

        if(imgui.xTextButton("LOGIN", "Terminal-17", -80,-100,170,20,2,uiColor, uiSecond,uiClick)) then
            self:EmitSound("sierra/machines/terminal_prompt_confirm.wav")
            openMenu()
        end

        surface.SetMaterial(vig)
        surface.SetDrawColor(Color(0,0,0,255))
        surface.DrawTexturedRect(-100,-250,210,300)

        imgui.End3D2D()
    end
end