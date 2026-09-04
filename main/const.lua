local seg_time = TUNING.SEG_TIME--一格时间，默认30秒
local day_segs = TUNING.DAY_SEGS_DEFAULT--白天时间，10格，5分钟
local dusk_segs = TUNING.DUSK_SEGS_DEFAULT--傍晚时间，4格，2分钟
local night_segs = TUNING.NIGHT_SEGS_DEFAULT--夜晚时间，2格，1分钟
local total_day_time = TUNING.TOTAL_DAY_TIME--一天时间，16格，8分钟

local day_time = seg_time * day_segs--白天
local dusk_time = seg_time * dusk_segs--傍晚
local night_time = seg_time * night_segs--夜晚


-- 注意：duration 仅为 buff 定时器读取失败时的回退值，
-- 实际倒计时优先取自 buff 自身的 timer(见 main/player.lua)，因此 mod buff 的动态时长(叠加等)也能正确显示
TUNING.BT_BUFFS = {
    -- 电羊果冻
    buff_electricattack = {
        name = "buff_electricattack",
        title = "伏特羊肉冻",
        desc = "获得电击伤害效果",
        image = "voltgoatjelly",
        duration = TUNING.BUFF_ELECTRICATTACK_DURATION
    },
    -- 蓝带鱼排
    buff_moistureimmunity = {
        name = "buff_moistureimmunity",
        title = "蓝带鱼排",
        desc = "保持湿度为0",
        image = "frogfishbowl",
        duration = TUNING.BUFF_MOISTUREIMMUNITY_DURATION
    },
    -- 蘑菇蛋糕
    buff_sleepresistance = {
        name = "buff_sleepresistance",
        title = "蘑菇蛋糕",
        desc = "抵御睡眠",
        image = "shroomcake",
        duration = TUNING.SLEEPRESISTBUFF_TIME
    },
	-- 彩虹糖豆
	healthregenbuff = {
		name = "healthregenbuff",
        title = "彩虹糖豆",
        desc = "持续回复生命",
        image = "jellybean",
        duration = TUNING.JELLYBEAN_DURATION
	},
	-- 舒缓茶
	sweettea_buff = {
		name = "sweettea_buff",
        title = "舒缓茶",
        desc = "持续回复精神",
        image = "sweettea",
        duration = TUNING.SWEETTEA_DURATION
	},
    -- 辣
    buff_attack = {
        name = "buff_attack",
        title = "辣椒面",
        desc = "提升攻击1.2倍",
        image = "spice_chili",
        duration = TUNING.BUFF_ATTACK_DURATION},
    -- 蒜
    buff_playerabsorption = {
        name = "buff_playerabsorption",
        title = "蒜粉",
        desc = "减少1/3伤害",
        image = "spice_garlic",
        duration = TUNING.BUFF_PLAYERABSORPTION_DURATION},
    -- 甜
    buff_workeffectiveness = {
        name = "buff_workeffectiveness",
        title = "蜂蜜水晶",
        desc = "砍树、挖矿效率变为2倍",
        image = "spice_sugar",
        duration = TUNING.BUFF_WORKEFFECTIVENESS_DURATION},

    -- 土豆淀粉
    buff_medal_assuagehunger = {
        name = "buff_medal_assuagehunger",
        title = "土豆淀粉",
        desc = "饱食度下降速度变为0.2倍",
        image = "spice_potato_starch",
        duration = total_day_time
    },
    -- 月树花粉
    buff_medal_sanityregen = {
        name = "buff_medal_sanityregen",
        title = "月树花粉",
        desc = "负面精神影响变为1/5",
        image = "spice_moontree_blossom",
        duration = total_day_time},

    -- 仙人掌花粉
    buff_medal_quicklocomotor = {
        name = "buff_medal_quicklocomotor",
        title = "仙人掌花粉",
        desc = "人物速度提升1.5倍",
        image = "spice_cactus_flower",
        duration = total_day_time},

    -- 血糖
    buff_medal_bloodsucking = {
        name = "buff_medal_bloodsucking",
        title = "血糖",
        desc = "玩家掉血量变为原来的50%",
        image = "spice_blood_sugar",
        duration = day_time},

    -- 黑暗血糖
    buff_medal_suckingblood = {
        name = "buff_medal_suckingblood",
        title = "黑暗血糖",
        desc = "获得吸血效果",
        image = "spice_rage_blood_sugar",
        duration = day_time},

    -- 秘制酱料
    buff_medal_poopfood = {
        name = "buff_medal_poopfood",
        title = "秘制酱料",
        desc = "获得吃屎效果",
        image = "spice_poop",
        duration = day_time},

    -- 叶肉酱
    buff_medal_upappetite = {
        name = "buff_medal_upappetite",
        title = "叶肉酱",
        desc = "获得开胃效果",
        image = "spice_plantmeat",
        duration = total_day_time * 2},
    -- 曼德拉果酱
    buff_medal_nostiff = {
        name = "buff_medal_nostiff",
        title = "曼德拉果酱",
        desc = "获得霸体效果",
        image = "spice_mandrake_jam",
        duration = total_day_time},

    -- 山力叶酱
    buff_medal_strong = {
        name = "buff_medal_strong",
        title = "山力叶酱",
        desc = "搬运重物不减速",
        image = "spice_pomegranate",
        duration = total_day_time},

    -- 棱镜 7.x 版本起 buff 预制物统一以 buff_l_ 为前缀
    -- 药酒
    buff_l_strengthenhancer = {
        name = "buff_l_strengthenhancer",
        title = "药酒",
        desc = "普通攻击力提升50%",
        image = "dish_medicinalliquor",
        duration = total_day_time
    },
    -- 香蕉慕斯
    buff_l_bestappetite = {
        name = "buff_l_bestappetite",
        title = "香蕉慕斯",
        desc = "获得开胃效果",
        image = "dish_bananamousse",
        duration = total_day_time
    },
    -- 果泥香煎鱼
    buff_l_oilflow = {
        name = "buff_l_oilflow",
        title = "果泥香煎鱼",
        desc = "获得蹿稀效果",
        image = "dish_friedfishwithpuree",
        duration = seg_time * 3
    },
    -- 金黄香粽
    buff_l_hungerretarder = {
        name = "buff_l_hungerretarder",
        title = "金黄香粽",
        desc = "饱食度下降速度变为0.1倍",
        image = "dish_ricedumpling",
        duration = day_time
    },
    -- 憋住(金黄香粽)
    buff_l_holdbackpoop = {
        name = "buff_l_holdbackpoop",
        title = "憋住",
        desc = "憋住粑粑，结束时一次性释放",
        image = "dish_ricedumpling",
        duration = total_day_time * 5
    },
    -- 白菇虾滑卷
    buff_l_sporeresistance = {
        name = "buff_l_sporeresistance",
        title = "白菇虾滑卷",
        desc = "受到的伤害减少25%",
        image = "dish_wrappedshrimppaste",
        duration = seg_time * 24
    },
    -- 月饼/花儿粑
    buff_l_planardefense = {
        name = "buff_l_planardefense",
        title = "位面稳固",
        desc = "提升位面防御",
        image = "dish_l_mooncake",
        duration = seg_time * 12
    },
    -- 月饼/花儿粑
    buff_l_lunarresist = {
        name = "buff_l_lunarresist",
        title = "月光防御",
        desc = "减免月亮阵营伤害",
        image = "dish_l_flowerbun",
        duration = seg_time * 12
    },
    -- 月酿/花儿酒
    buff_l_planarattack = {
        name = "buff_l_planarattack",
        title = "位面激进",
        desc = "提升位面攻击",
        image = "dish_l_moonwine",
        duration = seg_time * 12
    },
    -- 月酿/花儿酒
    buff_l_dissipateshadow = {
        name = "buff_l_dissipateshadow",
        title = "破影",
        desc = "对暗影阵营敌人增伤",
        image = "dish_l_flowerdop",
        duration = seg_time * 12
    },
    -- 真果拿破仑
    buff_l_radiantskin = {
        name = "buff_l_radiantskin",
        title = "闪亮皮肤",
        desc = "自身发光",
        image = "dish_l_fleshnapoleon",
        duration = total_day_time
    },
    -- 飞福果煎/飞腿咖喱
    buff_l_moveup = {
        name = "buff_l_moveup",
        title = "轻盈脚步",
        desc = "移动速度提升",
        image = "dish_l_fruitglazedmeat",
        duration = seg_time * 20
    },
    -- 倾心玫瑰酥
    buff_l_love = {
        name = "buff_l_love",
        title = "心之爱",
        desc = "生命上限提升15%",
        image = "dish_l_lovingrose",
        duration = seg_time * 12
    },
    -- 清豆粥
    buff_l_cool = {
        name = "buff_l_cool",
        title = "凉爽",
        desc = "降低体温，防止过热",
        image = "dish_l_beancongee",
        duration = seg_time * 12
    },
    -- 双菇烩蛋/菌鱼双鲜堡(无定时器，不显示倒计时)
    buff_l_effortluck = {
        name = "buff_l_effortluck",
        title = "好事多蘑",
        desc = "提升运气，吃料理可叠加层数",
        image = "dish_l_mushedeggs"
    }
}
