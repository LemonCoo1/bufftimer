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

    -- 棱镜 7.x 起会把原版调料buff重定向为 buff_l_ 前缀(见棱镜 postinit_legion 的 fixedbuffs 表)
    -- 辣(辣椒粉)->buff_l_attack、蒜(蒜粉)->buff_l_defense、甜(甜粉)->buff_l_workup
    buff_l_attack = {
        name = "buff_l_attack",
        title = "辣椒面",
        desc = "提升攻击1.2倍",
        image = "spice_chili",
        duration = TUNING.BUFF_ATTACK_DURATION},
    -- 蒜
    buff_l_defense = {
        name = "buff_l_defense",
        title = "蒜粉",
        desc = "减少1/3伤害",
        image = "spice_garlic",
        duration = TUNING.BUFF_PLAYERABSORPTION_DURATION},
    -- 甜
    buff_l_workup = {
        name = "buff_l_workup",
        title = "蜂蜜水晶",
        desc = "砍树、挖矿效率变为2倍",
        image = "spice_sugar",
        duration = TUNING.BUFF_WORKEFFECTIVENESS_DURATION},

    -- 火荨麻毒素
    firenettle_toxin = {
        name = "firenettle_toxin",
        title = "火荨麻毒素",
        desc = "体温急速升高，且会不断胡言乱语",
        image = "firenettles",
        duration = seg_time * 2
    },

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

    -- 能力勋章：羊角帽 蓄电(电羊)
    buff_medal_electricattack = {
        name = "buff_medal_electricattack",
        title = "蓄电(电羊)",
        desc = "攻击附带电击伤害",
        image = "medal_goathat",
        duration = day_time
    },
    -- 能力勋章：瓶装灵魂
    buff_medal_freeblink = {
        name = "buff_medal_freeblink",
        title = "灵魂跳跃",
        desc = "获得灵魂跳跃能力",
        image = "bottled_soul",
        duration = day_time
    },
    -- 能力勋章：瓶装月光(月光移植)
    buff_medal_transplantable = {
        name = "buff_medal_transplantable",
        title = "月光BUFF",
        desc = "获得月光移植能力",
        image = "bottled_moonlight",
        duration = night_time + dusk_time
    },
    -- 能力勋章：本源能量
    buff_medal_origin_energy = {
        name = "buff_medal_origin_energy",
        title = "本源能量",
        desc = "本源之力，施法时消耗",
        image = "medal_origin_essence",
        duration = total_day_time
    },
    -- 能力勋章：凋零蜂王浆酱(凋零吸血)
    buff_medal_withered_health = {
        name = "buff_medal_withered_health",
        title = "凋零吸血",
        desc = "攻击时吸取敌人生命",
        image = "medal_withered_royaljelly",
        duration = day_time
    },
    -- 能力勋章：群伤(暂未启用)
    buff_medal_aoecombat = {
        name = "buff_medal_aoecombat",
        title = "群伤",
        desc = "攻击附加范围伤害",
        image = "spice_withered_royal_jelly",
        duration = day_time
    },

    -- 棱镜 7.x 版本起 buff 预制物统一以 buff_l_ 为前缀
    -- 药酒
    buff_l_strengthenhancer = {
        name = "buff_l_strengthenhancer",
        title = "药酒",
        desc = "普通攻击力提升50%",
        image = "dish_medicinalliquor",
        duration = total_day_time
    },
    -- 好胃口(香蕉慕斯/香蕉冻/香蕉汁等原版+棱镜香蕉料理都会附加；图标动态还原为最后吃的那道料理)
    buff_l_bestappetite = {
        name = "buff_l_bestappetite",
        title = "好胃口",
        desc = "能吃不喜欢的食物",
        image = "dish_bananamousse",
        duration = total_day_time,
        lastEatenFoodImage = true
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
    -- countLabel: 棱镜叠层 buff 的数值字段(位面防御实际加成，取最高吃过的那档: 月饼15/花儿粑5)
    buff_l_planardefense = {
        name = "buff_l_planardefense",
        title = "位面稳固",
        desc = "提升位面防御",
        image = "dish_l_mooncake",
        duration = seg_time * 12,
        countLabel = "位面防御"
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
    -- countLabel: 棱镜叠层 buff 的数值字段(位面攻击实际加成，取最高喝过的那档: 月酿25/花儿酒10)
    buff_l_planarattack = {
        name = "buff_l_planarattack",
        title = "位面激进",
        desc = "提升位面攻击",
        image = "dish_l_moonwine",
        duration = seg_time * 12,
        countLabel = "位面攻击"
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
    -- countLabel: 棱镜叠层 buff 的层数(吃料理 +1 层，上限20)，随叠加实时刷新
    buff_l_effortluck = {
        name = "buff_l_effortluck",
        title = "好事多蘑",
        desc = "提升运气，吃料理可叠加层数",
        image = "dish_l_mushedeggs",
        countLabel = "运气层数"
    },

    -- 香脆松子(CrispyNuts)料理buff (buff 实体均带 debuff/timer，自动监听显示倒计时)
    -- 仅登记正向增益；负面 debuff(如"超级香甜粘玉米"扣血/无法进食)不纳入
    -- 加速(中)(松子咖啡/冰咖啡)
    nutsbuff_speed = {
        name = "nutsbuff_speed",
        title = "加速(中)",
        desc = "移动速度提升20%",
        image = "nuts_coffe",
        duration = 4 * 60
    },
    -- 加速(大)(松子拿铁/莓果拿铁/黄油拿铁/香蕉拿铁等，动态时长以实际 buff 为准)
    nutsbuff_speed2 = {
        name = "nutsbuff_speed2",
        title = "加速(大)",
        desc = "移动速度提升50%",
        image = "nuts_latte",
        duration = 6 * 60
    },
    -- 加速(小)(咖啡粉调味后进食触发)
    nutsbuff_speed3 = {
        name = "nutsbuff_speed3",
        title = "加速(小)",
        desc = "移动速度提升10%",
        image = "spice_tf_coffee_powder",
        duration = 4 * 60
    },
    -- 松萝蛋糕卷
    nutsbuff_work = {
        name = "nutsbuff_work",
        title = "松萝蛋糕卷",
        desc = "砍树、挖矿、敲击效率提升(2倍)",
        image = "nuts_pinecake",
        duration = 4 * 60
    },
    -- 咖啡布丁
    nutsbuff_strength = {
        name = "nutsbuff_strength",
        title = "咖啡布丁",
        desc = "提升10%攻击力",
        image = "nuts_pudding",
        duration = 8 * 60
    },
    -- 香蕉拿铁
    nutsbuff_banana = {
        name = "nutsbuff_banana",
        title = "香蕉拿铁",
        desc = "猴子不会主动跟随/偷取物品",
        image = "nuts_latte_banana",
        duration = 8 * 60
    },
    -- 青饺
    nutsbuff_moisture = {
        name = "nutsbuff_moisture",
        title = "青饺",
        desc = "保持不会潮湿",
        image = "nuts_dumpling",
        duration = 6 * 60
    },
    -- 回精神(松间云雾/桂馥兰香奶茶/月饼)
    nutsbuff_sanity = {
        name = "nutsbuff_sanity",
        title = "回精神",
        desc = "每2秒回复1点精神",
        image = "nuts_mistypine",
        duration = 60
    },
    -- 在水里,在天上,在心中(中秋彩蛋料理，玉兔专属额外效果)
    nutsbuff_yutu = {
        name = "nutsbuff_yutu",
        title = "在水里,在天上,在心中",
        desc = "玉兔2分钟内精神不降低",
        image = "nuts_mooncake",
        duration = 2 * 60
    },
    -- 不断回响的时光
    nuts_buff_echotime = {
        name = "nuts_buff_echotime",
        title = "不断回响的时光",
        desc = "移动速度提升20%",
        image = "nuts_echotime",
        duration = 360
    },
    -- 于火光中映照出来
    nuts_buff_flameborn = {
        name = "nuts_buff_flameborn",
        title = "于火光中映照出来",
        desc = "提升睡眠抗性(拉姆额外免疫潮湿/冰冻)",
        image = "nuts_flameborn",
        duration = 480
    },
    -- 回忆里,在此处
    nuts_buff_memorybound = {
        name = "nuts_buff_memorybound",
        title = "回忆里,在此处",
        desc = "提升睡眠抗性(莱茵额外提升位面伤害)",
        image = "nuts_memorybound",
        duration = 480
    },
    -- 兔子血
    nuts_buff_rabbit_blood = {
        name = "nuts_buff_rabbit_blood",
        title = "兔子血",
        desc = "攻击力提升20%(加洛普攻击额外吸血)",
        image = "nuts_rabbit_blood",
        duration = 480
    },
    -- 蔷薇拿铁
    nuts_buff_rosy_latte = {
        name = "nuts_buff_rosy_latte",
        title = "蔷薇拿铁",
        desc = "移动速度提升20%",
        image = "nuts_rosy_latte",
        duration = 480
    },
    -- 蔷薇拿铁(回血)
    nuts_buff_rosy_latte1 = {
        name = "nuts_buff_rosy_latte1",
        title = "蔷薇拿铁(回血)",
        desc = "每1秒回复1点生命",
        image = "nuts_rosy_latte",
        duration = 30
    },
    -- 看见一弯银轮
    nuts_buff_silver_crescent = {
        name = "nuts_buff_silver_crescent",
        title = "看见一弯银轮",
        desc = "获得照料作物的效果",
        image = "nuts_silver_crescent",
        duration = 480
    },
    -- 松香脆肠卷
    nuts_buff_pine_sausage_roll = {
        name = "nuts_buff_pine_sausage_roll",
        title = "松香脆肠卷",
        desc = "所有生物仇恨度下降",
        image = "nuts_pine_sausage_roll",
        duration = 480
    },
    -- 开心果拿铁
    nuts_buff_pistachio_latte = {
        name = "nuts_buff_pistachio_latte",
        title = "开心果拿铁",
        desc = "移动速度提升20%",
        image = "nuts_pistachio_latte",
        duration = 480
    },
    -- 开心果拿铁(防御)
    nuts_buff_pistachio_latte1 = {
        name = "nuts_buff_pistachio_latte1",
        title = "开心果拿铁(防御)",
        desc = "受到的伤害减少1/3",
        image = "nuts_pistachio_latte",
        duration = 240
    },
    -- 咖啡粉(食趣联动调味："浓郁的料理"移速)
    tf_buff_coffee_powder = {
        name = "tf_buff_coffee_powder",
        title = "咖啡粉",
        desc = "移动速度提升10%",
        image = "spice_tf_coffee_powder",
        duration = 240
    }
}

-- 大厨沃利专属菜(体温/发光效果)
-- 注意：这 3 个菜的效果不是游戏内的 buff 实体(无 debuff 组件)，无法通过 buff 挂接自动监听。
-- 热龙椒沙拉/芦笋冷汤 靠食物自带体温机制 SetTemperatureInBelly 实现(见原版 edible.lua)，
-- 发光浆果慕斯 靠生成发光实体 wormlight_light_greater 实现(见原版 preparedfoods_warly.lua)。
-- 因此在 main/player.lua 中改为监听食物进食事件(oneaten)手动计时。
-- duration 即实际生效时长：控温菜 5 分钟(TUNING.BUFF_FOOD_TEMP_DURATION)，慕斯发光 2 天(WORMLIGHT_DURATION * 4)。
TUNING.BT_FOOD_EFFECTS = {
    -- 热龙椒沙拉(肚内体温，tempHot=true 升温)
    dragonchilisalad = {
        name = "dragonchilisalad",
        title = "热龙椒沙拉",
        desc = "体温高于世界温度40度，冬天不怕冷",
        image = "dragonchilisalad",
        duration = TUNING.BUFF_FOOD_TEMP_DURATION,
        tempDuration = TUNING.BUFF_FOOD_TEMP_DURATION,
        tempHot = true
    },
    -- 芦笋冷汤(肚内体温降温)
    gazpacho = {
        name = "gazpacho",
        title = "芦笋冷汤",
        desc = "体温低于世界温度40度，夏天不怕热",
        image = "gazpacho",
        duration = TUNING.BUFF_FOOD_TEMP_DURATION,
        tempDuration = TUNING.BUFF_FOOD_TEMP_DURATION,
        tempHot = false
    },
    -- 绿豆汤(香脆松子，肚内体温降温12分钟)
    mungbean_soup = {
        name = "mungbean_soup",
        title = "绿豆汤",
        desc = "降低体温，防止过热",
        image = "nuts_mungbean_soup",
        duration = 12 * 60,
        tempDuration = 12 * 60,
        tempHot = false
    },
    -- 红薯糖水(香脆松子，肚内体温升温16分钟)
    sweetpotato_soup = {
        name = "sweetpotato_soup",
        title = "红薯糖水",
        desc = "保持温度不过冷",
        image = "nuts_sweetpotato_soup",
        duration = 16 * 60,
        tempDuration = 16 * 60,
        tempHot = true
    },
    -- 通用保温(肚内体温升温的兜底：能力勋章同款通用方式，覆盖任何未单独登记的热量食物/调料变体/其他mod料理；
    -- 实际图标会动态替换为"最后吃的那道料理"图片)
    bt_temp_warm = {
        name = "bt_temp_warm",
        title = "保温",
        desc = "肚内热量提升，温暖效果",
        image = "spice_chili",
        isGenericTemp = true
    },
    -- 通用降温(肚内体温降温的兜底，图标同上动态替换为最后吃的料理)
    bt_temp_cool = {
        name = "bt_temp_cool",
        title = "降温",
        desc = "肚内温度降低，清凉效果",
        image = "frogfishbowl",
        isGenericTemp = true
    },
    -- 发光浆果慕斯
    glowberrymousse = {
        name = "glowberrymousse",
        title = "发光浆果慕斯",
        desc = "获得持续发光效果(范围随时间逐渐减小)",
        image = "glowberrymousse",
        duration = TUNING.WORMLIGHT_DURATION * 4
    }
}
