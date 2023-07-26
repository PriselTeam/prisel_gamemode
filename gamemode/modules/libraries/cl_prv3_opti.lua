-- Bucket's Optimizations | https://steamcommunity.com/sharedfiles/filedetails/?id=1620875048
function _PRSOpti()
  RunConsoleCommand("gmod_mcore_test", "1")
  RunConsoleCommand("mat_queue_mode", "-1")
  RunConsoleCommand("cl_threaded_bone_setup", "1")
  RunConsoleCommand("cl_threaded_client_leaf_system", "1")
  RunConsoleCommand("r_threaded_client_shadow_manager", "1")
  RunConsoleCommand("r_threaded_particles", "1")
  RunConsoleCommand("r_threaded_renderables", "1")
  RunConsoleCommand("r_queued_ropes", "1")
  RunConsoleCommand("studio_queue_mode", "1")

  hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
  hook.Remove("PostRender", "RenderFrameBlend")
  hook.Remove("PreRender", "PreRenderFrameBlend")
  hook.Remove("Think", "DOFThink")
  hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
  hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
  hook.Remove("PostDrawEffects", "RenderWidgets")
  hook.Remove("Think", "RenderHalos")

  notification.AddLegacy("[Prisel V3] Optimisations chargées", NOTIFY_GENERIC, 5)
end

hook.Add("PostGamemodeLoaded", "PriselV3::PostGMLoaded", _PRSOpti)