local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

Sierra.net = Sierra.net or {}
Sierra.net.globals = Sierra.net.globals or {}

netstream.Hook("nVar", function(index, key, value)
	Sierra.net[index] = Sierra.net[index] or {}
	Sierra.net[index][key] = value
end)

netstream.Hook("nDel", function(index)
	Sierra.net[index] = nil
end)

netstream.Hook("nLcl", function(key, value)
	Sierra.net[LocalPlayer():EntIndex()] = Sierra.net[LocalPlayer():EntIndex()] or {}
	Sierra.net[LocalPlayer():EntIndex()][key] = value
end)

netstream.Hook("gVar", function(key, value)
	Sierra.net.globals[key] = value
end)

function getNetVar(key, default)
	local value = Sierra.net.globals[key]

	return value != nil and value or default
end
GetNetVar = getNetVar

function entityMeta:getNetVar(key, default)
	local index = self:EntIndex()

	if (Sierra.net[index] and Sierra.net[index][key] != nil) then
		return Sierra.net[index][key]
	end

	return default
end
entityMeta.GetNetVar = entityMeta.getNetVar

playerMeta.getLocalVar = entityMeta.getNetVar
playerMeta.GetLocalVar = playerMeta.getLocalVar