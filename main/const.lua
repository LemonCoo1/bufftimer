local seg_time = TUNING.SEG_TIME--一格时间，默认30秒
local day_segs = TUNING.DAY_SEGS_DEFAULT--白天时间，10格，5分钟
local dusk_segs = TUNING.DUSK_SEGS_DEFAULT--傍晚时间，4格，2分钟
local night_segs = TUNING.NIGHT_SEGS_DEFAULT--夜晚时间，2格，1分钟
local total_day_time = TUNING.TOTAL_DAY_TIME--一天时间，16格，8分钟

local day_time = seg_time * day_segs--白天
local dusk_time = seg_time * dusk_segs--傍晚
local night_time = seg_time * night_segs--夜晚


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
        duration = day_time},

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
        duration = day_time},
    -- 曼德拉果酱
    buff_medal_nostiff = {
        name = "buff_medal_nostiff", 
        title = "曼德拉果酱",
        desc = "获得霸体效果",
        image = "spice_mandrake_jam", 
        duration = total_day_time},

        
    -- debuff_panicvolcano = {
    --     name = "debuff_panicvolcano",
    --     image = "dish_sugarlesstrickmakercupcakes"
    -- },

    -- 新奥尔良烤翅
    buff_batdisguise = {
        name = "buff_batdisguise",
        title = "新奥尔良烤翅",
        desc = "不受蝙蝠主动打扰",
        image = "dish_neworleanswings",
        duration = seg_time * 8
        
    },

    -- 药酒
    buff_strengthenhancer = {
        name = "buff_strengthenhancer",
        title = "药酒",
        desc = "提升50%攻击力",
        image = "dish_medicinalliquor",
        duration = total_day_time
        
    },
    -- 香蕉慕斯
    buff_bestappetite = {
        name = "buff_bestappetite",
        title = "香蕉慕斯",
        desc = "获得开胃效果",
        image = "dish_bananamousse",
        duration = seg_time * 2
    },

    -- 果泥香煎鱼
    buff_oilflow = {
        name = "buff_oilflow",
        title = "果泥香煎鱼",
        desc = "获得蹿稀效果",
        image = "dish_friedfishwithpuree",
        duration = total_day_time
    },

    -- 金黄香粽
    buff_hungerretarder = {
        name = "buff_hungerretarder",
        title = "金黄香粽",
        desc = "饥饿度下降变为0.1",
        image = "dish_ricedumpling",
        duration = seg_time * 6
    },

    -- 白菇虾滑卷
    buff_sporeresistance = {
        name = "buff_sporeresistance",
        title = "白菇虾滑卷",
        desc = "获得孢子抵抗力效果",
        image = "dish_wrappedshrimppaste",
        duration = seg_time * 6,
        durationType = "add"
    }
}