-- [Global dict-load trigger]

RegisterServerEvent('startParticleEffect')
AddEventHandler('startParticleEffect', function(playerServerId, smokeLocation)
    TriggerClientEvent('playParticleEffect', playerServerId, smokeLocation)
end)