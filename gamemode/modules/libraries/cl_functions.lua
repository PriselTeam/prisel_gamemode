DarkRP = DarkRP or {}
DarkRP.ScrW = ScrW()
DarkRP.ScrH = ScrH()

DarkRP.Library = DarkRP.Library or {}
DarkRP.Library.Sounds = DarkRP.Library.Sounds or {}
DarkRP.Library.Fonts = DarkRP.Library.Fonts or {}
DarkRP.Library.PrecachedCircles = DarkRP.Library.PrecachedCircles or {}
local materials = {}

hook.Add("OnScreenSizeChanged", "Prisel::OnScreenSizeChanged:LibraryDarkRP", function()
    if DarkRP.ScrW ~= ScrW() or DarkRP.ScrH ~= ScrH() then 
        DarkRP.ScrW = ScrW()
        DarkRP.ScrH = ScrH()
	
        for k, v in pairs(DarkRP.Library.Fonts) do
            surface.CreateFont(k, {
                font = v.font,
                size =ScreenScale(v.size),
                weight = v.weight
            })

            DarkRP.Library.DebugPrint("Updated font: " .. k)
        end
    end
end)

function DarkRP.Library.Font(size, weight, font)
    weight = weight or 0
    font = font or "Montserrat"

    local fontName = "DarkRP.Library:Fonts:"..font.."::"..size..":"..weight
    if DarkRP.Library.Fonts[fontName] then return fontName end
    DarkRP.Library.Fonts[fontName] = {
        font = font,
        size = size,
        weight = weight
    }

    surface.CreateFont(fontName, {
        font = font,
        size = ScreenScale(size),
        weight = weight
    })

    DarkRP.Library.DebugPrint("Created font: " .. fontName)

    return fontName
end

function DarkRP.Library.LerpAlphaColor(color, toA, t)
  if not IsColor(color) or not isnumber(toA) or not isnumber(t) then return color_white end

  color.a = Lerp(t, color.a, toA)
  return Color(color.r, color.g, color.b, color.a)
end

function DarkRP.Library.Lerp2DPos(iFrac, tFrom, tTo)
    return {x = Lerp(iFrac, tFrom.x, tTo.x), y = Lerp(iFrac, tFrom.y, tTo.y)}
end


function DarkRP.Library.LerpColor(iFrac, cFrom, cTo)
    return LerpVector(iFrac, cFrom:ToVector(), cTo:ToVector()):ToColor()
  end

function DarkRP.Library.ColorNuance(color, percentage)
    if not IsColor(color) or not isnumber(percentage) then return color_white end

    local r, g, b, a = color.r, color.g, color.b, color.a or 255

    percentage = percentage / 100

    r = math.Clamp(r * (1 + percentage), 0, 255)
    g = math.Clamp(g * (1 + percentage), 0, 255)
    b = math.Clamp(b * (1 + percentage), 0, 255)

    return Color(r, g, b, a)
end

function DarkRP.Library.AlphaColor(color, alpha)
  if not IsColor(color) or not isnumber(alpha) then return color_white end

  return Color(color.r, color.g, color.b, alpha)
end

function DarkRP.Library.DrawMaterialSwing(material, x, y, width, height, rotationRange, rotationSpeed, color)
    surface.SetDrawColor(color or color_white)
    local rotation = math.sin(CurTime() * rotationSpeed) * rotationRange

    surface.SetMaterial(material)
    surface.DrawTexturedRectRotated(x, y, width, height, rotation)
end

function DarkRP.Library.DrawMulticolorText(font, x, y, xAlign, yAlign, ...)
    surface.SetFont(font)
    local curX = x
    local curColor = nil
    local allText = ""
    for k, v in pairs{...} do
        if not IsColor(v) then
            allText = allText .. tostring(v)
        end
    end
    local w, h = surface.GetTextSize(allText)
    if xAlign == TEXT_ALIGN_CENTER then
        curX = x - w / 2
    elseif xAlign == TEXT_ALIGN_RIGHT then
        curX = x - w
    end

    if yAlign == TEXT_ALIGN_CENTER then
        y = y - h / 2
    elseif yAlign == TEXT_ALIGN_BOTTOM then
        y = y - h
    end

    for k, v in pairs{...} do
        if IsColor(v) then
            curColor = v
            continue
        elseif curColor == nil then
            curColor = colorWhite
        end
        local text = tostring(v)
        surface.SetTextColor(curColor)
        surface.SetTextPos(curX, y)
        surface.DrawText(text)
        curX = curX + surface.GetTextSize(text)
    end
end

function DarkRP.Library.SoundURL(sUrl)
    sound.PlayURL(sUrl, "", 
    function(station)
        print(type(station))
        if IsValid(station) then
            station:SetVolume(0.5)
            station:Play()
        end 
    end)
end

