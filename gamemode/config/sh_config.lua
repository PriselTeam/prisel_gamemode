/*
 * -------------------------
 * • Fichier: sh_config.lua
 * • Projet: config
 * • Création : Sunday, 9th July 2023 4:51:54 pm
 * • Auteur : Ekali
 * • Modification : Monday, 10th July 2023 9:51:23 pm
 * • Destiné à Prisel.fr en V3
 * -------------------------
 */
DarkRP = DarkRP or {}
DarkRP.Config = DarkRP.Config or {}

DarkRP.Config.DebugMode = false

DarkRP.Config.StaffGroups = {
  ["superadmin"] = true,
  ["admin"] = true,
  ["mod"] = true,
  ["modtest"] = true,
  ["helper"] = true
}

DarkRP.Config.VIPGroups = {
  ["vip"] = true,
  ["vip+"] = true,
  ["premium"] = true,
  ["gperso"] = true
}

DarkRP.Config.DiscordURL = "https://discord.gg/prisel"
DarkRP.Config.CollectionURL = "https://steamcommunity.com/sharedfiles/filedetails/?id=2979688288"
DarkRP.Config.BoutiqueURL = "https://prisel.fr/boutique"

DarkRP.Config.RoundedBoxValue = 5
DarkRP.Config.OutlineThick = 3

DarkRP.Config.Colors = {
  ["Invisible"] = Color(0,0,0,0),
  ["Main"] = Color(44, 47, 54),          -- Couleur principale (Main)
  ["Secondary"] = Color(33, 37, 41),     -- Couleur secondaire (Secondary)
  ["GBlue"] = Color(58, 72, 119),        -- Couleur bleu-vert (GBlue)
  ["DGreen"] = Color(33, 59, 76),        -- Couleur verte foncée (DGreen)
  ["Grey"] = Color(50, 55, 61),          -- Couleur grise (Grey)
  ["Blue"] = Color(41, 154, 216),        -- Couleur bleue (Blue)
  ["Green"] = Color(10, 179, 156),       -- Couleur verte (Green)
  ["Red"] = Color(246, 79, 100),          -- Couleur rouge (Red)
  ["Yellow"] = Color(225, 232, 40),
  ["Outline"] = Color(33, 37, 41)
}
