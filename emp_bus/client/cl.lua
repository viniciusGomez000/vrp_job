local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

emP = Tunnel.getInterface("emp_bus")

--[ VARIABLES ]---------------------------------------------------------------------------------------------------------------------------

local selecionado = 1
local servico = false
local onNui = false
local toggle = {
	vec3(453.63, -600.62, 28.6),
}
local locs = {
	[1] = vec3(448.59, -587.93, 28.5),
	[2] = vec3(441.57, -574.49, 28.5 ),
}

--[ FUNCTION ]---------------------------------------------------------------------------------------------------------------------------

function ToogleActionNui()
    onNui = not onNui
    if onNui then
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "show"
        })
    else
        SetNuiFocus(false)
        SendNUIMessage({
            action = "hide"
        })
    end
end

--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("botao", function(data)
    servico = true
    selecionado = 1
    CriandoBlip(locs,selecionado)
    TriggerEvent("Notify","sucesso","Você entrou em serviço.")
    rota()
    ToogleActionNui()
end)

RegisterNUICallback("botao2", function(data)
    servico = false
	RemoveBlip(blips)
	TriggerEvent("Notify","aviso","Você saiu de serviço.")
    ToogleActionNui()
end)

--[ START JOB ]-----------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    while true do
        local idle = 1000
        local coords = GetEntityCoords(PlayerPedId())	
        for k,v in pairs(toggle) do
            local distance = #(coords - v)
          
            if distance <= 3.0 then
		idle = 5
                DrawText3D(v.x,v.y,v.z,"~w~Pressione ~r~[E] ~w~para abrir")
                if distance <= 1.2 and IsControlJustPressed(0,38) then
                    ToogleActionNui()
                end
            end
        end
        Citizen.Wait(idle)
    end
end)

--[ ROTAS ]-----------------------------------------------------------------------------------------------------------------------------

function rota()
    Citizen.CreateThread(function()
        while true do
            local idle = 1000
            if servico then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local distance = #(coords - locs[selecionado])
                if distance <= 10.0 then
                    DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,247,217,99,100,1,0,0,1)
                    idle = 5
                    if distance <= 2.5 and IsControlJustPressed(0,38) then
                        if IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("bus")) or IsVehicleModel(GetVehiclePedIsUsing(ped),GetHashKey("coach")) then
                            if emP.checkPayment() then
                                RemoveBlip(blips)
                                if selecionado == #locs then
                                    selecionado = 1
                                else
                                    selecionado = selecionado + 1
                                end
                                CriandoBlip(locs,selecionado)
                            end
                        end
                    end
                end
            else
                break
            end
            Citizen.Wait(idle)
        end
    end)
end

--[ OTHERS ]-----------------------------------------------------------------------------------------------------------------------------

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pontos de ônibus")
	EndTextCommandSetBlipName(blips)
end

--[ OTHERS ]-----------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false, false)
end)