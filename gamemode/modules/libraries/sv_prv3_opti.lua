 local function antiWidget(ent)
	if ent:IsWidget() then
		hook.Add("PlayerTick", "TickWidgets", function(pl, mv)
			widgets.PlayerTick(pl, mv)
		end)
		hook.Remove("OnEntityCreated", "WidgetInit") -- calls it only once
	end
end

hook.Add("OnEntityCreated", "PriselV3::WidgetInit", antiWidget)

util.AddNetworkString("PriselV3::PlayerAdmin")

net.Receive("PriselV3::PlayerAdmin", function(_, ply)
	local action = net.ReadUInt(2)


	if action == 1 then
		if not ply:PIsStaff() then return end
		local bool = net.ReadBool()
		if ply:HasAdminMode() == bool then return end
		ply:SetAdminMode(bool)
	end
end)