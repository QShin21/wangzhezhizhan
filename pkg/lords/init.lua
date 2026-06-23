local extension = Package:new("wzzz_lords")
extension.extensionName = "wangzhezhizhan"
extension:loadSkillSkelsByPath("./packages/wangzhezhizhan/pkg/lords/skills")
extension:loadSkillSkelsByPath("./packages/wangzhezhizhan/pkg/generals/skills")
extension:loadSkillSkelsByPath("./packages/wangzhezhizhan/vendor/skills")

Fk:loadTranslationTable {
  ["wzzz_lords"] = "常备主公",
}

-- 1. 曹操
local g1 = General:new(extension, "wzzz_lord__caocao", "wei", 4)
g1:addSkills { "wzzz__shuzhi", "wzzz_v__ex__jianxiong", "wzzz_v__mou__qingzheng", "wzzz_v__hujia" }
Fk:loadTranslationTable {
  ["wzzz_lord__caocao"] = "曹操",
}

-- 2. 曹叡
local g2 = General:new(extension, "wzzz_lord__caorui", "wei", 3)
g2:addSkills { "wzzz_v__ty_ex__mingjian", "wzzz_v__huituo", "wzzz_v__xingshuai" }
Fk:loadTranslationTable {
  ["wzzz_lord__caorui"] = "曹叡",
}

-- 3. 曹丕
local g3 = General:new(extension, "wzzz_lord__caopi", "wei", 3)
g3:addSkills { "wzzz_v__xingshang", "wzzz_v__fangzhu", "wzzz_v__songwei" }
Fk:loadTranslationTable {
  ["wzzz_lord__caopi"] = "曹丕",
}

-- 4. 刘备
local g4 = General:new(extension, "wzzz_lord__liubei", "shu", 4)
g4:addSkills { "wzzz_v__ex__rende", "wzzz_v__v11__renwang", "wzzz_v__jijiang", "wzzz__shouyue" }
Fk:loadTranslationTable {
  ["wzzz_lord__liubei"] = "刘备",
}

-- 5. 刘禅
local g5 = General:new(extension, "wzzz_lord__liushan", "shu", 3)
g5:addSkills { "wzzz_v__xiangle", "wzzz_v__m_ex__fangquan", "wzzz_v__ol_ex__ruoyu" }
g5:addRelatedSkills { "wzzz_v__jijiang", "wzzz_v__sishu" }
Fk:loadTranslationTable {
  ["wzzz_lord__liushan"] = "刘禅",
}

-- 6. 孙皓
local g6 = General:new(extension, "wzzz_lord__sunhao", "wu", 5)
g6:addSkills { "wzzz_v__ol__canshi", "wzzz_v__ty__chouhai", "wzzz_v__guiming" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunhao"] = "孙皓",
}

-- 7. 孙权
local g7 = General:new(extension, "wzzz_lord__sunquan", "wu", 4)
g7:addSkills { "wzzz_v__tycl__zhiheng", "wzzz_v__mou__jiuyuan", "wzzz_v__ofl_mou__tongye" }
g7:addRelatedSkills { "wzzz_v__ex__yingzi", "wzzz_v__guzheng" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunquan"] = "孙权",
}

-- 8. 孙策
local g8 = General:new(extension, "wzzz_lord__sunce", "wu", 4)
g8:addSkills { "wzzz_v__jiang", "wzzz_v__ol_ex__hunzi", "wzzz_v__zhiba" }
g8:addRelatedSkills { "wzzz_v__ex__yingzi", "wzzz_v__yinghun" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunce"] = "孙策",
}

-- 9. 孙坚
local g9 = General:new(extension, "wzzz_lord__sunjian", "wu", 4, 5)
g9:addSkills { "wzzz_v__yinghun", "wzzz_v__wulie", "wzzz_v__os_ex__polu" }
g9:addRelatedSkills { "wzzz_v__ol__pingtao" }
Fk:loadTranslationTable {
  ["wzzz_lord__sunjian"] = "孙坚",
}

-- 10. 刘协
local g10 = General:new(extension, "wzzz_lord__liuxie", "qun", 3)
g10:addSkills { "wzzz_v__tianming", "wzzz_v__mizhao", "wzzz_v__os__zhuiting" }
Fk:loadTranslationTable {
  ["wzzz_lord__liuxie"] = "刘协",
}

return extension
