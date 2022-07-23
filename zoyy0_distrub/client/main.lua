ESX					= nil
local PlayerData	= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", fucntion(obj)
			ESX = obj
		end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId(), true)
		for k in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(Config.Zones[k].x, Config.Zones[k].y, Config.Zones[k].z, coords) < 1 then
				Marker("~w~[~r~E~w~] Distributeur Automatique", 27, Config.Zones[k].x, Config.Zones[k].y, Config.Zones[k].z - 0.99)
				if IsControlJustReleased(0, key['E']) then
					FoodMeny()
				end
			elseif GetDistanceBetweenCoords(Config.Zones[k].x, Config.Zones[k].y, Config.Zones[k].z, coords) < 5 then
				Marker("~w~Distributeur Automatique", 27, Config.Zones[k].x, Config.Zones[k].y, Config.Zones[k].z - 0.99)
			end
		end
	end
end)

function FoodMeny()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'foodstand',
		{
			title		= 'Distributeur Automatique',
			align		= 'right'
			elements	= {
				{label = 'Coca Cola 32cl <span style="color:green"> '  .. Config.DrinkPrice ..'  $</span> ',	prop = 'prop_ecola_can',							type = 'drink'},
				{label = 'Jus d\'orange 25cl <span style="color:green"> '  .. Config.DrinkPrice ..'  $</span> ',	prop = 'prop_orang_can_01',						type = 'drink'},
				{label = 'Café court 10cl <span style="color:green"> '  .. Config.DrinkPrice ..'  $</span> ',	prop = 'prop_coffe_cup_trailer',					type = 'drink'},
				{label = 'Café long 15cl <span style="color:green"> '  .. Config.DrinkPrice ..'  $</span> ',	prop = 'prop_coffe_cup_trailer',					type = 'drink'},
				{label = 'Sprite 25cl <span style="color:green"> '  .. Config.DrinkPrice ..'  $</span> ',	prop = 'prop_ld_can_01',								type = 'drink'},
				{label = 'Mister Cocktail <span style="color:green"> '  .. Config.DrinkPrice ..'  $</span> ',	prop = 'prop_amb_beer_bottle',						type = 'drink'},


			}
		}, function(data, menu)
			local selected = data.current.type
			if selected == 'drink' then

				ESX.TriggerServerCallback("zoyy0_distrub:checkMoney", function(money)
					if money >= Config.DrinkPrice then
						ESX.UI.Menu.CloseAll()
						TriggerServerEvent("zoyy0_distrub:removeMoney", Config.DrinkPrice)
						drink(data.current.prop)
					else
                        ESX.ShowNotification("Va travailler, tu n'a pas assez d'argent pour ça.")
                    end
                end)
            end
        end, function(data, menu)
            menu.close() 
    end)
end

function drink(prop)
	local playerPed = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(playerPed))
	prop = CreateObject(GetHashKey(prop), x, y, z+0.2, true, true, true)
	AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 18905), 0.15, 0.025, 0.010, 270.0, 175.0, 0.0, true, true, false, true, 1, true)
	RequestAnimDict('mp_player_intdrink')
	while not HasAnimDictLoaded('mp_player_intdrink') do
		Wait(0)
	end
	TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	for i=1, 50 do
		Wait(300)
		TriggerEvent('esx_status:add', 'thirst', 10000)
	end
	IsAnimated = false
	ClearPedSecondaryTask(playerPed)
	DeleteObject(prop)
end
