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

local TEMP_BUFF_KEYS = { "dragonchilisalad", "gazpacho" }

-- 取消并清理某个体温伪buff的倒计时任务与图标
local function RemoveTempBuff(buffmanager, tasks, key)
    if tasks[key] ~= nil then
        tasks[key]:Cancel()
        tasks[key] = nil
    end

    buffmanager:RemoveBuff(key)
end

-- 体温效果：任何食物的体温效果最终都会调用 SetTemperatureInBelly(见原版 edible.lua:OnEaten)，
-- 因此无需按食物逐个登记，调料变体也会自动覆盖。
-- 用时长区分"沃利专属菜级"的长效体温(5分钟)与普通温性食物(辣椒/冰激凌等 5~15 秒)：
-- 普通食物会整体替换肚内体温状态，此时移除已显示的图标，避免与实际效果不一致
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

        local buffKey = nil

        if duration == TUNING.BUFF_FOOD_TEMP_DURATION then
            if delta > 0 then
                buffKey = "dragonchilisalad"
            elseif delta < 0 then
                buffKey = "gazpacho"
            end
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

        if buffKey == nil then
            return
        end

        local buffDef = TUNING.BT_FOOD_EFFECTS[buffKey]

        if buffDef == nil then
            return
        end

        local buff = shallowcopy(buffDef)
        buff.duration = duration
        buff.startedAt = GetTime()
        buffmanager:AddBuff(buff)

        tasks[buffKey] = player_classified:DoTaskInTime(duration, function ()
            RemoveTempBuff(buffmanager, tasks, buffKey)
        end)
    end
end)

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
