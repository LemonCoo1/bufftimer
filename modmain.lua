GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})



-- 把别的mod没注册的贴图注册一下
-- 勋章贴图
local medal = {
    "spice_potato_starch",
    "spice_blood_sugar",
    "spice_cactus_flower",
    "spice_jelly",
    "spice_mandrake_jam",
    "spice_moontree_blossom",
    "spice_phosphor",
    "spice_plantmeat",
    "spice_pomegranate",
    "spice_poop",
    "spice_rage_blood_sugar",
    "spice_soul",
    "spice_voltjelly"
}

for _,v in ipairs(medal) do
    RegisterInventoryItemAtlas("images/"..v..".xml", v..".tex")
end

-- 能力勋章道具贴图(瓶装月光/瓶装灵魂、羊角帽、本源精华、凋零蜂王浆等)
local medal_items = {
    "bottled_moonlight",
    "bottled_soul",
    "medal_goathat",
    "medal_origin_essence",
    "medal_withered_royaljelly",
    "spice_withered_royal_jelly"
}

for _,v in ipairs(medal_items) do
    RegisterInventoryItemAtlas("images/"..v..".xml", v..".tex")
end

-- 原版调料贴图(位于原版合并图集 inventoryimages3 中，未注册时无法通过 GetInventoryItemAtlas 解析)
local vanilla_spice = {
    "spice_chili",
    "spice_garlic",
    "spice_sugar"
}

for _, v in ipairs(vanilla_spice) do
    RegisterInventoryItemAtlas("images/inventoryimages3.xml", v .. ".tex")
end

-- 原版火荨麻(火荨麻毒素)贴图(位于原版合并图集 inventoryimages2 中)
local vanilla_extra = {
    "firenettles"
}

for _, v in ipairs(vanilla_extra) do
    RegisterInventoryItemAtlas("images/inventoryimages2.xml", v .. ".tex")
end

-- 棱镜料理贴图
local legion = {
    "dish_medicinalliquor",
    "dish_bananamousse",
    "dish_friedfishwithpuree",
    "dish_ricedumpling",
    "dish_wrappedshrimppaste",
    "dish_l_mooncake",
    "dish_l_flowerbun",
    "dish_l_moonwine",
    "dish_l_flowerdop",
    "dish_l_fleshnapoleon",
    "dish_l_fruitglazedmeat",
    "dish_l_chilledcurry",
    "dish_l_lovingrose",
    "dish_l_beancongee",
    "dish_l_mushedeggs"
}

for _,v in ipairs(legion) do
    RegisterInventoryItemAtlas("images/inventoryimages/"..v..".xml", v..".tex")
end


modimport("main/const.lua")
modimport("main/player.lua")
