-- N3jkodem









ESX                           = nil
-----------------------------------------------
local smietniki = {
    [1] = -206690185,
    [2] = 682791951,
    [3] = 666561306,
    [4] = -468629664,
    [5] = -5943724,
    [6] = 1437508529,
    [7] = 234941195,
    [8] = 1380691550,
    [9] = -1830793175,
    [10] = 1748268526,
    [11] = -1830793175,
    [12] = -329415894,
    [13] = -1426008804,
    [14] = -341442425,
    [15] = 1143474856, 
    [16] = -93819890,
    [17] = -317177646,
    [18] = -1096777189,
    [19] = 437765445,
    [20] = -130812911,
    [21] = 1614656839,
    [22] = 122303831,
    [23] = 1437508529,
    [24] = -5943724,
    [25] = -468629664,
    [26] = -58485588,
    [27] = 413198204,
    [28] = -2096124444,
    [29] = 998415499,
    [30] = 1329570871,
    [31] = -228596739,
    [32] = 682791951,
    [33] = 218085040,
    [34] = -206690185,
}




prop_dumpster_3a=-206690185
prop_dumpster_4b=682791951
prop_dumpster_02a=666561306
prop_bin_13a=122303831
prop_bin_02a=1614656839 
prop_bin_03a=-130812911 
prop_bin_09a=437765445 
prop_bin_08a=-1096777189 
prop_bin_delpiero=-317177646 
prop_bin_04a=-93819890 
prop_bin_06a=1143474856 
prop_bin_11a=-341442425
prop_bin_07c=-1426008804
prop_bin_10b=-329415894 
prop_bin_10a=-1830793175 
prop_bin_14a=1748268526
prop_bin_delpiero_b=1380691550 
prop_bin_beach_01a=234941195 
prop_bin_01a=1437508529 
prop_bin_beach_01d=-5943724 
prop_bin_07b=-468629664
prop_dumpster_02b=-58485588 
prop_bin_08open=-413198204 
prop_bin_12a=-2096124444 
prop_bin_14b=998415499 
prop_bin_05a=1329570871
prop_bin_07a=-228596739
prop_dumpster_4b=682791951 
prop_dumpster_01a=218085040 
prop_dumpster_3a=-206690185
-------------------------------------------------
local smietnikwykonaj = false 
local porozmawiajzmariuszem = true 
RegisterNetEvent('n3j_sprawdzsmietnik')
AddEventHandler('n3j_sprawdzsmietnik', function()
  if IsNearSmietnik() then
    smietnikwykonaj = true 
    SprawdzCzyNieWPojezdzie()
  else
    exports['mythic_notify']:DoHudText('error', 'Nie ma tu śmietnika')
  end
end)

function IsNearSmietnik()
    for i = 1, #smietniki do
      local objFound = GetClosestObjectOfType( GetEntityCoords(GetPlayerPed(-1)), 0.75, smietniki[i], 0, 0, 0)
  
      if DoesEntityExist(objFound) then
        TaskTurnPedToFaceEntity(GetPlayerPed(-1), objFound, 3.0)
        return true
      end
    end
  
    return false
end

RegisterCommand('smietnik', function()

    TriggerEvent("n3j_sprawdzsmietnik")
end)

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(5)
    end
end)


function SprawdzCzyNieWPojezdzie()
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true)
     if vehicle then 
        exports['mythic_notify']:DoHudText('error', 'Nie możesz przeszukiwać śmietnika będąc w pojeździe')
     else 
        Przeszukiwanie()
     end 
end        

function Przeszukiwanie()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    local finished = exports["gen-taskbar"]:taskBar(10000,"Przeszukiwanie śmietnika")
    Citizen.Wait(1000)

    TriggerServerEvent("n3j_smietniki:butelki")
    

    ClearPedTasks(PlayerPedId())
end


Citizen.CreateThread(function()

	RequestModel(Config.NPCHash)
	while not HasModelLoaded(Config.NPCHash) do
	Wait(1)

	end

	
		pan_mariuszek = CreatePed(1, Config.NPCHash, Config.Lokalizacja.x, Config.Lokalizacja.y, Config.Lokalizacja.z, Config.Lokalizacja.h, false, true)
		SetBlockingOfNonTemporaryEvents(pan_mariuszek, true)
		SetPedDiesWhenInjured(pan_mariuszek, false)
		SetPedCanPlayAmbientAnims(pan_mariuszek, true)
		SetPedCanRagdollFromPlayerImpact(pan_mariuszek, false)
		SetEntityInvincible(pan_mariuszek, true)
		FreezeEntityPosition(pan_mariuszek, true)
		TaskStartScenarioInPlace(pan_mariuszek, "WORLD_HUMAN_SMOKING", 0, true);

end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local v = Config.Lokalizacja 
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local chujumuju
                if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 3.0)  then
                    DrawText3D(v.x,v.y,29.5,("~g~[E]~w~ Aby srzedać butelki"))
                  if IsControlJustPressed(1, 38) then 
                    Sprzedaz()
                   end 
                end
             end		
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modTurbo        = true
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end


function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function Sprzedaz()
    TriggerServerEvent("n3j_kasazabutle")
end    
