local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("zoyy0_distrub:checkMoney", function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	lcoal money = xPlayer.getMoney()

	cb(money)
end)


RegisterServerEvent("zoyy0_distrub:removeMoney")
AddEventHandler("zoyy0_distrub:removeMoney", function(money)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	xPlayer.removeMoney(money)
end)
