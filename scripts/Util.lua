local inspect = require("inspect")

require("strings")
require("stringutil")

local DEBUG_MODE = true

-- DEBUG_MODE = false

return {
    Inspect = function (self, value)
        return inspect(value)
    end,

    Log = function (self, ...)
        if DEBUG_MODE then
            print("[Buff Timer (server)]:", ...)
        end
    end,

    EndsWith = function (self, str, ending)
        return ending == "" or str:sub(-#ending) == ending
    end,

    FindIndex = function (self, array, cb)
        for i, v in ipairs(array) do
            if cb(v, i, array) then
                return i
            end
        end

        return 0
    end,

    ForEach = function (self, array, cb)
        for i, v in ipairs(array) do
            cb(v, i)
        end
    end,

    KillAllWidgets = function (self, widgets)
        self:ForEach(widgets, function (widget) widget:Kill() end)
    end,

    GetInventoryItemAtlas = function (self, itemTex)
        return GetInventoryItemAtlas(itemTex)
    end,

    GetHUDAtlas = function ()
        return resolvefilepath("images/hud.xml")
    end,
}
