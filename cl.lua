local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

emP = Tunnel.getInterface("vrp_job")

--[ VARIABLES ]---------------------------------------------------------------------------------------------------------------------------

local servico = false
local onNui = false
local toggle = {
    {['x'] = 453.97, ['y'] = -600.69, ['z'] = 28.59}
}
local locs = {
	[1] = { ['x'] = 307.17, ['y'] = -764.79, ['z'] = 29.2 },
	[2] = { ['x'] = 411.22, ['y'] = -768.25, ['z'] = 29.14 }
}

--[ FUNCTION ]---------------------------------------------------------------------------------------------------------------------------

function ToogleActionNui()
    onNui = not onNui
    if onNui then
        -- DoScreenFadeOut(100) -- Deixa a tela preta
        SetNuiFocus(true, true)
        SendNUIMessage({
            mostre = true
        })
    else
        SetNuiFocus(false)
        SendNUIMessage({
            mostre = false
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
        for k,v in pairs(toggle) do
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
            local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
            local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
            local toggle = toggle[k]
            
            if distance <= 3.0 then
                DrawText3D(toggle.x,toggle.y,toggle.z,"~w~Pressione ~r~[E] ~w~para abrir")
                idle = 5
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
                local x,y,z = table.unpack(GetEntityCoords(ped))
                local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
                local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

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
	AddTextComponentString("Entrega de Encomenda")
	EndTextCommandSetBlipName(blips)
end