if BSHADOWS == nil then
    BSHADOWS = {}

    BSHADOWS.RenderTarget = GetRenderTarget("bshadows_original", DarkRP.ScrW, DarkRP.ScrH)
    BSHADOWS.RenderTarget2 = GetRenderTarget("bshadows_shadow",  DarkRP.ScrW, DarkRP.ScrH)

    BSHADOWS.ShadowMaterial = CreateMaterial("bshadows", "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["alpha"] = 1
    })

    BSHADOWS.ShadowMaterialGrayscale = CreateMaterial("bshadows_grayscale", "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$alpha"] = 1,
        ["$color"] = "0 0 0",
        ["$color2"] = "0 0 0"
    })

    BSHADOWS.BeginShadow = function()
        render_PushRenderTarget(BSHADOWS.RenderTarget)
        render.OverrideAlphaWriteEnable(true, true)
        render.Clear(0, 0, 0, 0)
        render.OverrideAlphaWriteEnable(false, false)
        cam.Start2D()
    end

    local function BlurRenderTarget(renderTarget, spread, blur)
        if blur > 0 then
            render.OverrideAlphaWriteEnable(true, true)
            render_BlurRenderTarget(renderTarget, spread, spread, blur)
            render.OverrideAlphaWriteEnable(false, false)
        end
    end

    BSHADOWS.EndShadow = function(intensity, spread, blur, opacity, direction, distance, _shadowOnly)
        opacity = opacity or 255
        direction = direction or 0
        distance = distance or 0
        _shadowOnly = _shadowOnly or false

        render.CopyRenderTargetToTexture(BSHADOWS.RenderTarget2)
        BlurRenderTarget(BSHADOWS.RenderTarget2, spread, blur)
        render_PopRenderTarget()

        local xOffset = math_sin(math_rad(direction)) * distance
        local yOffset = math_cos(math_rad(direction)) * distance

        BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255)
        render_SetMaterial(BSHADOWS.ShadowMaterialGrayscale)
        for i = 1, math_ceil(intensity) do
            render_DrawScreenQuadEx(xOffset, yOffset, DarkRP.ScrW, DarkRP.ScrH)
        end

        if not _shadowOnly then
            BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTarget)
            render_SetMaterial(BSHADOWS.ShadowMaterial)
            render_DrawScreenQuad()
            print("Drew Shadow")
        end

        cam.End2D()
    end

    BSHADOWS.DrawShadowTexture = function(texture, intensity, spread, blur, opacity, direction, distance, shadowOnly)
        opacity = opacity or 255
        direction = direction or 0
        distance = distance or 0
        shadowOnly = shadowOnly or false

        render.CopyTexture(texture, BSHADOWS.RenderTarget2)
        BlurRenderTarget(BSHADOWS.RenderTarget2, spread, blur)

        local xOffset = math_sin(math_rad(direction)) * distance
        local yOffset = math_cos(math_rad(direction)) * distance

        BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity / 255)
        render_SetMaterial(BSHADOWS.ShadowMaterialGrayscale)
        for i = 1, math_ceil(intensity) do
            render_DrawScreenQuadEx(xOffset, yOffset, DarkRP.ScrW, DarkRP.ScrH)
        end

        if not shadowOnly then
            BSHADOWS.ShadowMaterial:SetTexture('$basetexture', texture)
            render_SetMaterial(BSHADOWS.ShadowMaterial)
            render_DrawScreenQuad()
        end
    end
end
