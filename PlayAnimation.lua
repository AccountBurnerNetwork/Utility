local Players = game:GetService("Players")
local player = Players.LocalPlayer

local anims = {}
local currentTracks = {}
local loadedAnimations = {}

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    return getCharacter():WaitForChild("Humanoid")
end

local function getAnimator()
    local humanoid = getHumanoid()
    return humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
end

local function getAnimation(animId)
    animId = tostring(animId)

    if loadedAnimations[animId] then
        return loadedAnimations[animId]
    end

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animId

    loadedAnimations[animId] = animation
    return animation
end

function anims.Play(animId, settings)
    settings = settings or {}

    local track = getAnimator():LoadAnimation(getAnimation(animId))

    track.Looped = settings.Looped or false
    track.Priority = settings.Priority or Enum.AnimationPriority.Action

    track:Play(
        settings.FadeTime or 0.1,
        settings.Weight or 1,
        settings.Speed or 1
    )

    currentTracks[animId] = track
    return track
end

function anims.Stop(animId, fadeTime)
    local track = currentTracks[animId]

    if track then
        track:Stop(fadeTime or 0.1)
        currentTracks[animId] = nil
    end
end

function anims.StopAll(fadeTime)
    for id, track in pairs(currentTracks) do
        if track then
            track:Stop(fadeTime or 0.1)
        end
        currentTracks[id] = nil
    end
end

function anims.IsPlaying(animId)
    local track = currentTracks[animId]
    return track and track.IsPlaying or false
end

player.CharacterAdded:Connect(function()
    table.clear(currentTracks)
end)

return anims

--[[

วิธีใช้:

local anims = require(path.to.module)

-- เล่น animation ปกติ
local track = anims.Play(507770453)

-- เล่นแบบวนลูป
local track = anims.Play(507770453, {
    Looped = true
})

-- เล่นเร็ว 2 เท่า
local track = anims.Play(507770453, {
    Speed = 2
})

-- ตั้ง priority สูง
local track = anims.Play(507770453, {
    Priority = Enum.AnimationPriority.Action4
})

-- หยุด animation ตาม id
anims.Stop(507770453)

-- หยุดทั้งหมด
anims.StopAll()

-- เช็คว่ากำลังเล่นอยู่ไหม
print(anims.IsPlaying(507770453))

]]