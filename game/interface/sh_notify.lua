Sierra.notices = Sierra.notices or {}
local meta = FindMetaTable("Player")

local function OrganizeNotices(i)
    local scrW = ScrW()
    local lastHeight = ScrH() - 100

    for k, v in ipairs(Sierra.notices) do
        local height = lastHeight - v:GetTall() - 10
        v:MoveTo(scrW - (v:GetWide()), height, 0.15, (k / #Sierra.notices) * 0.25, nil)
        lastHeight = height
    end
end

--- Sends a notification to a player
-- @realm shared
-- @string message The notification message
function meta:Notify(message)
    if CLIENT then
        if not Sierra.HUDEnabled then
            return MsgN(message)
        end

        local notice = vgui.Create("SierraNotify")
        local i = table.insert(Sierra.notices, notice)

        notice:SetMessage(message)
        notice:SetPos(ScrW(), ScrH() - (i - 1) * (notice:GetTall() + 4) + 4) -- needs to be recoded to support variable heights
        notice:MoveToFront() 
        OrganizeNotices(i)

        timer.Simple(7.5, function()
            if IsValid(notice) then
                notice:AlphaTo(0, 1, 0, function() 
                    notice:Remove()

                    for v,k in pairs(Sierra.notices) do
                        if k == notice then
                            table.remove(Sierra.notices, v)
                        end
                    end

                    OrganizeNotices(i)
                end)
            end
        end)

        MsgN(message)
    else
        net.Start("SierraNotify")
        net.WriteString(message)
        net.Send(self)
    end
end