local extension = Package:new("wzzz_lords")
extension.extensionName = "wangzhezhizhan"
require("packages.wangzhezhizhan.pkg.load_skills")(extension)

Fk:loadTranslationTable {
  ["wzzz_lords"] = "常备主公",
}

-- 1. 曹操
local g1 = General:new(extension, "wzzz_lord__caocao", "wei", 4)
g1.title = "魏武帝"
g1.trueName = "曹操"
g1:addSkills { "wzzz__shuzhi", "wzzz_v__ex__jianxiong", "wzzz_v__mou__qingzheng", "wzzz_v__hujia" }
Fk:loadTranslationTable {
  ["wzzz_lord__caocao"] = "曹操",
  ["#" .. "wzzz_lord__caocao"] = "魏武帝",
}

-- 2. 曹丕
local g2 = General:new(extension, "wzzz_lord__caopi", "wei", 3)
g2.title = "霸业的继承者"
g2.trueName = "曹丕"
g2:addSkills { "wzzz_v__xingshang", "wzzz_v__fangzhu", "wzzz_v__songwei" }
Fk:loadTranslationTable {
  ["wzzz_lord__caopi"] = "曹丕",
  ["#" .. "wzzz_lord__caopi"] = "霸业的继承者",
}

-- 3. 曹叡
local g3 = General:new(extension, "wzzz_lord__caorui", "wei", 3)
g3.title = "天姿的明君"
g3.trueName = "曹叡"
g3:addSkills { "wzzz_v__ty_ex__mingjian", "wzzz_v__huituo", "wzzz_v__xingshuai" }
Fk:loadTranslationTable {
  ["wzzz_lord__caorui"] = "曹叡",
  ["#" .. "wzzz_lord__caorui"] = "天姿的明君",
}

-- 4. 刘备
local g4 = General:new(extension, "wzzz_lord__liubei", "shu", 4)
g4.title = "乱世的枭雄"
g4.trueName = "刘备"
g4:addSkills { "wzzz_v__ex__rende", "wzzz_v__v11__renwang", "wzzz_v__jijiang", "wzzz__shouyue" }
Fk:loadTranslationTable {
  ["wzzz_lord__liubei"] = "刘备",
  ["#" .. "wzzz_lord__liubei"] = "乱世的枭雄",
}

-- 5. 刘禅
local g5 = General:new(extension, "wzzz_lord__liushan", "shu", 3)
g5.title = "乐不思蜀"
g5.trueName = "刘禅"
g5:addSkills { "wzzz_v__xiangle", "wzzz_v__m_ex__fangquan", "wzzz_v__ol_ex__ruoyu" }
g5:addRelatedSkills { "wzzz_v__jijiang", "wzzz_v__sishu" }
Fk:loadTranslationTable {
  ["wzzz_lord__liushan"] = "刘禅",
  ["#" .. "wzzz_lord__liushan"] = "乐不思蜀",
}

-- 6. 孙权
local g6 = General:new(extension, "wzzz_lord__sunquan", "wu", 4)
g6.title = "年轻的贤君"
g6.trueName = "孙权"
g6:addSkills { "wzzz_v__tycl__zhiheng", "wzzz_v__mou__jiuyuan", "wzzz_v__ofl_mou__tongye" }
g6:addRelatedSkills { "wzzz_v__ex__yingzi", "wzzz_v__guzheng" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunquan"] = "孙权",
  ["#" .. "wzzz_lord__sunquan"] = "年轻的贤君",
}

-- 7. 孙策
local g7 = General:new(extension, "wzzz_lord__sunce", "wu", 4)
g7.title = "江东小霸王"
g7.trueName = "孙策"
g7:addSkills { "wzzz_v__jiang", "wzzz_v__ol_ex__hunzi", "wzzz_v__zhiba" }
g7:addRelatedSkills { "wzzz_v__ex__yingzi", "wzzz_v__yinghun" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunce"] = "孙策",
  ["#" .. "wzzz_lord__sunce"] = "江东小霸王",
}

-- 8. 孙皓
local g8 = General:new(extension, "wzzz_lord__sunhao", "wu", 5)
g8.title = "时日曷丧"
g8.trueName = "孙皓"
g8:addSkills { "wzzz_v__ol__canshi", "wzzz_v__ty__chouhai", "wzzz_v__guiming" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunhao"] = "孙皓",
  ["#" .. "wzzz_lord__sunhao"] = "时日曷丧",
}

