local isAnimal = false
local isKnockedOut = false
local originModel = GetHashKey('mp_m_freemode_01') -- [Needed before reloadSkin]

CreateThread(function()
    RegisterCommand('animal', function(source, args, rawCommand)
        if isAnimal then
            SetPlayerModel(PlayerId(), originModel) 
            Wait(100) -- [WARNING! 100ms is the quickest interval without causing death.]
            TriggerEvent("illenium-appearance:client:reloadSkin") 
            isAnimal = false
            isKnockedOut = false
            return
        end
        
        isAnimal = true
        local playerPed = GetPlayerPed()
        local animalModel
        local animals = {
            pigeon = 'a_c_pigeon',
            rat = 'a_c_rat',
            cat = 'a_c_cat_01',
            crow = 'a_c_crow',
            deer = 'a_c_deer',
            hen = 'a_c_hen',
            rabbit = 'a_c_rabbit_01',
            hawk = 'a_c_chickenhawk'
        }
        
        local animalName = string.lower(args[1]) -- [Ensure anycase in command.]
        
        if animals[animalName] then
            animalModel = GetHashKey(animals[animalName])
        else
            isAnimal = false
        end
        
        RequestModel(animalModel)
        while not HasModelLoaded(animalModel) do
            Wait(0)
        end
        
        SetPlayerModel(PlayerId(), animalModel)
        SetModelAsNoLongerNeeded(animalModel)
        
        CreateThread(function()
            while isAnimal do
                Wait(1000) -- [Test if lower value works when the issue with particles is sorted.]
                if isAnimal then
                    local smokeLocation = GetEntityCoords(playerPed)
                    TriggerServerEvent('startSmokeEffect', GetPlayerServerId(PlayerId()), smokeLocation)
                end
            end
        end)
        
        CreateThread(function()
            while isAnimal do
                Wait(100)
                local inLastStand = exports.qbx_medical:getLaststand()
                if IsPedInAnyVehicle(playerPed, false) or IsEntityInWater(playerPed) or inLastStand then
                    SetPlayerModel(PlayerId(), originModel)
                    Wait(100) -- [WARNING! 100ms is the quickest interval without causing death.]
                    TriggerEvent("illenium-appearance:client:reloadSkin")
                    isAnimal = false
                    isKnockedOut = false
                    return
                end
            end
        end)
    end, false)
end)

RegisterNetEvent('playSmokeEffect')
AddEventHandler('playSmokeEffect', function(smokeLocation)
    local particleDict = "core"
    local particleName = "blood_stab"
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        RequestNamedPtfxAsset(particleDict)
        Wait(10)
    end
    
    
    for i = 1, 10 do
        UseParticleFxAssetNextCall(particleDict)
        StartParticleFxLoopedAtCoord(particleName, smokeLocation.x, smokeLocation.y, smokeLocation.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Wait(100)
    end
end)