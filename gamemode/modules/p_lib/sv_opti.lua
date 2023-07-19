/*
 * -------------------------
 * • Fichier: sv_opti.lua
 * • Projet: p_lib
 * • Création : Tuesday, 18th July 2023 11:43:51 pm
 * • Auteur : Ekali
 * • Modification : Tuesday, 18th July 2023 11:43:51 pm
 * • Destiné à Prisel.fr en V3
 * -------------------------
 */
 local function antiWidget(ent)
	if ent:IsWidget() then
		hook.Add("PlayerTick", "TickWidgets", function(pl, mv)
			widgets.PlayerTick(pl, mv)
		end)
		hook.Remove("OnEntityCreated", "WidgetInit") -- calls it only once
	end
end

hook.Add("OnEntityCreated", "PriselV3::WidgetInit", antiWidget)
