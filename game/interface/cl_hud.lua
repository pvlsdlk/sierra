local _w, _h = ScrW(), ScrH()
local _ply = LocalPlayer()
local _blur = Sierra.GetCachedMaterial("pp/blurscreen")
local _vig = Sierra.GetCachedMaterial("sierra/vignette.png")
local temp_fallouthud = Sierra.GetCachedMaterial("sierra/temp_fallout.jpg")
local _surface = surface
local _vigColor = Color(0,0,0,255)
local _crosshairGap = 5
local _crosshairLength = _crosshairGap + 5
local _hpe = 0
local _hidden = {}
_hidden["CHudHealth"] = true
_hidden["CHudBattery"] = true
_hidden["CHudAmmo"] = true
_hidden["CHudSecondaryAmmo"] = true
_hidden["CHudCrosshair"] = true
_hidden["CHudHistoryResource"] = true
_hidden["CHudDeathNotice"] = true
_hidden["CHudDamageIndicator"] = true

local _modCol = Color(0,150,255,255)
local _ownerCol = Color(255,0,0,255)
local _leadCol = Color(89,0,255)
local _donCol = Color(255,255,0,255)
local function DrawOverheadInfo(target, alpha)
	local pos = target:EyePos()

	pos.z = pos.z + 10
	pos = pos:ToScreen()
	pos.y = pos.y - 60

	local col = ColorAlpha(team.GetColor(target:Team()), alpha)

	draw.DrawText(target:Name(), "UI-25-ShadowOutline", pos.x, pos.y, col, 1)
    draw.DrawText(team.GetName(target:Team()), "UI-22-Shadow", pos.x, pos.y+20, col, 1)
    if(target:IsUserGroup("moderator")) then
        draw.DrawText("Game Moderator", "UI-25-ShadowOutline", pos.x, pos.y-20, _modCol, 1)
    elseif(!target:IsUserGroup("donator")) then
        draw.DrawText("Donator", "UI-25-ShadowOutline", pos.x, pos.y-20, _donCol, 1)      
    elseif(target:IsAdmin()) then
        draw.DrawText("Lead Game Moderator", "UI-25-ShadowOutline", pos.x, pos.y-20, _leadCol, 1)      
    elseif(target:IsSuperAdmin()) then
        draw.DrawText("Server Owner", "UI-25-ShadowOutline", pos.x, pos.y-20, _ownerCol, 1)      
    end
end

local function _blurRect(x, y, w, h)
	local X, Y = 0,0

	_surface.SetDrawColor(color_white)
	_surface.SetMaterial(_blur)

	for i = 1, 2 do
		_blur:SetFloat("$blur", (i / 10) * 20)
		_blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x+w, y+h, true)
		_surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

local function _drawVignette()
    if not(LocalPlayer():Alive()) then
        return
    end

    _surface.SetMaterial(_vig)
    if(LocalPlayer():Health() < 20) then
        _surface.SetDrawColor(Color(255,0,0,TimedSin(0.8,20,150,0)))
    else
        _surface.SetDrawColor(_vigColor)
    end
    _surface.DrawTexturedRect(0,0,_w,_h)
end

local function _drawCrosshair(x,y)
	_surface.SetDrawColor(color_white)

	_surface.DrawLine(x - _crosshairLength, y, x - _crosshairGap, y)
	_surface.DrawLine(x + _crosshairLength, y, x + _crosshairGap, y)
	_surface.DrawLine(x, y - _crosshairLength, x, y - _crosshairGap)
	_surface.DrawLine(x, y + _crosshairLength, x, y + _crosshairGap)
end

