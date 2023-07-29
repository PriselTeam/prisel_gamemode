net.Receive("darkrp_playerscale", function()
    local ply = net.ReadEntity()
    local scale = net.ReadFloat()

    if IsValid(ply) and scale > 0 then
        ply:SetModelScale(scale, 0)
        ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72 * scale))
    end
end)

function sendPlayerScale(scale)
    net.Start("darkrp_playerscale")
    net.WriteFloat(scale)
    net.SendToServer()
end
