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
