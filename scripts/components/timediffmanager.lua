local TimeDifferenceManager = Class(function (self, inst)
    self.inst = inst
    self.netServerTime = net_float(inst.GUID, "serverTime", "serverTimeChanged")
    self.timeDiff = 0

    if TheNet:GetIsServer() then
        self.netServerTime:set(GetTime())

        inst:DoPeriodicTask(1, function ()
            self.netServerTime:set(GetTime())
        end)
    else
        inst:DoTaskInTime(0, function (inst)
            inst:ListenForEvent("serverTimeChanged", function ()
                self.timeDiff = GetTime() - self.netServerTime:value()
            end, inst)
        end)
    end
end)

return TimeDifferenceManager
