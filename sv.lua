local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("vrp_job",emP)

--[ Pay ]-----------------------------------------------------------------------------------------------------------------------------

function emP.checkPayment()
    local sorce = source
    local user_id = vRP.getUserId(source)
    if user_id then
        randmoney = math.random(57,173)
        -- vRP.GiveMoney(user_id,parseInt(randmoney)) -- Caso seu dinheiro seja setado por item, descomente essa linha.
        -- vRP.giveInventoryItem(user_id,"dinheiro",parseInt(randmoney)) -- Caso o dinheiro seja setado como um valor, descomente essa linha
        TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." dólares</b>.")
        return true
    end
end