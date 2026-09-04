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
    "spice_poop",
    "spice_rage_blood_sugar",
    "spice_soul",
    "spice_voltjelly"
}

for _,v in ipairs(medal) do
    RegisterInventoryItemAtlas("images/"..v..".xml", v..".tex")
end


modimport("main/const.lua")
modimport("main/player.lua")