local function _drawGenBox()
    -- ======= TEMP ======
    local temp_color = Sierra.Theme.White
    --local temp_scale = 0
    -- ======= TEMP ======

    local _money = LocalPlayer():GetNWInt("money")
    local _xp = LocalPlayer():GetNWInt("xp")
    local _rpname = LocalPlayer():GetNWString("rpname")
    local _plyTeam = LocalPlayer():Team()
    local _teamColor = team.GetColor(_plyTeam)
    local _teamName = team.GetName(_plyTeam)
    local _health = LocalPlayer():Health()
    local _armor = LocalPlayer():Armor()

    -- ======= TEMP ======
    --_surface.SetDrawColor(Color(255,255,255,255))
    --_surface.SetMaterial(temp_fallouthud)
    --_surface.DrawTexturedRect(0,0,900-temp_scale,600-temp_scale)
    -- ======= TEMP ======

    -- Blur
    --_blurRect(_w*0, _h*0.81,412,138)
    --_surface.SetDrawColor(Color(12,12,14,150))
    --_surface.DrawRect(_w*0, _h*0.81,412,138)

    -- First line vertical
    _surface.SetDrawColor(Color(0,0,0))
    _surface.DrawOutlinedRect(_w*0.06, _h*0.9, 250,2,3)
    _surface.SetDrawColor(temp_color)
    _surface.DrawRect(_w*0.06, _h*0.9, 250,2)

    -- Ending line horizontal
    _surface.SetDrawColor(Color(0,0,0))
    _surface.DrawOutlinedRect(_w*0.242, _h*0.89, 2,10,11)
    _surface.SetDrawColor(temp_color)
    _surface.DrawRect(_w*0.242, _h*0.89, 2,10)

    -- HP Filler
    _hpe = math.Approach(_hpe, _health, 9)
    _surface.SetDrawColor(temp_color)
    _surface.DrawRect(_w*0.06, _h*0.89, _hpe*2.5,8)

    -- HP Text
    _surface.SetTextColor(temp_color)
    _surface.SetFont("UI-38-Shadow")
    _surface.SetTextPos(_w*0.04, _h*0.87)
    _surface.DrawText("+")

    if(_health < 20) then
        _surface.SetTextColor(Color(255,0,0,TimedSin(0.5,50,300,0)))
    else
        _surface.SetTextColor(temp_color)
    end
    _surface.SetFont("UI-30-Shadow")
    _surface.SetTextPos(_w*0.248, _h*0.873)
    _surface.DrawText("("..math.Approach(_hpe,_health,9)..")")

    -- Name
    _surface.SetFont("UI-30-Shadow")
    _surface.SetTextPos(_w*0.06, _h*0.82)
    _surface.SetTextColor(temp_color)
    _surface.DrawText("Edward Robin House")

    -- Faction
    _surface.SetFont("UI-24-Bold")
    _surface.SetTextPos(_w*0.06, _h*0.85)
    _surface.SetTextColor(_teamColor)
    _surface.DrawText(_teamName)

    -- Tokens
    _surface.SetFont("UI-21-Shadow")
    _surface.SetTextPos(_w*0.06, _h*0.92)
    _surface.SetTextColor(temp_color)
    _surface.DrawText(_money.." TOKENS")

    -- Tokens
    _surface.SetTextPos(_w*0.06, _h*0.945)
    _surface.DrawText(_xp.." XP")
end

local darkCol = Color(2, 2, 4, 145)

local function drawWeapon()
    local weapon = LocalPlayer():GetActiveWeapon()
	if IsValid(weapon) then
		if weapon:GetMaxClip1() != -1 then
            _blurRect(_w*0.91, _h*0.92, 120,50)
            surface.SetDrawColor(darkCol)
            surface.DrawRect(_w*0.91, _h*0.92, 120,50)

            surface.SetDrawColor(Sierra.Theme.White)
            surface.DrawRect(_w*0.91, _h*0.92, 5,50)

            surface.SetFont("UI-30-Shadow")
			surface.SetTextPos(_w*0.92, _h*0.93)
			surface.DrawText(weapon:Clip1().."/"..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()))
		elseif weapon:GetClass() == "weapon_physgun" or weapon:GetClass() == "gmod_tool" then
			--draw.DrawText("You're currently holding OOC Weapon", "UI-19-Shadow", _w*0.79, _h*0.93, color_white, TEXT_ALIGN_LEFT)
            _blurRect(_w*0.78, _h*0.86, 300,100)
            surface.SetDrawColor(darkCol)
            surface.DrawRect(_w*0.78, _h*0.86, 300,100)

            surface.SetDrawColor(Sierra.Theme.White)
            surface.DrawRect(_w*0.78, _h*0.86, 5,100)
            draw.DrawText("Don't have this weapon out during\nroleplay situation.\n\nYou may be punished for it.", "UI-19-Shadow", _w*0.79, _h*0.865, Sierra.Theme.White)
        end
	end
end

function GM:HUDShouldDraw(element)
    if (_hidden[element]) then
		return false
	end

	return true
end

function GM:HUDPaint()
    if(!LocalPlayer():Alive()) then return end

    _drawCrosshair(_w/2,_h/2)
    _drawGenBox()
    drawWeapon()
end

local nextOverheadCheck = 0
local lastEnt
local trace = {}
local approach = math.Approach
local letterboxFde = 0
local textFde = 0
local holdTime
overheadEntCache = {}
function GM:HUDPaintBackground()
    _drawVignette()

    local lp = LocalPlayer()
	local realTime = RealTime()
	local frameTime = FrameTime()

	if nextOverheadCheck < realTime then
		nextOverheadCheck = realTime + 0.5
		
		trace.start = lp.GetShootPos(lp)
		trace.endpos = trace.start + lp.GetAimVector(lp) * 300
		trace.filter = lp
		trace.mins = Vector(-4, -4, -4)
		trace.maxs = Vector(4, 4, 4)
		trace.mask = MASK_SHOT_HULL

		lastEnt = util.TraceHull(trace).Entity

		if IsValid(lastEnt) then
			overheadEntCache[lastEnt] = true
		end
	end

    for entTarg, shouldDraw in pairs(overheadEntCache) do
		if IsValid(entTarg) then
			local goal = shouldDraw and 255 or 0
			local alpha = approach(entTarg.overheadAlpha or 0, goal, frameTime * 1000)

			if lastEnt != entTarg then
				overheadEntCache[entTarg] = false
			end

			if alpha > 0 then
				if not entTarg:GetNoDraw() then
					if entTarg:IsPlayer() then
						DrawOverheadInfo(entTarg, alpha)
					end
				end
			end

			entTarg.overheadAlpha = alpha

			if alpha == 0 and goal == 0 then
				overheadEntCache[entTarg] = nil
			end
		else
			overheadEntCache[entTarg] = nil
		end
	end
end