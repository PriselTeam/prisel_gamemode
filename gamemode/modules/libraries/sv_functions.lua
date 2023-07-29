DarkRP = DarkRP or {}
DarkRP.Library = DarkRP.Library or {}

function DarkRP.Library.HideWeapons(ply, should_hide)
	for _, v in pairs(ply:GetWeapons()) do
		v:SetNoDraw(should_hide)
	end

	local physgun_beams = ents.FindByClassAndParent("physgun_beam", ply)
	if physgun_beams then
		for i = 1, #physgun_beams do
			physgun_beams[i]:SetNoDraw(should_hide)
		end
	end
end

local cHTTP = nil

if pcall(require, "chttp") and CHTTP ~= nil then
	cHTTP = CHTTP
	print("Utilisation de CHTTP")
else
	cHTTP = HTTP
	print("Utilisation de HTTP")
end

function DarkRP.Library.MakeHTTPRequest(url, onSuccess, onFailure)
    if cHTTP == nil then
        print("La bibliothèque HTTP n'est pas disponible.")
        return
    end

    if not url then
        print("URL invalide pour la requête HTTP.")
        return
    end

    -- Effectuer la requête HTTP
    cHTTP({
        url = url,
        method = "GET",
        success = function(code, body, headers)
            if onSuccess then
                onSuccess(code, body, headers)
            end
        end,
        failed = function(reason)
            if onFailure then
                onFailure(reason)
            end
        end
    })
end

function DarkRP.Library.SendWebhook(webhook, msg, fields)
	if not webhook or not msg then return end
	
	local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") -- Current UTC timestamp
	local embed = {
		["username"] = "Prisel - Logs",
		["embeds"] = {{
			["title"] = "Logs Prisel V3",
			["description"] = msg,
			["color"] = 16711680,
			["timestamp"] = timestamp,
			["fields"] = fields
		}}
	}

	local jsonEmbed = util.TableToJSON(embed)

	cHTTP({
		method = "post",
		type = "application/json; charset=utf-8",
		headers = {
			["User-Agent"] = "Discord Prisel V3"
		},
		url = webhook,
		body = jsonEmbed,
		failed = function(sError)
			print("[Prisel V3] Erreur de webhook HTTP :", sError)
		end,
		success = function(iCode, sResponse)
			if iCode ~= 204 then
				print("[Prisel V3] Code d'erreur de webhook HTTP :", iCode, sResponse)
			end
		end
	})
end
