local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

RegisterServerEvent("n3j_smietniki:butelki")
AddEventHandler("n3j_smietniki:butelki", function()
    local player = ESX.GetPlayerFromId(source)
    
    math.randomseed(os.time())
    local luck = math.random(0, 50)
    local iloscbutelek = math.random(1,3)

    if luck <= 40 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'W śmietniku nie było żadnych butelek'})
        
    else
        player.addInventoryItem("bottle", iloscbutelek)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type ='inform', text = 'Znalazłeś butelki: ' ..iloscbutelek})
        
    end
end)


RegisterServerEvent('n3j_kasazabutle')
AddEventHandler('n3j_kasazabutle', function()
	local kaska = math.random(Config.Kasazabutle.Min, Config.Kasazabutle.Max)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local butelki = xPlayer.getInventoryItem('bottle')

	if butelki.count > 0 then
		xPlayer.removeInventoryItem('bottle', 1)
		if Config.Zezwol then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Zarobiłeś: '.. kaska .. '$'})
			xPlayer.addMoney(700)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Mareczek nie jest zadowolony! Nie lubi jak ktoś wciska mu kit!'})
		xPlayer.removeMoney(700)
	end
end)