function DarkRP.Library.MakeCirclePoly(iX, iY, iRadius, iSides)
    local poly = {}

    local iAngleIncrement = (2 * math.pi) / iSides

    for i = 1, iSides do
        local iAngle = iAngleIncrement * i
        local iX2 = iX + iRadius * math.cos(iAngle)
        local iY2 = iY + iRadius * math.sin(iAngle)

        table.insert(poly, { x = iX2, y = iY2 })
    end

    return poly
end

function DarkRP.Library.DrawCircle(iX, iY, iRadius, iSeg)
	local tCircle = {}

	table.insert(tCircle, {x = iX, y = iY, u = 0.5, v = 0.5})
	for i = 0, iSeg do
		local a = math.rad(( i / iSeg) * -360)
		table.insert(tCircle, {x = iX + math.sin(a) * iRadius, y = iY + math.cos(a) * iRadius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	end

	local a = math.rad(0)
	table.insert(tCircle, {x = iX + math.sin(a) * iRadius, y = iY + math.cos(a) * iRadius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

	surface.DrawPoly(tCircle)
end

function DarkRP.Library.DrawArc(x, y, ang, p, rad, color, seg)
	seg = seg or 80
	ang = (-ang) + 180
	local circle = {}

	table.insert(circle, {
		x = x,
		y = y
	})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {
			x = x + math.sin(a) * rad,
			y = y + math.cos(a) * rad
		})
	end

	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(circle)
end


local installedMat = {}
local pathCDN = "https://yaguxxxx.fr/PriselCDN/"

function DarkRP.Library.FetchCDN(name)
    name = name or ""
    if not file.Exists("prisel_cdn", "DATA") then
        file.CreateDir("prisel_cdn")
    end
    
    local url = pathCDN .. name .. ".png"
    
    if installedMat[name] and installedMat[name].Exist then
        return installedMat[name].Material
    else
        local filePath = name .. ".png"
        
        if file.Exists("prisel_cdn/"..filePath, "DATA") then
            installedMat[name] = {
                Exist = true,
                FilePath = filePath,
                Material = Material("../data/prisel_cdn/" .. filePath, "noclamp smooth")
            }
            
            DarkRP.Library.DebugPrint("Loaded material from cache: " .. filePath)
            
            return installedMat[name].Material
        else
            installedMat[name] = {
                Exist = false,
                FilePath = filePath,
                Material = Material("icon16/cross.png", "noclamp smooth")
            }
            
            coroutine.wrap(function()
                http.Fetch(url,
                    function(body, length, headers, code)
                        if code == 200 then
                            local dirPath = string.GetPathFromFilename(filePath)
                            
                            file.CreateDir("prisel_cdn/" .. dirPath)
                            file.Write("prisel_cdn/" .. filePath, body)
                            
                            installedMat[name] = {
                                Exist = true,
                                FilePath = filePath,
                                Material = Material("../data/prisel_cdn/" .. filePath, "noclamp smooth")
                            }
                            
                            DarkRP.Library.DebugPrint("Downloaded and cached material: " .. filePath)
                        end
                    end)
            end)()
            
            return installedMat[name].Material
        end
    end
end

function DarkRP.Library.DrawStencilMask(fcMask, fcRender, bInvert)

    if not isfunction(fcMask) then return false end
    if not isfunction(fcRender) then return false end

    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bInvert and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    fcMask()

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bInvert and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(bInvert and 0 or 1)

    fcRender()

    render.SetStencilEnable(false)
    render.ClearStencil()

end

function DarkRP.Library.ScaleX(iRatio)
    return self.ScrW * (iRatio/1920)
end

function DarkRP.Library.ScaleY(iRatio)
    return self.ScrH * (iRatio/1080)
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:IsOnScreen()
    if not self:IsPlayer() then return false end

    local pos = self:GetPos() + Vector(0, 0, 72)
    local screenPos = pos:ToScreen()

    return screenPos.visible and screenPos.x > 0 and screenPos.x < ScrW() and screenPos.y > 0 and screenPos.y < ScrH() and not util.TraceLine({
        start = LocalPlayer():EyePos(),
        endpos = pos,
        filter = {LocalPlayer(), self}
    }).Hit
end

concommand.Add("getps", function(ply)
    local pos, ang = ply:GetPos(), ply:GetAngles()
    
    print((
        [[{
            ["pos"] = Vector(%s, %s, %s),
            ["ang"] = Angle(%s, %s, %s),
        },]]
    ):format(pos.x, pos.y, pos.z, ang.x, ang.y, ang.z))
end)

concommand.Add("rmvpnl", function(ply)
    if IsValid(g_SpawnMenu) then
        g_SpawnMenu:Hide()
    end

    if IsValid(g_ContextMenu) then
        g_ContextMenu:Hide()
    end

    for k, v in ipairs(vgui.GetWorldPanel():GetChildren()) do
        if not v:IsVisible() then continue end 

        v:Remove()
    end
end)

concommand.Add("printd", function()
    local playerModels = player_manager.AllValidModels()
    local vehiclesList = list.Get("Vehicles")

    PrintTable(playerModels)
    PrintTable(vehiclesList)
end)