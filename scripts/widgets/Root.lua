local Widget = require("widgets/widget")
local Image = require("widgets/image")
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"

local Util = require("Util")

require("fonts")
require("json")

TUNING.BT_LEFT_OFFSET = 150
TUNING.BT_TOP_OFFSET = 200


local IMAGE_SIZE = 50
local MARGIN = 10  --10
local FONT_SIZE = 30
local FONT = NUMBERFONT

-- 拖动偏移的本地持久化键名
local DRAG_POS_SAVE_KEY = "bufftimer_pos"

-- 获取第 i 个 buff 图标的默认锚定坐标(相对屏幕左下角，像素)
local function GetItemBasePosition(i)
    if i <= 10 then
        return TUNING.BT_LEFT_OFFSET + i * (IMAGE_SIZE + MARGIN), TUNING.BT_TOP_OFFSET
    end

    local row = math.floor(i / 10)

    return TUNING.BT_LEFT_OFFSET + (i - 10) * (IMAGE_SIZE + MARGIN), TUNING.BT_TOP_OFFSET + row * 80
end



local Root = Class(Widget, function (self, buffManager, timeDifferenceManager)
    Widget._ctor(self, "Root")

    self.TimeDifferenceManager = timeDifferenceManager
    self.buffs = buffManager:GetBuffs()
    self.listUpdated = true

    -- 右键拖动相关状态
    self.dragOffset = {x = 0, y = 0}
    self.followhandler = nil
    self.m_startpos = nil
    self.o_startpos = nil

    self.root = self:AddChild(Widget("root"))
    self.root:SetVAnchor(ANCHOR_TOP)
    self.root:SetHAnchor(ANCHOR_LEFT)

    self.root.buffs = self.root:AddChild(Widget("buffs"))
    self.root.buffs:SetVAnchor(ANCHOR_TOP)
    self.root.buffs:SetHAnchor(ANCHOR_LEFT)
    self.root.buffs.items = {}

    buffManager:SetOnBuffsChanged(function (buffs)
        self.buffs = buffs
        self.listUpdated = true
    end)

    self:LoadDragOffset()

    self:StartUpdating()
end)

-- 加载本地保存的拖动偏移(异步)
function Root:LoadDragOffset()
    TheSim:GetPersistentString(DRAG_POS_SAVE_KEY, function (success, data)
        if success and data ~= nil and data ~= "" and self.followhandler == nil then
            local ok, pos = pcall(json.decode, data)

            if ok and type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" then
                self:SetDragOffset(pos.x, pos.y)
                self.listUpdated = true
            end
        end
    end)
end

-- 保存拖动偏移到本地
function Root:SaveDragOffset()
    TheSim:SetPersistentString(DRAG_POS_SAVE_KEY, json.encode(self.dragOffset), false)
end

-- 设置拖动偏移(带钳制，保证第一个图标不会被拖出屏幕)
function Root:SetDragOffset(x, y)
    local w, h = TheSim:GetScreenSize()
    local baseX, baseY = GetItemBasePosition(1)

    self.dragOffset.x = math.max(-baseX, math.min(w - baseX, x))
    self.dragOffset.y = math.max(-baseY, math.min(h - baseY, y))
end

-- 开始拖动
function Root:StartDrag()
    if self.followhandler ~= nil then
        return
    end

    self.m_startpos = TheInput:GetScreenPosition()
    self.o_startpos = {x = self.dragOffset.x, y = self.dragOffset.y}

    self.followhandler = TheInput:AddMoveHandler(function (x, y)
        if self.m_startpos ~= nil then
            self:SetDragOffset(
                self.o_startpos.x + (x - self.m_startpos.x),
                self.o_startpos.y + (y - self.m_startpos.y)
            )
            self:ApplyItemPositions()
        end

        -- 焦点可能已丢失(图标被重建等)，靠轮询右键状态兜底结束拖动
        if not Input:IsMouseDown(MOUSEBUTTON_RIGHT) then
            self:EndDrag()
        end
    end)
end

-- 结束拖动
function Root:EndDrag()
    if self.followhandler ~= nil then
        self.followhandler:Remove()
        self.followhandler = nil
    end

    self.m_startpos = nil
    self.o_startpos = nil

    self:SaveDragOffset()
end

-- 按当前偏移直接刷新现有图标位置(拖动中调用，不销毁重建控件，避免焦点丢失)
function Root:ApplyItemPositions()
    Util:ForEach(self.root.buffs.items, function (item, i)
        local x, y = GetItemBasePosition(i)

        item:SetPosition(x + self.dragOffset.x, y + self.dragOffset.y)
    end)
end

function Root:ClearBuffs()
    self.buffs = {}
    self.listUpdated = true
end

function Root:OnUpdate()
    if self.listUpdated then
        Util:KillAllWidgets(self.root.buffs.items)

        self.root.buffs.items = {}

        Util:ForEach(self.buffs, function (buff, i)
            local buffWidget = self.root.buffs:AddChild(Widget( buff.name))

            buffWidget:SetVAnchor(ANCHOR_BOTTOM)
            buffWidget:SetHAnchor(ANCHOR_LEFT)

            local imageTex = buff.image .. ".tex"

            buffWidget.image = buffWidget:AddChild(Image(Util:GetInventoryItemAtlas(imageTex), imageTex))
            buffWidget.image:SetSize(IMAGE_SIZE, IMAGE_SIZE)
            buffWidget.image:SetTooltip("\n\n" .. buff.title .. "\n" .. buff.desc .. "\n\n(右键按住可拖动)")
            buffWidget.timeLeft = buffWidget:AddChild(Text(FONT, FONT_SIZE))
            buffWidget.timeLeft:SetPosition(0, -IMAGE_SIZE)
            buffWidget.timeLeft:SetHAlign(ANCHOR_MIDDLE)


            -- 右键按住图标或倒计时文字可拖动整个 BUFF 栏
            local onControl = function (_, control, down)
                if control == CONTROL_SECONDARY then
                    if down then
                        self:StartDrag()
                    else
                        self:EndDrag()
                    end

                    return true -- 拦截右键，避免同时触发游戏内动作
                end
            end

            buffWidget.OnControl = onControl
            buffWidget.image.OnControl = onControl
            buffWidget.timeLeft.OnControl = onControl


            local x, y = GetItemBasePosition(i)
            buffWidget:SetPosition(x + self.dragOffset.x, y + self.dragOffset.y)


            table.insert(self.root.buffs.items, buffWidget)
        end)
    end

    Util:ForEach(self.buffs, function (buff, i)
        local buffWidget = self.root.buffs.items[i]

        if not buffWidget then
            return
        end

        -- 无定时器的 buff(如棱镜"好事多蘑")不显示倒计时
        if buff.duration == nil then
            return
        end

        local timePassed = GetTime() - buff.startedAt - self.TimeDifferenceManager.timeDiff
        local timeLeft = math.max(0, math.floor(buff.duration - timePassed))
        local minutes = math.floor(timeLeft / 60)
        local seconds = timeLeft % 60

        if minutes < 10 then
            minutes = "0" .. minutes
        end

        if seconds < 10 then
            seconds = "0" .. seconds
        end

        buffWidget.timeLeft:SetString(minutes .. ":" .. seconds)
    end)

    self.listUpdated = false
end

return Root