-- 9. 孙坚
local g9 = General:new(extension, "wzzz_lord__sunjian", "wu", 4, 5)
g9.title = "武烈帝"
g9.trueName = "孙坚"
g9:addSkills { "wzzz_v__yinghun", "wzzz_v__wulie", "wzzz_v__os_ex__polu" }
g9:addRelatedSkills { "wzzz_v__ol__pingtao" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunjian"] = "孙坚",
  ["#" .. "wzzz_lord__sunjian"] = "武烈帝",
}

-- 10. 刘协
local g10 = General:new(extension, "wzzz_lord__liuxie", "qun", 3)
g10.title = "真命天子"
g10.trueName = "刘协"
g10:addSkills { "wzzz_v__tianming", "wzzz_v__mizhao", "wzzz_v__os__zhuiting" }
Fk:loadTranslationTable {
  ["wzzz_lord__liuxie"] = "刘协",
  ["#" .. "wzzz_lord__liuxie"] = "真命天子",
}

-- 11. 董卓
local g11 = General:new(extension, "wzzz_lord__dongzhuo", "qun", 8)
g11.title = "魔王"
g11.trueName = "董卓"
g11:addSkills { "wzzz_v__ol_ex__jiuchi", "wzzz_v__roulin", "wzzz_v__benghuai", "wzzz_v__ol_ex__baonue" }
Fk:loadTranslationTable {
  ["wzzz_lord__dongzhuo"] = "董卓",
  ["#" .. "wzzz_lord__dongzhuo"] = "魔王",
}

-- 12. 刘辩
local g12 = General:new(extension, "wzzz_lord__liubian", "qun", 3)
g12.title = "弘农怀王"
g12.trueName = "刘辩"
g12:addSkills { "wzzz_v__shiyuan", "wzzz_v__dushi", "wzzz_v__yuwei" }
Fk:loadTranslationTable {
  ["wzzz_lord__liubian"] = "刘辩",
  ["#" .. "wzzz_lord__liubian"] = "弘农怀王",
}

-- 13. 马腾
local g13 = General:new(extension, "wzzz_lord__mateng", "qun", 4)
g13.title = "驰骋西陲"
g13.trueName = "马腾"
g13:addSkills { "wzzz_v__mashu", "wzzz_s__96c4_4e89", "wzzz_s__4e71_5e74" }
Fk:loadTranslationTable {
  ["wzzz_lord__mateng"] = "马腾",
  ["#" .. "wzzz_lord__mateng"] = "驰骋西陲",
}

-- 14. 孙亮
local g14 = General:new(extension, "wzzz_lord__sunliang", "wu", 3)
g14.title = "寒江枯木"
g14.trueName = "孙亮"
g14:addSkills { "wzzz_v__ol__kuizhu", "wzzz_v__ol__chezheng", "wzzz_v__ol__lijun" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunliang"] = "孙亮",
  ["#" .. "wzzz_lord__sunliang"] = "寒江枯木",
}

-- 15. 袁绍
local g15 = General:new(extension, "wzzz_lord__yuanshao", "qun", 4)
g15.title = "高贵的名门"
g15.trueName = "袁绍"
g15:addSkills { "wzzz_v__ofl_mou__luanji", "wzzz_v__mou__xueyi", "wzzz_s__76df_65cc" }
Fk:loadTranslationTable {
  ["wzzz_lord__yuanshao"] = "袁绍",
  ["#" .. "wzzz_lord__yuanshao"] = "高贵的名门",
}

-- 16. 张角
local g16 = General:new(extension, "wzzz_lord__zhangjiao", "qun", 3)
g16.title = "天公将军"
g16.trueName = "张角"
g16:addSkills { "wzzz_v__ol_ex__leiji", "wzzz_v__ol_ex__guidao", "wzzz_v__ol_ex__huangtian" }
Fk:loadTranslationTable {
  ["wzzz_lord__zhangjiao"] = "张角",
  ["#" .. "wzzz_lord__zhangjiao"] = "天公将军",
}

return extension
