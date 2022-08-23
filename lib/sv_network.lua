local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

Sierra.net = Sierra.net or {}
Sierra.net.globals = Sierra.net.globals or {}

-- Check if there is an attempt to send a function. Can't send those.
local function checkBadType(name, object)
	local objectType = type(object)

	if (objectType == "function") then
		ErrorNoHalt("Net var '"..name.."' contains a bad object type!")

		return true
	elseif (objectType == "table") then
		for k, v in pairs(object) do
			-- Check both the key and the value for tables, and has recursion.
			if (checkBadType(name, k) or checkBadType(name, v)) then
				return true
			end
		end
	end
end

function setNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end
	if (getNetVar(key) == value) then return end

	Sierra.net.globals[key] = value
	netstream.Start(receiver, "gVar", key, value)
end
SetNetVar = setNetVar

function playerMeta:syncVars()
	for entity, data in pairs(Sierra.net) do
		if (entity == "globals") then
			for k, v in pairs(data) do
				netstream.Start(self, "gVar", k, v)
			end
		elseif (IsValid(entity)) then
			for k, v in pairs(data) do
				netstream.Start(self, "nVar", entity:EntIndex(), k, v)
			end
		end
	end
end
playerMeta.SyncVars = playerMeta.syncVars

function entityMeta:sendNetVar(key, receiver)
	netstream.Start(receiver, "nVar", self:EntIndex(), key, Sierra.net[self] and Sierra.net[self][key])
end
entityMeta.SendNetVar = entityMeta.sendNetVar

function entityMeta:clearNetVars(receiver)
	Sierra.net[self] = nil
	netstream.Start(receiver, "nDel", self:EntIndex())
end
entityMeta.ClearNetVars = entityMeta.clearNetVars

function entityMeta:setNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end

	Sierra.net[self] = Sierra.net[self] or {}

	if (Sierra.net[self][key] != value) then
		Sierra.net[self][key] = value
	end

	self:sendNetVar(key, receiver)
end
entityMeta.SetNetVar = entityMeta.setNetVar

function entityMeta:getNetVar(key, default)
	if (Sierra.net[self] and Sierra.net[self][key] != nil) then
		return Sierra.net[self][key]
	end

	return default
end
entityMeta.GetNetVar = entityMeta.getNetVar

function playerMeta:setLocalVar(key, value)
	if (checkBadType(key, value)) then return end

	Sierra.net[self] = Sierra.net[self] or {}
	Sierra.net[self][key] = value

	netstream.Start(self, "nLcl", key, value)
end
playerMeta.SetLocalVar = playerMeta.setLocalVar

playerMeta.getLocalVar = entityMeta.getNetVar
playerMeta.GetLocalVar = playerMeta.getLocalVar

function getNetVar(key, default)
	local value = Sierra.net.globals[key]

	return value != nil and value or default
end
GetNetVar = getNetVar

hook.Add("EntityRemoved", "nCleanUp", function(entity)
	entity:clearNetVars()
end)

hook.Add("PlayerInitialSpawn", "nSync", function(client)
	client:syncVars()
end)
