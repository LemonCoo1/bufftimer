local Root = require("widgets/Root")

local Util = require("Util")

require("json")

AddClassPostConstruct("widgets/controls", function (controls)
    controls.inst:DoTaskInTime(0, function ()
        controls.buffTimer = controls.top_root:AddChild(Root(
            GLOBAL.ThePlayer.player_classified.components.buffmanager,
            GLOBAL.ThePlayer.player_classified.components.timediffmanager
        ))
    end)
end)

for k, v in pairs(TUNING.BT_BUFFS) do
    local onAttachBuff = function (inst, target)
        local player_classified = target.player_classified

        if not player_classified then
            return
        end

        local buff = shallowcopy(v)
        buff.startedAt = GetTime()

        -- 优先读取 buff 自身定时器的实际剩余时长，兼容各 mod 的动态时长(叠加、自定义参数等)
        -- 无定时器的 buff(如棱镜"好事多蘑")不显示倒计时
        if inst.components.timer ~= nil then
            local timeLeft = inst.components.timer:GetTimeLeft("buffover")

            if timeLeft ~= nil and timeLeft > 0 then
                buff.duration = timeLeft
            end
        end

        -- 棱镜叠层 buff(位面防御/位面攻击)：读取 buff 实体上实际生效的数值字段 _count_l
        -- (服务端独占字段，随 buffs 表一并同步到客户端用于悬浮显示)
        if v.countLabel ~= nil and inst._count_l ~= nil and inst._count_l > 0 then
            buff.count = inst._count_l
        end

        -- 图标动态还原为最后吃的那道料理(如棱镜"好胃口"：香蕉慕斯/香蕉冻/香蕉汁等都会附加)
        if v.lastEatenFoodImage and player_classified.bufftimer_lasteatenfood ~= nil then
            buff.image = player_classified.bufftimer_lasteatenfood
        end

        player_classified.components.buffmanager:AddBuff(buff)
    end

    local onDetachBuff = function (inst, target)
        local player_classified = target.player_classified

        if not player_classified then
            return
        end

        player_classified.components.buffmanager:RemoveBuff(k)
    end

    AddPrefabPostInit(k, function (inst)
        local onattachedfn = inst.components.debuff.onattachedfn
        local onextendedfn = inst.components.debuff.onextendedfn
        local ondetachedfn = inst.components.debuff.ondetachedfn

        inst.components.debuff:SetAttachedFn(function (inst, target, ...)
            onattachedfn(inst, target, ...)
            onAttachBuff(inst, target)
        end)

        inst.components.debuff:SetExtendedFn(function (inst, target, ...)
            onextendedfn(inst, target, ...)
            onAttachBuff(inst, target)
        end)

        inst.components.debuff:SetDetachedFn(function (inst, target, ...)
            ondetachedfn(inst, target, ...)
            onDetachBuff(inst, target)
        end)
    end)
end

-- 大厨沃利专属菜效果计时（非 buff 实体）：这些菜的效果不是游戏内的 buff 实体(无 debuff 组件)，
-- 改为在服务端钩住底层状态组件，倒计时经 buffmanager 的 netBuffs 同步到客户端：
--   热龙椒沙拉/芦笋冷汤 → 肚内体温(temperature:SetTemperatureInBelly)
--   发光浆果慕斯        → wormlight 发光 spell
-- 调料变体(spice_*)会继承原菜的体温/发光字段(见原版 spicedfoods.lua GenerateSpicedFoods)，自动被捕获

-- 体温伪buff：BT_FOOD_EFFECTS 中带 tempDuration(特定长时菜) 或 isGenericTemp(通用保/降温) 的条目
local TEMP_BUFF_KEYS = {}

for key, def in pairs(TUNING.BT_FOOD_EFFECTS) do
    if def.tempDuration ~= nil or def.isGenericTemp then
        table.insert(TEMP_BUFF_KEYS, key)
    end
end

-- 取消并清理某个体温伪buff的倒计时任务与图标
local function RemoveTempBuff(buffmanager, tasks, key)
    if tasks[key] ~= nil then
        tasks[key]:Cancel()
        tasks[key] = nil
    end

    buffmanager:RemoveBuff(key)
end

-- 按升温/降温方向匹配已单独登记的"长时体温菜"(沃利专属菜、香脆松子的绿豆汤/红薯糖水)，
-- 命中则用具体图标，否则回退到通用的"保温/降温"(能力勋章同款通用方式)
local function MatchSpecificTempBuff(duration, hot)
    for key, def in pairs(TUNING.BT_FOOD_EFFECTS) do
        if def.tempDuration ~= nil and def.tempHot == hot and duration == def.tempDuration then
            return key
        end
    end
    return nil
end

