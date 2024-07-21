-- [Global dict-load trigger]

RegisterServerEvent('startSmokeEffect')
AddEventHandler('startSmokeEffect', function(playerServerId, smokeLocation)
    print("Triggering particle effect for player with server ID: " .. playerServerId)
    TriggerClientEvent('playSmokeEffect', playerServerId, smokeLocation)
end)