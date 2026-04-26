local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local Teleports = {}

function Teleports.Teleport()
	local LocalPlayer = Players.LocalPlayer
	local PlaceId = game.PlaceId

	while true do
		local success, err = pcall(function()
			local JobId = game.JobId
			local servers = {}

			local req = game:HttpGet(
				"https://games.roblox.com/v1/games/" .. PlaceId ..
				"/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
			)

			local body = HttpService:JSONDecode(req)

			if body and body.data then
				for _, v in next, body.data do
					if type(v) == "table"
						and tonumber(v.playing)
						and tonumber(v.maxPlayers)
						and v.playing < v.maxPlayers
						and v.id ~= JobId then

						table.insert(servers, v.id)
					end
				end
			end

			if #servers > 0 then
				local serverId = servers[math.random(1, #servers)]

				TeleportService:TeleportToPlaceInstance(
					PlaceId,
					serverId,
					LocalPlayer
				)
			end
		end)

		if not success then
			warn(err)
		end

		task.wait(1)
	end
end

return Teleports
