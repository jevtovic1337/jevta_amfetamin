Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local burad = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



local spawnedBurad = 0
local BuradPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.Branje.jevtabranje.coords, true) < 50 then
			SpawnBuradPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #BuradPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(BuradPlants[i]), false) < 1 then
				nearbyObject, nearbyID = BuradPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
    
			if not isPickingUp then
				ESX.ShowHelpNotification('pritisni ~INPUT_CONTEXT~ da bi otvorio bure')
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				

				if isPickingUp then
					TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

					Citizen.Wait(2000)
					ClearPedTasks(playerPed)
					Citizen.Wait(1500)
	
					ESX.Game.DeleteObject(nearbyObject)
	
					table.remove(BuradPlants, nearbyID)
					spawnedBurad = spawnedBurad - 1
	
					TriggerServerEvent('revolucija:dajbure')
				else
					ESX.ShowNotification('Burad_inventoryfull')
				end

				isPickingUp = false

				
			end

		else
			Citizen.Wait(500)
		end

	end

end)]]

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(BuradPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnBuradPlants()
	while spawnedBurad < 15 do
		Citizen.Wait(0)
		local bureCoords = GenerateCocaLeafCoords()

		ESX.Game.SpawnLocalObject('prop_rad_waste_barrel_01', bureCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(BuradPlants, obj)
			spawnedBurad = spawnedBurad + 1
		end)
	end
end

function ValidateCocaLeafCoord(plantCoord)
	if spawnedBurad > 0 then
		local validate = true

		for k, v in pairs(BuradPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.Branje.jevtabranje.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCocaLeafCoords()
	while true do
		Citizen.Wait(1)

		local bureCoordX, bureCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		bureCoordX = Config.Branje.jevtabranje.coords.x + modX
		bureCoordY = Config.Branje.jevtabranje.coords.y + modY

		local coordZ = GetCoordZBurad(bureCoordX, bureCoordY)
		local coord = vector3(bureCoordX, bureCoordY, coordZ)

		if ValidateCocaLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZBurad(x, y)
	local groundCheckHeights = { 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 77
end


function OpenPlant()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    Citizen.Wait(10000)
    ESX.Game.DeleteObject(nearbyObject)
    TriggerServerEvent('jevta:dajitem')
    ClearPedTasksImmediately(PlayerPedId())
end




--[[CreateThread(function()
	local Burad = BoxZone:Create(vector3(1173.183, -2939.41, 5.9021), 15.0, 15.0, {
		name="burad",
		scale={5.0, 5.0, 5.0},
		debugPoly= true,
		minZ = 2.9021,
		maxZ = 9.9021
	})
end)]]

local function GetBuradLabel(name)
    for _, burad in pairs(Config.burad) do
        if burad.zone.name == name then return burad.label end
    end
end 
Citizen.CreateThread(function()
    for k, v in pairs(Config.burad) do

        burad[k] = BoxZone:Create(
            vector3(v.zone.x, v.zone.y, v.zone.z),
            v.zone.l, v.zone.w, {
                name = v.zone.name,
                heading = v.zone.h,
                debugPoly = false,
                minZ = v.zone.minZ,
                maxZ = v.zone.maxZ
            }
        )
		burad[k].type = v.type
        burad[k].label = v.label
    end
end)
function IsInsideZone(type, entity)
    local entityCoords = GetEntityCoords(entity)

	for k, v in pairs(burad) do
		if burad[k]:isPointInside(entityCoords) then
			currentburad = Config.burad[k]
			return true
		end
		if k == #burad then return false end
	end
    
end


exports.qtarget:AddTargetModel({`prop_rad_waste_barrel_01`}, {
	options = {
		{
			event = "jevta:branje",
			icon = "fa fa-flask",
			label = "Open the bucket",
			canInteract = function(entity)
				hasChecked = false
				if IsInsideZone('burad', entity) and not hasChecked then
					hasChecked = true
					return true
				end
			end
		},
	},
	distance = 2
})



trenutnoBere = false
RegisterNetEvent("jevta:branje", function()
	
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #BuradPlants, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(BuradPlants[i]), false) < 1 then
			nearbyObject, nearbyID = BuradPlants[i], i
		end
	end
	if nearbyObject and IsPedOnFoot(playerPed) and not trenutnoBere == true then
		ESX.TriggerServerCallback("getAmfetaminLimit", function(result)
			if result == true then
				trenutnoBere = true
				FreezeEntityPosition(playerPed, true)
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)
				TriggerEvent("panama_notifikacije:progressBar", "Collecting Amphetamine...", 3000)
				Citizen.Wait(2000)
				ClearPedTasks(playerPed)
				Citizen.Wait(1500)
				FreezeEntityPosition(playerPed, false)
				ESX.Game.DeleteObject(nearbyObject)
				trenutnoBere = false
				table.remove(BuradPlants, nearbyID)
				spawnedBurad = spawnedBurad - 1
				TriggerServerEvent('revolucija:dajbure')
			elseif result == false then
				ESX.ShowNotification("You have exceeded your inventory limit!")
			end
		end)
	end
end)
local IsAnimated = false
RegisterNetEvent('jevta:dodajhelt')
AddEventHandler('jevta:dodajhelt', function()

    local playerPed = PlayerPedId()
	if not IsAnimated then
		prop_name = 'prop_energy_drink'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				--TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 8.0, -8.0, 5000, 49, 0, 0, 0, 0)
				TriggerEvent("panama_notifikacije:progressBar", "Drinking Amphetamine...", 6000)
				Wait(6000)
				AddArmourToPed(playerPed, 50)
				-- SetPedArmour(playerPed, 50)
				SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 100)
				TriggerServerEvent("revolucija:removeAmfetamin", "JEBEMTIMATER")
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(vector3(-1164.30, -3477.55, 37.805))

	SetBlipSprite (blip, 436) --- change blip
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 5) --- change blip colour 
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Amphetamine")
	EndTextCommandSetBlipName(blip)
end)
