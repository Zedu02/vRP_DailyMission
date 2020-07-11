local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_confisca")
menu = {name="Taskuri Menu",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
menugigi = {name="Taskuri Menu",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
MySQL.createCommand("vRP/addxenon" , "UPDATE vrp_users SET xenon = @xenon WHERE id = @user_id")
math.randomseed(os.time())
local Chars = {}
for Loop = 0, 255 do
   Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)

local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
end

function string.random(Length, CharSet)

   local CharSet = CharSet or '.'

   if CharSet == '' then
      return ''
   else
      local Result = {}
      local Lookup = Built[CharSet] or AddLookup(CharSet)
      local Range = #Lookup

      for Loop = 1,Length do
         Result[Loop] = Lookup[math.random(1, Range)]
      end

      return table.concat(Result)
   end
end

local stringuri = {}

s = 1000
math.randomseed(os.time())
while s > 0  do
	table.insert(stringuri , string.random(12,'ABCDEFGHIJKLMNOPQRSTUVWXYZ'))
	s = s - 1
end
local name2 = stringuri[math.random(1 , #stringuri)]
local taskuri = {
	"[<font color = '#00e5ff'>Saracie<font color = 'white'>] <font color = 'white'>Da bani unui jucator",
	"[<font color = '#00e5ff'>Cumparaturi<font color = 'white'>] <font color = 'white'>Cumpara food",
	"[<font color = '#00e5ff'>Mafiotas<font color = 'white'>] <font color = 'white'>Da rob unui player din K",
	"[<font color = '#00e5ff'>Valoare<font color = 'white'>] <font color = 'white'>Cumpara o masina",
	"[<font color = '#00e5ff'>Chat<font color = 'white'>] <font color = 'white'>Scrie "..'"'..name2..'"'.." pe chat",
	"[<font color = '#00e5ff'>Amenzi<font color = 'white'>] <font color = 'white'>Plateste un impozit"
}
local xenoncolor = {
	{ name = "White", xenon = 0, price = 1000},
	{ name = "Blue", xenon = 1, price = 1000},
	{ name = "Electric Blue", xenon = 2, price = 1000},
	{ name = "Mint Green", xenon = 3, price = 1000},
	{ name = "Lime Green", xenon = 4, price = 1000},
	{ name = "Yellow", xenon = 5, price = 1000},
	{ name = "Golden Shower", xenon = 6, price = 1000},
	{ name = "Orange", xenon = 7, price = 1000},
	{ name = "Red", xenon = 8, price = 1000},
	{ name = "Pony Pink", xenon = 9, price = 1000},
	{ name = "Hot Pink",xenon = 10, price = 1000},
	{ name = "Purple", xenon = 11, price = 1000},
	{ name = "Blacklight", xenon = 12, price = 1000}
}
function GetXenonById(id)
	local contor = 0
	for i , v in pairs(xenoncolor) do
		if contor == id then
			return v.name
		end
		contor = contor + 1
	end
end
function GetXenonPriceById(id)
	local contor = 0
	for i , v in pairs(xenoncolor) do
		if contor == id then
			return v.price
		end
		contor = contor + 1
	end
end
misiuni = {}
local vRPmisiuni = {}
local frecv = {}
local spawned = {}
Tunnel.bindInterface("vRP_misiuni",vRPmisiuni)
Proxy.addInterface("vRP_misiuni",vRPmisiuni)

function misiuniupdate(user_id)
	for i = 1 , #taskuri do
		frecv[i] = 0
	end
	for i = 1 , 3 do 
		local poz = math.random(1 , #taskuri)
		while frecv[poz] > 0 do
			poz = math.random(1 , #taskuri)
		end
		frecv[poz] = frecv[poz] + 1
		misiuni[user_id][i] = taskuri[poz]
	end
end

function vRPmisiuni.hasMission(user_id , pozitie)
	for i = 1 , #misiuni[user_id] do
		if(misiuni[user_id][i] == taskuri[pozitie]) then
			return true
		end	
	end
	return false
end

function vRPmisiuni.eraseMission(user_id , pozitie)
	local player = vRP.getUserSource({user_id})
	local poz = vRPmisiuni.getMissionPoz(user_id , pozitie)
	misiuni[user_id][poz] = "Misiune <font color = '#00e5ff'>Facuta"
	menu["Misiunea #"..poz] = {function(player , choice) end ,  "Misiune <font color = '#00e5ff'>Facuta"}
	local sansa = math.random(1 , 100)
	if sansa <= 5 then
		MySQL.query("vRP/getClan" , {user = user_id} , function(rows , affected)
			if #rows > 0 then
				local xenon = math.random(0 , 12)
				vRPclient.notify(player , {"[~b~Xenons~w~] ~g~Ai castigat xenoane\n~b~Pret Tuning ~w~"..GetXenonPriceById(xenon).."$\n~b~Culoare ~w~"..GetXenonById(xenon)})
				local prev = rows[1].xenon
				if tonumber(rows[1].xenon) == -1 then
					text = xenon
				else
					text = rows[1].xenon..":"..xenon
				end
				MySQL.query("vRP/addxenon" , {xenon = text , user_id = user_id})
			end
		end)
	end
end

function vRPmisiuni.getMissionPoz(user_id , pozitie)
	for i = 0 , #misiuni[user_id] do
		if misiuni[user_id][i] == taskuri[pozitie] then
			return i
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if not spawned[user_id] then
		spawned[user_id] = true
		misiuni[user_id] = {}
		misiuniupdate(user_id)
		for i = 1 , #misiuni[user_id] do 
			menu["Misiunea #"..i] = {function(player , choice) end , misiuni[user_id][i]}
		end
    		vRPclient.notify(source , {"[~b~Misiuni~w~] ~g~Ti-au fost adaugate daily missionuri de facut"})
	end
end)

menugigi["Misiuni Zilnice"] = {function(player , choice)
	vRP.openMenu({player , menu})
end}
vRP.registerMenuBuilder({"main", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		add(menugigi)
	end
end})

RegisterCommand("misiuni", function(player, args, msg)
	local user_id = vRP.getUserId({player})
	if misiuni[user_id] then
	vRP.openMenu({player , menu})
	else
		vRPclient.notify(player , {"[~b~Misiuni~w~] ~r~Nu ai misiuni de facut"})
	end
 end)

 RegisterCommand("testmisiuni", function(player, args, msg)
	local user_id = vRP.getUserId({player})
	misiuni[user_id] = {}
	misiuniupdate(user_id)
	for i = 1 , #misiuni[user_id] do 
		menu["Misiunea #"..i] = {function(player , choice) end , misiuni[user_id][i]}
	end
 end)


 AddEventHandler('sonydamuielasclavi', function(source, name, msg)
		local user_id = vRP.getUserId({source})
	if misiuni[user_id] then
		if vRPmisiuni.hasMission(user_id , 5) and msg == name2 then
			vRP.giveMoney({user_id , 1500})
			vRPclient.notify(source , {"[~b~Misiuni~w~] ~g~Misiune completata !\n~b~Ai primit~w~ 1500$"})
			vRPmisiuni.eraseMission(user_id , 5)
			CancelEvent()
		end
	end
end)