local Services = {};
local workspace = game:GetService('Workspace');
local players = game:GetService('Players')
local localPlayer = players.LocalPlayer
local vim = getvirtualinputmanager and getvirtualinputmanager();

function Services:Get(...)
    local ServicesTable = {}
    for _, service in next, {...} do
        table.insert(ServicesTable, self[service]);
    end;
    return unpack(ServicesTable);
end;

setmetatable(Services, {
    __index = function(self, p)
        if p == "VirtualInputManager" then
            if vim then
                return vim
            end

            local service = game:GetService("VirtualInputManager")
            vim = cloneref and cloneref(service) or service
            rawset(self, p, vim)
            return vim

        elseif p == "CurrentCamera" then
            return workspace.CurrentCamera

        elseif p == "Mouse" then
            return localPlayer:GetMouse()
        end

        local service = cloneref and cloneref(game:GetService(p)) or game:GetService(p)

        rawset(self, p, service)
        return service
    end
})

return Services;