-- 记录最近一次"能改变肚内体温"的料理图片：兜底显示通用"保温/降温"时，图标还原为最后吃的那道料理。
-- 肚内体温效果正是在 edible:OnEaten 内同步调用 SetTemperatureInBelly，因此在调用原版前先记到玩家身上，
-- 温度钩子随后读取即可保证取到的是"本次食用"的料理。调料变体(spice_*)会生成独立 prefab，各自图片也能正常解析。
AddComponentPostInit("edible", function (self)
    local oldOnEaten = self.OnEaten

    self.OnEaten = function (self, eater, data)
        if self.temperaturedelta ~= nil and self.temperaturedelta ~= 0
            and eater ~= nil and eater.player_classified ~= nil then
            eater.player_classified.bufftimer_lasttempfood = self.inst.prefab
        end

        if oldOnEaten then
            return oldOnEaten(self, eater, data)
        end
    end
end)

-- 记录最近一次吃的料理(供 foodbuff 图标动态还原，如棱镜"好胃口")。
-- 注意必须钩在 eater:Eat 的**入口**(早于 edible:OnEaten)：棱镜的料理附加 buff(如香蕉料理"好胃口")
-- 走的是 eater 推动的 "oneat" 事件(原版 eater.lua 在 edible:OnEaten **之前**触发)，
-- 若在 edible:OnEaten 里记录就会晚一拍，导致"第一次吃不变、第二次才变"。这里在入口记录可保证
-- 无论 buff 由 oneat 事件还是 oneatenfn 触发，图标都能取到"本次食用"的料理。
AddComponentPostInit("eater", function (self)
    local oldEat = self.Eat

    self.Eat = function (self, food, ...)
        if food ~= nil and self.inst ~= nil and self.inst.player_classified ~= nil then
            self.inst.player_classified.bufftimer_lasteatenfood = food.food_basename or food.prefab
        end

        if oldEat then
            return oldEat(self, food, ...)
        end
    end
end)

-- 体温效果(能力勋章 medal 同款通用方式)：任何食物的肚内体温效果最终都会走到
-- temperature:SetTemperatureInBelly(见原版 temperature.lua)，并把状态写在
-- bellytemperaturedelta(升/降温)与 bellytime(绝对结束时刻)上。
-- 因此无需按食物逐个登记，升/降温的所有食物(含调料变体与其他mod料理)都会被覆盖，
-- 剩余时间直接取自 bellytime，倒计时始终与实际一致。普通食物(辣椒/冰激凌等短时温性)
-- 也会走同一条路径按剩余时间显示，避免遗漏。
AddComponentPostInit("temperature", function (self)
    local oldSetTemperatureInBelly = self.SetTemperatureInBelly

    self.SetTemperatureInBelly = function (self, delta, duration)
        if oldSetTemperatureInBelly then
            oldSetTemperatureInBelly(self, delta, duration)
        end

        local inst = self.inst
        local player_classified = inst ~= nil and inst.player_classified or nil

        if player_classified == nil or not TheWorld.ismastersim then
            return
        end

        local temp = inst.components.temperature
        local bellyDelta = temp ~= nil and temp.bellytemperaturedelta or nil

        -- 无肚内体温效果(尚未设置或已结束)则不显示
        if bellyDelta == nil or bellyDelta == 0 then
            return
        end

        local remaining = temp.bellytime ~= nil and (temp.bellytime - GetTime()) or nil
        if remaining == nil or remaining <= 0 then
            return
        end

        if player_classified.bufftimer_removetasks == nil then
            player_classified.bufftimer_removetasks = {}
        end

        local buffmanager = player_classified.components.buffmanager
        local tasks = player_classified.bufftimer_removetasks

        -- 肚内体温状态每次都会被整体替换(重复吃/换吃/普通食物覆盖)，先清掉旧任务与图标
        for _, key in ipairs(TEMP_BUFF_KEYS) do
            RemoveTempBuff(buffmanager, tasks, key)
        end

        -- 命中已登记的菜用具体图标，否则用通用"保温/降温"
        local buffKey
        if bellyDelta > 0 then
            buffKey = MatchSpecificTempBuff(duration, true) or "bt_temp_warm"
        else
            buffKey = MatchSpecificTempBuff(duration, false) or "bt_temp_cool"
        end

        local buffDef = TUNING.BT_FOOD_EFFECTS[buffKey]

        if buffDef == nil then
            return
        end

        local buff = shallowcopy(buffDef)

        -- 通用"保温/降温"恢复为最后吃的那道料理图片；命中具体菜时"最后吃"即该菜，图片也一致
        if player_classified.bufftimer_lasttempfood ~= nil then
            buff.image = player_classified.bufftimer_lasttempfood
        end

        buff.duration = remaining
        buff.startedAt = GetTime()
        buffmanager:AddBuff(buff)

        tasks[buffKey] = player_classified:DoTaskInTime(remaining, function ()
            RemoveTempBuff(buffmanager, tasks, buffKey)
        end)
    end
end)

