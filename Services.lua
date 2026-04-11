local Services = {};
local workspace = game:GetService('Workspace');
local players = game:GetService('Players')
local localPlayer = players.localPlayer
local vim = getvirtualinputmanager and getvirtualinputmanager();

function Services:Get(...)
    local allServices = {}
    for _, service in next, {...} do
        table.insert(allServices, self[service]);
    end;
    return unpack(allServices);
end;

setmetatable(Services, {
    __index = function(self, p)
        if p == "VirtualInputManager" and vim then
            return vim
        elseif p == "VirtualInputManager" and not vim then
            return game:GetService('VirtualInputManager')
        elseif p == "CurrentCamera" then
            return workspace.CurrentCamera
        elseif p == "Mouse" then
            return localPlayer:GetMouse()
        end
        local service = game:GetService(p);
        rawset(self, p, service);
        return service;
    end
})

return Services;