
local Util = require("Util")

local BuffManager = Class(function (self, inst)
    self.inst = inst
    self.buffs = {}
    self.netBuffs = net_string(inst.GUID, "buffs", "buffsChanged")
    self.onBuffsChanged = nil

    if TheNet:GetIsServer() then
        inst:ListenForEvent("death", function ()
            self:ClearBuffs()
        end, inst)

        self:SetOnBuffsChanged(function ()
            self.netBuffs:set(json.encode(self.buffs))
        end)
    else
        inst:DoTaskInTime(0, function (inst)
            if ThePlayer.player_classified == inst then
                SendModRPCToServer(GetModRPC("BuffManager", "getBuffs"), inst)

                inst:ListenForEvent("buffsChanged", function ()
                    self:SetBuffsFromNet()
                end, inst)
            end
        end)
    end
end)

function BuffManager:AddBuff(buff)
    local index = self:FindBuffIndex(buff.name)


    if index == 0 then
        table.insert(self.buffs, buff)
    else
        self.buffs[index] = buff
    end

    self:BuffsChanged()
end

function BuffManager:BuffsChanged()
    if self.onBuffsChanged then
        self.onBuffsChanged(self.buffs)
    end
end

function BuffManager:ClearBuffs()
    self.buffs = {}
    self:BuffsChanged()
end

function BuffManager:FindBuffIndex(name)
    return Util:FindIndex(self.buffs, function (buff) return buff.name == name end)
end

function BuffManager:GetBuffs()
    return self.buffs
end

function BuffManager:GetBuff(name)
    local buff = {}
    print(self.buffs)
    if not self.buffs then
        for _, v in pairs(self.buffs) do
            if v.name == name then
                buff = v
            end
        end
    end
    return buff
end

function BuffManager:RemoveBuff(name)
    local index = self:FindBuffIndex(name)

    if index ~= 0 then
        table.remove(self.buffs, index)

        self:BuffsChanged()
    end
end

function BuffManager:SetBuffsFromNet()
    self.buffs = json.decode(self.netBuffs:value())
    self:BuffsChanged()
end

function BuffManager:SetOnBuffsChanged(onBuffsChanged)
    self.onBuffsChanged = onBuffsChanged
end

return BuffManager