-- 棱镜清豆粥(dish_l_beancongee)：首个依赖食物内部状态、无法通过 debuff 实体监听捕捉的效果。
-- 其 oneatenfn(见棱镜 preparedfoods_legion.lua)只做一件"一次性即时降温"BeCool(直接 SetTemperature 当前体温-35)，
-- 且仅在玩家已持有"凉爽"debuff(如泡温泉获得)时才 AddDebuff 续时长，因此首次吃清豆粥不会挂载 buff_l_cool 实体，
-- BT_BUFFS 的实体 attach 监听收不到事件，图标/计时无法显示。
-- 这里在服务端补 oneaten 监听，按配置时长补上"凉爽"图标；若真实 buff_l_cool 实体已在(温泉)，则仍交给实体监听路径，
-- 避免覆盖真实剩余时长。清豆粥的调料变体会各自生成独立 prefab(见棱镜 preparedfoods_legion_spiced.lua)，一并登记。
local function AddCoolOneatenHook(prefabName)
    AddPrefabPostInit(prefabName, function (inst)
        inst:ListenForEvent("oneaten", function (inst, data)
            if not TheWorld.ismastersim or data == nil then
                return
            end

            local eater = data.eater
            local player_classified = eater ~= nil and eater.player_classified or nil

            if player_classified == nil then
                return
            end

            -- 真实 debuff 已存在(泡温泉获得/续杯)，由 BT_BUFFS 的 attach/extend 实体监听负责显示与续期
            if eater:HasDebuff("buff_l_cool") then
                return
            end

            local buffDef = TUNING.BT_BUFFS.buff_l_cool

            if buffDef == nil then
                return
            end

            if player_classified.bufftimer_removetasks == nil then
                player_classified.bufftimer_removetasks = {}
            end

            local buffmanager = player_classified.components.buffmanager
            local tasks = player_classified.bufftimer_removetasks
            local key = "buff_l_cool"

            -- 连续吃清豆粥刷新倒计时(不叠加，与游戏内"一次性降温"一致)
            if tasks[key] ~= nil then
                tasks[key]:Cancel()
            end

            local buff = shallowcopy(buffDef)
            buff.startedAt = GetTime()
            buffmanager:AddBuff(buff)

            tasks[key] = player_classified:DoTaskInTime(buffDef.duration, function ()
                tasks[key] = nil
                buffmanager:RemoveBuff(key)
            end)
        end)
    end)
end

AddCoolOneatenHook("dish_l_beancongee")
AddCoolOneatenHook("dish_l_beancongee_spice_garlic")
AddCoolOneatenHook("dish_l_beancongee_spice_sugar")
AddCoolOneatenHook("dish_l_beancongee_spice_chili")
AddCoolOneatenHook("dish_l_beancongee_spice_salt")

-- 发光效果：发光浆果慕斯会在玩家身上生成 wormlight_light_greater spell(见 preparedfoods_warly.lua)，
-- 该 prefab 目前只有发光浆果慕斯能产生，可唯一对应(普通发光浆果生成的是 wormlight_light/lesser，不受影响)。
-- 重复吃慕斯时原版会把 spell.lifetime 清零并 ResumeSpell(不经过 OnStart)，故一并钩住 ResumeSpell 刷新倒计时；
-- 读档恢复的 spell 也走 ResumeSpell，统一用 spell 自身剩余时长(duration - lifetime)保证倒计时准确
AddComponentPostInit("spell", function (self)
    local function IsMousseGlow(self)
        return self.spellname == "wormlight"
            and self.inst ~= nil and self.inst.prefab == "wormlight_light_greater"
            and self.target ~= nil and self.target.player_classified ~= nil
    end

    local function AddGlowBuff(self)
        local buffDef = TUNING.BT_FOOD_EFFECTS.glowberrymousse

        if buffDef == nil then
            return
        end

        local player_classified = self.target.player_classified
        local buff = shallowcopy(buffDef)

        buff.duration = self.duration - self.lifetime
        buff.startedAt = GetTime()
        player_classified.components.buffmanager:AddBuff(buff)
    end

    local oldOnStart = self.OnStart

    self.OnStart = function (self, ...)
        if oldOnStart then
            oldOnStart(self, ...)
        end

        if IsMousseGlow(self) and TheWorld.ismastersim then
            AddGlowBuff(self)
        end
    end

    local oldOnFinish = self.OnFinish

    self.OnFinish = function (self, ...)
        if oldOnFinish then
            oldOnFinish(self, ...)
        end

        if IsMousseGlow(self) and TheWorld.ismastersim then
            self.target.player_classified.components.buffmanager:RemoveBuff("glowberrymousse")
        end
    end

    local oldResumeSpell = self.ResumeSpell

    self.ResumeSpell = function (self, ...)
        if oldResumeSpell then
            oldResumeSpell(self, ...)
        end

        if IsMousseGlow(self) and TheWorld.ismastersim then
            AddGlowBuff(self)
        end
    end
end)

AddModRPCHandler("buffmanager", "getBuffs", function (player, inst)
    if inst.components.buffmanager then
        local buffmanager = inst.components.buffmanager

        -- " " because json could already be the same and nothing would be updated
        buffmanager.netBuffs:set(GLOBAL.json.encode(buffmanager.buffs) .. " ")
    end
end)

AddPrefabPostInit("player_classified", function (inst)
    inst:AddComponent("buffmanager")
    inst:AddComponent("timediffmanager")
end)
