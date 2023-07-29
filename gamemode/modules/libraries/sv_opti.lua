local function antiWidget(ent)
	if ent:IsWidget() then
		hook.Add("PlayerTick", "TickWidgets", function(pl, mv)
			widgets.PlayerTick(pl, mv)
		end)
		hook.Remove("OnEntityCreated", "WidgetInit") -- calls it only once
	end
end

hook.Add("OnEntityCreated", "PriselV3::WidgetInit", antiWidget)
