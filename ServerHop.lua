local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local ServersUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

local Teleports = {}

function Teleports.ListServers(cursor)
    local url = ServersUrl .. ((cursor and "&cursor=" .. cursor) or "")
    local raw = game:HttpGet(url)
    return HttpService:JSONDecode(raw)
end

local function isValid(server)
    return server
        and server.id
        and server.id ~= game.JobId
        and server.playing
        and server.maxPlayers
        and server.playing < server.maxPlayers
end

function Teleports.Teleport(mode)
    local cursor = nil

    local bestServer = nil
    local bestScore = (mode == "Max") and -1 or math.huge

    for _ = 1, 10 do 
        local data = Teleports.ListServers(cursor)

        for _, server in ipairs(data.data) do
            if isValid(server) then
                if mode == "Max" then
                    if server.playing > bestScore then
                        bestScore = server.playing
                        bestServer = server
                    end
                elseif mode == "Low" then
                    if server.playing < bestScore then
                        bestScore = server.playing
                        bestServer = server
                    end
                end
            end
        end

        cursor = data.nextPageCursor
        if not cursor then break end
    end

    if bestServer then
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            bestServer.id,
            Players.LocalPlayer
        )
    end
end

return Teleports
