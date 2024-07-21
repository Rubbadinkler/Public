local isAnimal = false
local isKnockedOut = false
local originModel = GetHashKey('mp_m_freemode_01') -- [Needed before reloadSkin]


RegisterCommand('animal', function(source, args, rawCommand)
    local currentLocation = GetEntityCoords(PlayerPedId(), true)
    if isAnimal then
        TriggerEvent('changeForm')
        return
    end

    isAnimal = true
    local playerPed = GetPlayerPed(PlayerPedId())
    local animalModel
    local animalName = string.lower(args[1]) -- [Ensure anycase in command.]
    
    if config.animals[animalName] then
        animalModel = GetHashKey(config.animals[animalName])
    else
        isAnimal = false
    end
    
    RequestModel(animalModel)
    while not HasModelLoaded(animalModel) do
        Wait(0)
    end
    
    SetPlayerModel(PlayerId(), animalModel)
    TriggerServerEvent('startParticleEffect', GetPlayerServerId(PlayerId()), GetEntityCoords(PlayerPedId(), true))
    SetModelAsNoLongerNeeded(animalModel)
    
    CreateThread(function()
        while isAnimal do
            local inLastStand = exports.qbx_medical:getLaststand()
            Wait(1000)
            if IsPedInAnyVehicle(PlayerPedId(), true) or IsEntityInWater(playerPed) or inLastStand then
                TriggerEvent('changeForm')
                break
            end
        end
    end)
end, false)

RegisterNetEvent('playParticleEffect')
AddEventHandler('playParticleEffect', function(effectLocation)
    RequestNamedPtfxAsset(config.particleEffectDict)
    while not HasNamedPtfxAssetLoaded("core") do
        RequestNamedPtfxAsset(config.particleEffectDict)
        Wait(1)
    end
    UseParticleFxAssetNextCall(config.particleEffectDict)
    StartParticleFxLoopedAtCoord(config.particleEffectName, effectLocation.x, effectLocation.y, effectLocation.z, 0.0, 0.0, 0.0, config.particleEffectScale, false, false, false, false)
end)

RegisterNetEvent('changeForm')
AddEventHandler('changeForm', function()
    SetPlayerModel(PlayerId(), originModel)
    Wait(100) -- [WARNING! 100ms is the quickest interval without causing death.]
    TriggerEvent("illenium-appearance:client:reloadSkin")
    TriggerServerEvent('startParticleEffect', GetPlayerServerId(PlayerId()), GetEntityCoords(PlayerPedId(), true))
    isAnimal = false
    isKnockedOut = false
    paticlePlayed = false
    isAnimal = false
    isKnockedOut = false
end)