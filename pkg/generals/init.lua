local extension = Package:new("wzzz_generals")
extension.extensionName = "wangzhezhizhan"
require("packages.wangzhezhizhan.pkg.load_skills")(extension)

Fk:loadTranslationTable {
  ["wzzz_generals"] = "非主公",
}

-- 1. 董允
local g1 = General:new(extension, "wzzz__dongyun", "shu", 3)
g1.title = "骨鲠良相"
g1.trueName = "董允"
g1:addSkills { "wzzz_v__sheyan", "wzzz_v__bingzheng" }
Fk:loadTranslationTable {
  ["wzzz__dongyun"] = "董允",
  ["#" .. "wzzz__dongyun"] = "骨鲠良相",
}

-- 2. 法正
local g2 = General:new(extension, "wzzz__fazheng", "shu", 3)
g2.title = "蜀汉的辅翼"
g2.trueName = "法正"
g2:addSkills { "wzzz_v__ol_ex__enyuan", "wzzz_v__ol_ex__xuanhuo" }
Fk:loadTranslationTable {
  ["wzzz__fazheng"] = "法正",
  ["#" .. "wzzz__fazheng"] = "蜀汉的辅翼",
}

-- 3. 傅肜
local g3 = General:new(extension, "wzzz__furong", "shu", 4)
g3.title = "矢忠不二"
g3.trueName = "傅肜"
g3:addSkills { "wzzz_v__xiaosi" }
Fk:loadTranslationTable {
  ["wzzz__furong"] = "傅肜",
  ["#" .. "wzzz__furong"] = "矢忠不二",
}

-- 4. 关平
local g4 = General:new(extension, "wzzz__guanping", "shu", 4)
g4.title = "忠臣孝子，血战禁将"
g4.trueName = "关平"
g4:addSkills { "wzzz_v__ty_ex__longyin", "wzzz_v__ty_ex__jiezhong" }
Fk:loadTranslationTable {
  ["wzzz__guanping"] = "关平",
  ["#" .. "wzzz__guanping"] = "忠臣孝子，血战禁将",
}

-- 5. 关兴张苞
local g5 = General:new(extension, "wzzz__guanxingzhangbao", "shu", 4)
g5.title = "将门虎子"
g5.trueName = "关兴张苞"
g5:addSkills { "wzzz_v__fuhun", "wzzz_v__ty_ex__tongxin" }
g5:addRelatedSkills { "wzzz_v__wusheng", "wzzz_v__gxzb__paoxiao" }
Fk:loadTranslationTable {
  ["wzzz__guanxingzhangbao"] = "关兴张苞",
  ["#" .. "wzzz__guanxingzhangbao"] = "将门虎子",
}

-- 6. 关银屏
local g6 = General:new(extension, "wzzz__guanyinping", "shu", 3, 3, General.Female)
g6.title = "武姬"
g6.trueName = "关银屏"
g6:addSkills { "wzzz_v__ol__xuehen", "wzzz_v__ol__huxiao", "wzzz_v__shzj_guansuo__wuji" }
g6:addRelatedSkills { "wzzz_s__5043_6708", "wzzz_v__wusheng" }
Fk:loadTranslationTable {
  ["wzzz__guanyinping"] = "关银屏",
  ["#" .. "wzzz__guanyinping"] = "武姬",
}

-- 7. 关羽
local g7 = General:new(extension, "wzzz__guanyu", "shu", 4)
g7.title = "美髯公"
g7.trueName = "关羽"
g7:addSkills { "wzzz_v__v11__huwei", "wzzz_v__wusheng", "wzzz__qinglong", "wzzz_v__ex__yijue" }
g7:addRelatedSkills { "wzzz_v__zhongyi" }
Fk:loadTranslationTable {
  ["wzzz__guanyu"] = "关羽",
  ["#" .. "wzzz__guanyu"] = "美髯公",
}

-- 8. 胡金定
local g8 = General:new(extension, "wzzz__hujinding", "shu", 2, 5, General.Female)
g8.title = "怀子求怜"
g8.trueName = "胡金定"
g8:addSkills { "wzzz_v__renshi", "wzzz_v__wuyuan", "wzzz_v__huaizi" }
Fk:loadTranslationTable {
  ["wzzz__hujinding"] = "胡金定",
  ["#" .. "wzzz__hujinding"] = "怀子求怜",
}

-- 9. 黄皓
local g9 = General:new(extension, "wzzz__huanghao", "shu", 3)
g9.title = "便辟佞慧"
g9.trueName = "黄皓"
g9:addSkills { "wzzz_v__ty__qinqing", "wzzz_v__huisheng", "wzzz_v__cunwei" }
Fk:loadTranslationTable {
  ["wzzz__huanghao"] = "黄皓",
  ["#" .. "wzzz__huanghao"] = "便辟佞慧",
}

-- 10. 黄权
local g10 = General:new(extension, "wzzz__huangquan", "shu", 3)
g10.title = "道绝殊途"
g10.trueName = "黄权"
g10:addSkills { "wzzz_v__choujin", "wzzz_v__jianji", "wzzz_v__tujue" }
Fk:loadTranslationTable {
  ["wzzz__huangquan"] = "黄权",
  ["#" .. "wzzz__huangquan"] = "道绝殊途",
}

-- 11. 黄月英
local g11 = General:new(extension, "wzzz__huangyueying", "shu", 3, 3, General.Female)
g11.title = "归隐的杰女"
g11.trueName = "黄月英"
g11:addSkills { "wzzz_v__ofl_mou__jizhi", "wzzz_v__qicai", "wzzz_v__ol__jiqiao" }
Fk:loadTranslationTable {
  ["wzzz__huangyueying"] = "黄月英",
  ["#" .. "wzzz__huangyueying"] = "归隐的杰女",
}

-- 12. 黄忠
local g12 = General:new(extension, "wzzz__huangzhong", "shu", 4)
g12.title = "老当益壮"
g12.trueName = "黄忠"
g12:addSkills { "wzzz_v__ol_ex__liegong", "wzzz_v__yizhuang" }
Fk:loadTranslationTable {
  ["wzzz__huangzhong"] = "黄忠",
  ["#" .. "wzzz__huangzhong"] = "老当益壮",
}

-- 13. 姜维
local g13 = General:new(extension, "wzzz__jiangwei", "shu", 4)
g13.title = "龙的衣钵"
g13.trueName = "姜维"
g13:addSkills { "wzzz_v__ol_ex__tiaoxin", "wzzz_v__ol_ex__zhiji" }
g13:addRelatedSkills { "wzzz_v__jiangwei__guanxing" }
Fk:loadTranslationTable {
  ["wzzz__jiangwei"] = "姜维",
  ["#" .. "wzzz__jiangwei"] = "龙的衣钵",
}

-- 14. 刘备
local g14 = General:new(extension, "wzzz__liubei", "shu", 4)
g14.title = "乱世的枭雄"
g14.trueName = "刘备"
g14:addSkills { "wzzz_v__ex__rende", "wzzz_v__v11__renwang" }
Fk:loadTranslationTable {
  ["wzzz__liubei"] = "刘备",
  ["#" .. "wzzz__liubei"] = "乱世的枭雄",
}

-- 15. 刘谌
local g15 = General:new(extension, "wzzz__liuchen", "shu", 4)
g15.title = "血荐轩辕"
g15.trueName = "刘谌"
g15:addSkills { "wzzz_v__zhanjue", "wzzz_v__qinwang" }
Fk:loadTranslationTable {
  ["wzzz__liuchen"] = "刘谌",
  ["#" .. "wzzz__liuchen"] = "血荐轩辕",
}

-- 16. 刘封
local g16 = General:new(extension, "wzzz__liufeng", "shu", 4)
g16.title = "骑虎之殇"
g16.trueName = "刘封"
g16:addSkills { "wzzz_v__ty_ex__xiansi" }
Fk:loadTranslationTable {
  ["wzzz__liufeng"] = "刘封",
  ["#" .. "wzzz__liufeng"] = "骑虎之殇",
}

-- 17. 刘禅
local g17 = General:new(extension, "wzzz__liushan", "shu", 3)
g17.title = "乐不思蜀"
g17.trueName = "刘禅"
g17:addSkills { "wzzz_v__xiangle", "wzzz_v__m_ex__fangquan" }
Fk:loadTranslationTable {
  ["wzzz__liushan"] = "刘禅",
  ["#" .. "wzzz__liushan"] = "乐不思蜀",
}

-- 18. 马超
local g18 = General:new(extension, "wzzz__machao", "shu", 4)
g18.title = "一骑当千"
g18.trueName = "马超"
g18:addSkills { "wzzz_v__mashu", "wzzz_v__ex__tieji", "wzzz__jinzi" }
Fk:loadTranslationTable {
  ["wzzz__machao"] = "马超",
  ["#" .. "wzzz__machao"] = "一骑当千",
}

-- 19. 马良
local g19 = General:new(extension, "wzzz__maliang", "shu", 3)
g19.title = "白眉智士"
g19.trueName = "马良"
g19:addSkills { "wzzz_v__mobile__zishu", "wzzz_v__yingyuan", "wzzz_v__sxfy__xiemu" }
Fk:loadTranslationTable {
  ["wzzz__maliang"] = "马良",
  ["#" .. "wzzz__maliang"] = "白眉智士",
}

-- 20. 马谡
local g20 = General:new(extension, "wzzz__masu", "shu", 3)
g20.title = "军略之才器"
g20.trueName = "马谡"
g20:addSkills { "wzzz_v__ol__sanyao", "wzzz_v__ty_ex__zhiman", "wzzz_v__huilei" }
Fk:loadTranslationTable {
  ["wzzz__masu"] = "马谡",
  ["#" .. "wzzz__masu"] = "军略之才器",
}

-- 21. 糜夫人
local g21 = General:new(extension, "wzzz__mifuren", "shu", 3, 3, General.Female)
g21.title = "乱世沉香"
g21.trueName = "糜夫人"
g21:addSkills { "wzzz_v__mobile__guixiu", "wzzz_v__qingyu", "wzzz_v__ty__cunsi" }
g21:addRelatedSkills { "wzzz_v__ty__yongjue" }
Fk:loadTranslationTable {
  ["wzzz__mifuren"] = "糜夫人",
  ["#" .. "wzzz__mifuren"] = "乱世沉香",
}

-- 22. 糜竺
local g22 = General:new(extension, "wzzz__mizhu", "shu", 3)
g22.title = "挥金追义"
g22.trueName = "糜竺"
g22:addSkills { "wzzz_v__jugu", "wzzz_v__ziyuan" }
Fk:loadTranslationTable {
  ["wzzz__mizhu"] = "糜竺",
  ["#" .. "wzzz__mizhu"] = "挥金追义",
}

-- 23. 庞统
local g23 = General:new(extension, "wzzz__pangtong", "shu", 3)
g23.title = "凤雏"
g23.trueName = "庞统"
g23:addSkills { "wzzz_v__m_ex__lianhuan", "wzzz_v__niepan" }
g23:addRelatedSkills { "wzzz_v__bazhen", "wzzz_v__pangtong__huoji", "wzzz_v__ol_ex__kanpo" }
Fk:loadTranslationTable {
  ["wzzz__pangtong"] = "庞统",
  ["#" .. "wzzz__pangtong"] = "凤雏",
}

-- 24. 谯周
local g24 = General:new(extension, "wzzz__qiaozhou", "shu", 3)
g24.title = "观星知命"
g24.trueName = "谯周"
g24:addSkills { "wzzz_v__os__zhiming", "wzzz_v__xingbu" }
Fk:loadTranslationTable {
  ["wzzz__qiaozhou"] = "谯周",
  ["#" .. "wzzz__qiaozhou"] = "观星知命",
}

-- 25. 秦宓
local g25 = General:new(extension, "wzzz__qinmi", "shu", 3)
g25.title = "彻天之舌"
g25.trueName = "秦宓"
g25:addSkills { "wzzz_v__jianzhengq", "wzzz_v__zhuandui", "wzzz_v__tianbian" }
Fk:loadTranslationTable {
  ["wzzz__qinmi"] = "秦宓",
  ["#" .. "wzzz__qinmi"] = "彻天之舌",
}

-- 26. 沙摩柯
local g26 = General:new(extension, "wzzz__shamoke", "shu", 4)
g26.title = "五溪蛮王"
g26.trueName = "沙摩柯"
g26:addSkills { "wzzz_v__jilis" }
Fk:loadTranslationTable {
  ["wzzz__shamoke"] = "沙摩柯",
  ["#" .. "wzzz__shamoke"] = "五溪蛮王",
}

-- 27. 王平
local g27 = General:new(extension, "wzzz__wangping", "shu", 4)
g27.title = "兵谋以致用"
g27.trueName = "王平"
g27:addSkills { "wzzz_v__feijun", "wzzz_v__binglue" }
Fk:loadTranslationTable {
  ["wzzz__wangping"] = "王平",
  ["#" .. "wzzz__wangping"] = "兵谋以致用",
}

-- 28. 魏延
local g28 = General:new(extension, "wzzz__weiyan", "shu", 4)
g28.title = "嗜血的独狼"
g28.trueName = "魏延"
g28:addSkills { "wzzz_v__m_shi__kuanggu", "wzzz_v__m_ex__qimou" }
Fk:loadTranslationTable {
  ["wzzz__weiyan"] = "魏延",
  ["#" .. "wzzz__weiyan"] = "嗜血的独狼",
}

-- 29. 吴懿
local g29 = General:new(extension, "wzzz__wuyi", "shu", 4)
g29.title = "建兴鞍辔"
g29.trueName = "吴懿"
g29:addSkills { "wzzz_v__m_ex__benxi" }
Fk:loadTranslationTable {
  ["wzzz__wuyi"] = "吴懿",
  ["#" .. "wzzz__wuyi"] = "建兴鞍辔",
}

-- 30. 夏侯霸
local g30 = General:new(extension, "wzzz__xiahouba", "shu", 4)
g30.title = "棘途壮志"
g30.trueName = "夏侯霸"
g30:addSkills { "wzzz_v__ty__baobian", "wzzz__baolie" }
g30:addRelatedSkills { "wzzz_v__ol_ex__tiaoxin", "wzzz_v__xiahouba__paoxiao", "wzzz_v__shensu" }
Fk:loadTranslationTable {
  ["wzzz__xiahouba"] = "夏侯霸",
  ["#" .. "wzzz__xiahouba"] = "棘途壮志",
}

-- 31. 夏侯氏
local g31 = General:new(extension, "wzzz__xiahoushi", "shu", 3, 3, General.Female)
g31.title = "采缘撷睦"
g31.trueName = "夏侯氏"
g31:addSkills { "wzzz_v__qiaoshi", "wzzz_v__ty_ex__yanyu" }
Fk:loadTranslationTable {
  ["wzzz__xiahoushi"] = "夏侯氏",
  ["#" .. "wzzz__xiahoushi"] = "采缘撷睦",
}

-- 32. 张飞
local g32 = General:new(extension, "wzzz__zhangfei", "shu", 4)
g32.title = "万夫不当"
g32.trueName = "张飞"
g32:addSkills { "wzzz_v__ex__paoxiao", "wzzz_v__ex__tishen" }
Fk:loadTranslationTable {
  ["wzzz__zhangfei"] = "张飞",
  ["#" .. "wzzz__zhangfei"] = "万夫不当",
}

-- 33. 张松
local g33 = General:new(extension, "wzzz__zhangsong", "shu", 3)
g33.title = "怀璧待凤仪，血战禁将"
g33.trueName = "张松"
g33:addSkills { "wzzz_v__xiantu", "wzzz_v__qiangzhi" }
Fk:loadTranslationTable {
  ["wzzz__zhangsong"] = "张松",
  ["#" .. "wzzz__zhangsong"] = "怀璧待凤仪，血战禁将",
}

-- 34. 张星彩
local g34 = General:new(extension, "wzzz__zhangxingcai", "shu", 3, 3, General.Female)
g34.title = "敬哀皇后"
g34.trueName = "张星彩"
g34:addSkills { "wzzz_v__ol__shenxian", "wzzz_v__qiangwu" }
Fk:loadTranslationTable {
  ["wzzz__zhangxingcai"] = "张星彩",
  ["#" .. "wzzz__zhangxingcai"] = "敬哀皇后",
}

-- 35. 张翼
local g35 = General:new(extension, "wzzz__zhangyi", "shu", 4)
g35.title = "亢锐怀忠"
g35.trueName = "张翼"
g35:addSkills { "wzzz_v__zhiyi" }
Fk:loadTranslationTable {
  ["wzzz__zhangyi"] = "张翼",
  ["#" .. "wzzz__zhangyi"] = "亢锐怀忠",
}

-- 36. 张翼
local g36 = General:new(extension, "wzzz__zhangyi_fenggong", "shu", 4)
g36.title = "奉公弗怠"
g36.trueName = "张翼"
g36:addSkills { "wzzz_v__dianjun", "wzzz_v__kangrui" }
Fk:loadTranslationTable {
  ["wzzz__zhangyi_fenggong"] = "张翼",
  ["#" .. "wzzz__zhangyi_fenggong"] = "奉公弗怠",
}

-- 37. 诸葛亮
local g37 = General:new(extension, "wzzz__zhugeliang_chimu", "shu", 3)
g37.title = "迟暮的丞相"
g37.trueName = "诸葛亮"
g37:addSkills { "wzzz_v__ex__guanxing", "wzzz_v__zhitian", "wzzz_v__hs__kongcheng" }
Fk:loadTranslationTable {
  ["wzzz__zhugeliang_chimu"] = "诸葛亮",
  ["#" .. "wzzz__zhugeliang_chimu"] = "迟暮的丞相",
}

-- 38. 诸葛亮
local g38 = General:new(extension, "wzzz__zhugeliang_wolong", "shu", 3)
g38.title = "卧龙"
g38.trueName = "诸葛亮"
g38:addSkills { "wzzz_v__ol_ex__huoji", "wzzz_v__ol_ex__kanpo", "wzzz_v__bazhen" }
Fk:loadTranslationTable {
  ["wzzz__zhugeliang_wolong"] = "诸葛亮",
  ["#" .. "wzzz__zhugeliang_wolong"] = "卧龙",
}

-- 39. 诸葛瞻
local g39 = General:new(extension, "wzzz__zhugezhan", "shu", 3)
g39.title = "临难死义"
g39.trueName = "诸葛瞻"
g39:addSkills { "wzzz_v__zuilun", "wzzz_s__7236_840c" }
Fk:loadTranslationTable {
  ["wzzz__zhugezhan"] = "诸葛瞻",
  ["#" .. "wzzz__zhugezhan"] = "临难死义",
}

-- 40. 祝融
local g40 = General:new(extension, "wzzz__zhurong", "shu", 4, 4, General.Female)
g40.title = "野性的女王"
g40.trueName = "祝融"
g40:addSkills { "wzzz_v__juxiang", "wzzz_v__os_ex__lieren", "wzzz_v__changbiao" }
Fk:loadTranslationTable {
  ["wzzz__zhurong"] = "祝融",
  ["#" .. "wzzz__zhurong"] = "野性的女王",
}

-- 41. 步练师
local g41 = General:new(extension, "wzzz__bulianshi", "wu", 3, 3, General.Female)
g41.title = "无冕之后"
g41.trueName = "步练师"
g41:addSkills { "wzzz_v__m_ex__anxu", "wzzz_v__zhuiyi" }
Fk:loadTranslationTable {
  ["wzzz__bulianshi"] = "步练师",
  ["#" .. "wzzz__bulianshi"] = "无冕之后",
}

-- 42. 步骘
local g42 = General:new(extension, "wzzz__buzhi", "wu", 3)
g42.title = "积跬靖边"
g42.trueName = "步骘"
g42:addSkills { "wzzz_v__hongde", "wzzz_v__dingpan" }
Fk:loadTranslationTable {
  ["wzzz__buzhi"] = "步骘",
  ["#" .. "wzzz__buzhi"] = "积跬靖边",
}

-- 43. 岑昏
local g43 = General:new(extension, "wzzz__cenhun", "wu", 4)
g43.title = "伐梁倾瓴"
g43.trueName = "岑昏"
g43:addSkills { "wzzz_v__jishe", "wzzz_v__lianhuo", "wzzz_v__sxfy__wudu" }
Fk:loadTranslationTable {
  ["wzzz__cenhun"] = "岑昏",
  ["#" .. "wzzz__cenhun"] = "伐梁倾瓴",
}

-- 44. 大乔
local g44 = General:new(extension, "wzzz__daqiao", "wu", 3, 3, General.Female)
g44.title = "矜持之花"
g44.trueName = "大乔"
g44:addSkills { "wzzz_v__ex__guose", "wzzz_v__mou__liuli", "wzzz__wanrong" }
Fk:loadTranslationTable {
  ["wzzz__daqiao"] = "大乔",
  ["#" .. "wzzz__daqiao"] = "矜持之花",
}

-- 45. 丁奉
local g45 = General:new(extension, "wzzz__dingfeng", "wu", 4)
g45.title = "清侧忠臣"
g45.trueName = "丁奉"
g45:addSkills { "wzzz_v__ol__duanbing", "wzzz_v__qshm__fenxun" }
Fk:loadTranslationTable {
  ["wzzz__dingfeng"] = "丁奉",
  ["#" .. "wzzz__dingfeng"] = "清侧忠臣",
}

-- 46. 甘宁
local g46 = General:new(extension, "wzzz__ganning", "wu", 4)
g46.title = "锦帆游侠"
g46.trueName = "甘宁"
g46:addSkills { "wzzz_v__qixi", "wzzz_v__fenwei" }
Fk:loadTranslationTable {
  ["wzzz__ganning"] = "甘宁",
  ["#" .. "wzzz__ganning"] = "锦帆游侠",
}

-- 47. 顾雍
local g47 = General:new(extension, "wzzz__guyong", "wu", 3)
g47.title = "庙堂的玉磬"
g47.trueName = "顾雍"
g47:addSkills { "wzzz_v__ty_ex__shenxing", "wzzz_v__bingyi" }
Fk:loadTranslationTable {
  ["wzzz__guyong"] = "顾雍",
  ["#" .. "wzzz__guyong"] = "庙堂的玉磬",
}

-- 48. 韩当
local g48 = General:new(extension, "wzzz__handang", "wu", 4)
g48.title = "石城侯"
g48.trueName = "韩当"
g48:addSkills { "wzzz_v__gongqi", "wzzz_v__jiefan" }
Fk:loadTranslationTable {
  ["wzzz__handang"] = "韩当",
  ["#" .. "wzzz__handang"] = "石城侯",
}

-- 49. 黄盖
local g49 = General:new(extension, "wzzz__huanggai", "wu", 4)
g49.title = "轻身为国"
g49.trueName = "黄盖"
g49:addSkills { "wzzz_v__ex__kurou", "wzzz_v__ol_ex__zhaxiang" }
Fk:loadTranslationTable {
  ["wzzz__huanggai"] = "黄盖",
  ["#" .. "wzzz__huanggai"] = "轻身为国",
}

-- 50. 蒋钦
local g50 = General:new(extension, "wzzz__jiangqin", "wu", 4)
g50.title = "折节尚义"
g50.trueName = "蒋钦"
g50:addSkills { "wzzz_v__jianyi", "wzzz_v__mobile__shangyi" }
Fk:loadTranslationTable {
  ["wzzz__jiangqin"] = "蒋钦",
  ["#" .. "wzzz__jiangqin"] = "折节尚义",
}

-- 51. 凌操
local g51 = General:new(extension, "wzzz__lingcao", "wu", 4, 5)
g51.title = "激流勇进"
g51.trueName = "凌操"
g51:addSkills { "wzzz_v__ol__dujin", "wzzz_v__dufeng" }
Fk:loadTranslationTable {
  ["wzzz__lingcao"] = "凌操",
  ["#" .. "wzzz__lingcao"] = "激流勇进",
}

-- 52. 凌统
local g52 = General:new(extension, "wzzz__lingtong", "wu", 4)
g52.title = "豪情烈胆"
g52.trueName = "凌统"
g52:addSkills { "wzzz_v__m_ex__xuanfeng", "wzzz_v__ty_ex__yongjin" }
Fk:loadTranslationTable {
  ["wzzz__lingtong"] = "凌统",
  ["#" .. "wzzz__lingtong"] = "豪情烈胆",
}

-- 53. 留赞
local g53 = General:new(extension, "wzzz__liuzan", "wu", 4)
g53.title = "啸天亢声"
g53.trueName = "留赞"
g53:addSkills { "wzzz_v__sxfy__fenyin" }
Fk:loadTranslationTable {
  ["wzzz__liuzan"] = "留赞",
  ["#" .. "wzzz__liuzan"] = "啸天亢声",
}

-- 54. 鲁肃
local g54 = General:new(extension, "wzzz__lusu", "wu", 3)
g54.title = "独断的外交家"
g54.trueName = "鲁肃"
g54:addSkills { "wzzz_v__haoshi", "wzzz_v__ol_ex__dimeng" }
Fk:loadTranslationTable {
  ["wzzz__lusu"] = "鲁肃",
  ["#" .. "wzzz__lusu"] = "独断的外交家",
}

-- 55. 陆逊
local g55 = General:new(extension, "wzzz__luxun", "wu", 3)
g55.title = "儒生雄才"
g55.trueName = "陆逊"
g55:addSkills { "wzzz_v__ex__qianxun", "wzzz_v__ex__lianying", "wzzz__shunshi" }
Fk:loadTranslationTable {
  ["wzzz__luxun"] = "陆逊",
  ["#" .. "wzzz__luxun"] = "儒生雄才",
}

-- 56. 吕蒙
local g56 = General:new(extension, "wzzz__lvmeng", "wu", 4)
g56.title = "士别三日"
g56.trueName = "吕蒙"
g56:addSkills { "wzzz_v__keji", "wzzz_v__ol_ex__qinxue", "wzzz_v__botu" }
g56:addRelatedSkills { "wzzz_v__gongxin" }
Fk:loadTranslationTable {
  ["wzzz__lvmeng"] = "吕蒙",
  ["#" .. "wzzz__lvmeng"] = "士别三日",
}

-- 57. 潘濬
local g57 = General:new(extension, "wzzz__panjun", "wu", 3)
g57.title = "方严疾恶，血战禁将"
g57.trueName = "潘濬"
g57:addSkills { "wzzz_v__guanwei", "wzzz_v__gongqing" }
Fk:loadTranslationTable {
  ["wzzz__panjun"] = "潘濬",
  ["#" .. "wzzz__panjun"] = "方严疾恶，血战禁将",
}

-- 58. SP庞统
local g58 = General:new(extension, "wzzz_sp__sp_pangtong", "wu", 3)
g58.title = "南州士冠"
g58.trueName = "SP庞统"
g58:addSkills { "wzzz_v__guolun", "wzzz_v__zhanji", "wzzz_v__qshm__songsang" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_pangtong"] = "SP庞统",
  ["#" .. "wzzz_sp__sp_pangtong"] = "南州士冠",
}

-- 59. 全琮
local g59 = General:new(extension, "wzzz__quancong", "wu", 4)
g59.title = "慕势耀族"
g59.trueName = "全琮"
g59:addSkills { "wzzz_v__ol__yaoming" }
Fk:loadTranslationTable {
  ["wzzz__quancong"] = "全琮",
  ["#" .. "wzzz__quancong"] = "慕势耀族",
}

-- 60. 孙策
local g60 = General:new(extension, "wzzz__sunce", "wu", 4)
g60.title = "江东小霸王"
g60.trueName = "孙策"
g60:addSkills { "wzzz_v__jiang", "wzzz_v__ol_ex__hunzi" }
g60:addRelatedSkills { "wzzz_v__ex__yingzi", "wzzz_v__yinghun" }
Fk:loadTranslationTable {
  ["wzzz__sunce"] = "孙策",
  ["#" .. "wzzz__sunce"] = "江东小霸王",
}

-- 61. 孙登
local g61 = General:new(extension, "wzzz__sundeng", "wu", 4)
g61.title = "才高德茂"
g61.trueName = "孙登"
g61:addSkills { "wzzz_v__kuangbi" }
Fk:loadTranslationTable {
  ["wzzz__sundeng"] = "孙登",
  ["#" .. "wzzz__sundeng"] = "才高德茂",
}

-- 62. 孙皓
local g62 = General:new(extension, "wzzz__sunhao", "wu", 5)
g62.title = "时日曷丧"
g62.trueName = "孙皓"
g62:addSkills { "wzzz_v__ol__canshi", "wzzz_v__chouhai" }
Fk:loadTranslationTable {
  ["wzzz__sunhao"] = "孙皓",
  ["#" .. "wzzz__sunhao"] = "时日曷丧",
}

-- 63. 孙坚
local g63 = General:new(extension, "wzzz__sunjian", "wu", 4, 5)
g63.title = "武烈帝"
g63.trueName = "孙坚"
g63:addSkills { "wzzz_v__yinghun", "wzzz_v__wulie" }
Fk:loadTranslationTable {
  ["wzzz__sunjian"] = "孙坚",
  ["#" .. "wzzz__sunjian"] = "武烈帝",
}

-- 64. 孙鲁育
local g64 = General:new(extension, "wzzz__sunluyu", "wu", 3, 3, General.Female)
g64.title = "舍身饲虎"
g64.trueName = "孙鲁育"
g64:addSkills { "wzzz_v__ty__meibu", "wzzz_v__ty__mumu" }
g64:addRelatedSkills { "wzzz_v__ty__zhixi" }
Fk:loadTranslationTable {
  ["wzzz__sunluyu"] = "孙鲁育",
  ["#" .. "wzzz__sunluyu"] = "舍身饲虎",
}

-- 65. 孙权
local g65 = General:new(extension, "wzzz__sunquan", "wu", 4)
g65.title = "年轻的贤君"
g65.trueName = "孙权"
g65:addSkills { "wzzz_v__tycl__zhiheng" }
Fk:loadTranslationTable {
  ["wzzz__sunquan"] = "孙权",
  ["#" .. "wzzz__sunquan"] = "年轻的贤君",
}

-- 66. 孙茹
local g66 = General:new(extension, "wzzz__sunru", "wu", 3, 3, General.Female)
g66.title = "出水青莲"
g66.trueName = "孙茹"
g66:addSkills { "wzzz_v__yingjian", "wzzz_v__shixin" }
Fk:loadTranslationTable {
  ["wzzz__sunru"] = "孙茹",
  ["#" .. "wzzz__sunru"] = "出水青莲",
}

-- 67. 孙尚香
local g67 = General:new(extension, "wzzz__sunshangxiang", "wu", 3, 3, General.Female)
g67.title = "弓腰姬"
g67.trueName = "孙尚香"
g67:addSkills { "wzzz__yuanding", "wzzz_v__jieyin", "wzzz_v__liangzhu", "wzzz_v__xiaoji" }
Fk:loadTranslationTable {
  ["wzzz__sunshangxiang"] = "孙尚香",
  ["#" .. "wzzz__sunshangxiang"] = "弓腰姬",
}

-- 68. 太史慈
local g68 = General:new(extension, "wzzz__taishici", "wu", 4)
g68.title = "笃烈之士"
g68.trueName = "太史慈"
g68:addSkills { "wzzz_v__tianyi", "wzzz_v__hanzhan" }
Fk:loadTranslationTable {
  ["wzzz__taishici"] = "太史慈",
  ["#" .. "wzzz__taishici"] = "笃烈之士",
}

-- 69. 唐咨
local g69 = General:new(extension, "wzzz__tangzi", "wu", 4)
g69.title = "工学之奇才"
g69.trueName = "唐咨"
g69:addSkills { "wzzz_v__xingzhao", "wzzz_v__xunxun" }
Fk:loadTranslationTable {
  ["wzzz__tangzi"] = "唐咨",
  ["#" .. "wzzz__tangzi"] = "工学之奇才",
}

-- 70. 文鸯
local g70 = General:new(extension, "wzzz__wenyang", "wu", 4)
g70.title = "独骑破军"
g70.trueName = "文鸯"
g70:addSkills { "wzzz_v__quedi", "wzzz_v__mobile__choujue", "wzzz_v__ofl__chongjian" }
Fk:loadTranslationTable {
  ["wzzz__wenyang"] = "文鸯",
  ["#" .. "wzzz__wenyang"] = "独骑破军",
}

-- 71. 小乔
local g71 = General:new(extension, "wzzz__xiaoqiao", "wu", 3, 3, General.Female)
g71.title = "矫情之花"
g71.trueName = "小乔"
g71:addSkills { "wzzz_v__ol_ex__tianxiang", "wzzz_v__ol_ex__hongyan", "wzzz_v__ol_ex__piaoling" }
Fk:loadTranslationTable {
  ["wzzz__xiaoqiao"] = "小乔",
  ["#" .. "wzzz__xiaoqiao"] = "矫情之花",
}

-- 72. 徐盛
local g72 = General:new(extension, "wzzz__xusheng", "wu", 4)
g72.title = "江东的铁壁"
g72.trueName = "徐盛"
g72:addSkills { "wzzz_v__ty_ex__pojun", "wzzz_v__v33__yicheng" }
Fk:loadTranslationTable {
  ["wzzz__xusheng"] = "徐盛",
  ["#" .. "wzzz__xusheng"] = "江东的铁壁",
}

-- 73. 虞翻
local g73 = General:new(extension, "wzzz__yufan", "wu", 3)
g73.title = "狂直之士"
g73.trueName = "虞翻"
g73:addSkills { "wzzz_v__m_ex__zongxuan", "wzzz_v__ol_ex__zhiyan" }
Fk:loadTranslationTable {
  ["wzzz__yufan"] = "虞翻",
  ["#" .. "wzzz__yufan"] = "狂直之士",
}

-- 74. 张昭张纮
local g74 = General:new(extension, "wzzz__zhangzhaozhanghong", "wu", 3)
g74.title = "经天纬地"
g74.trueName = "张昭张纮"
g74:addSkills { "wzzz_v__ol_ex__zhijian", "wzzz_v__guzheng" }
Fk:loadTranslationTable {
  ["wzzz__zhangzhaozhanghong"] = "张昭张纮",
  ["#" .. "wzzz__zhangzhaozhanghong"] = "经天纬地",
}

-- 75. 周鲂
local g75 = General:new(extension, "wzzz__zhoufang", "wu", 3)
g75.title = "下发载义"
g75.trueName = "周鲂"
g75:addSkills { "wzzz_v__duanfa", "wzzz_v__sp__youdi" }
Fk:loadTranslationTable {
  ["wzzz__zhoufang"] = "周鲂",
  ["#" .. "wzzz__zhoufang"] = "下发载义",
}

-- 76. 周泰
local g76 = General:new(extension, "wzzz__zhoutai", "wu", 4)
g76.title = "历战之躯，血战禁将"
g76.trueName = "周泰"
g76:addSkills { "wzzz_v__hs__buqu", "wzzz_v__m_ex__fenji" }
Fk:loadTranslationTable {
  ["wzzz__zhoutai"] = "周泰",
  ["#" .. "wzzz__zhoutai"] = "历战之躯，血战禁将",
}

-- 77. 周瑜
local g77 = General:new(extension, "wzzz__zhouyu", "wu", 3)
g77.title = "大都督"
g77.trueName = "周瑜"
g77:addSkills { "wzzz_v__ex__yingzi", "wzzz_v__wzzz__fanjian" }
Fk:loadTranslationTable {
  ["wzzz__zhouyu"] = "周瑜",
  ["#" .. "wzzz__zhouyu"] = "大都督",
}

-- 78. 朱桓
local g78 = General:new(extension, "wzzz__zhuhuan", "wu", 4)
g78.title = "中洲拒天人"
g78.trueName = "朱桓"
g78:addSkills { "wzzz_v__fenli", "wzzz_v__pingkou" }
Fk:loadTranslationTable {
  ["wzzz__zhuhuan"] = "朱桓",
  ["#" .. "wzzz__zhuhuan"] = "中洲拒天人",
}

-- 79. 朱然
local g79 = General:new(extension, "wzzz__zhuran", "wu", 4)
g79.title = "不动之督"
g79.trueName = "朱然"
g79:addSkills { "wzzz_v__ty_ex__danshou" }
Fk:loadTranslationTable {
  ["wzzz__zhuran"] = "朱然",
  ["#" .. "wzzz__zhuran"] = "不动之督",
}

-- 80. 诸葛瑾
local g80 = General:new(extension, "wzzz__zhugejin", "wu", 3)
g80.title = "联盟的维系者"
g80.trueName = "诸葛瑾"
g80:addSkills { "wzzz_v__huanshi", "wzzz_v__hongyuan", "wzzz_v__mingzhe" }
Fk:loadTranslationTable {
  ["wzzz__zhugejin"] = "诸葛瑾",
  ["#" .. "wzzz__zhugejin"] = "联盟的维系者",
}

-- 81. 诸葛恪
local g81 = General:new(extension, "wzzz__zhugeke", "wu", 3)
g81.title = "兴家赤族"
g81.trueName = "诸葛恪"
g81:addSkills { "wzzz_v__duwu", "wzzz_v__ol__aocai" }
Fk:loadTranslationTable {
  ["wzzz__zhugeke"] = "诸葛恪",
  ["#" .. "wzzz__zhugeke"] = "兴家赤族",
}

-- 82. 祖茂
local g82 = General:new(extension, "wzzz__zumao", "wu", 4)
g82.title = "碧血染赤帻"
g82.trueName = "祖茂"
g82:addSkills { "wzzz_v__qshm__yinbing", "wzzz_v__juedi" }
Fk:loadTranslationTable {
  ["wzzz__zumao"] = "祖茂",
  ["#" .. "wzzz__zumao"] = "碧血染赤帻",
}

-- 83. 曹昂
local g83 = General:new(extension, "wzzz__caoang", "wei", 4)
g83.title = "取义成仁"
g83.trueName = "曹昂"
g83:addSkills { "wzzz_v__kangkai", "wzzz_v__vd_sheshen" }
Fk:loadTranslationTable {
  ["wzzz__caoang"] = "曹昂",
  ["#" .. "wzzz__caoang"] = "取义成仁",
}

-- 84. 曹操
local g84 = General:new(extension, "wzzz__caocao", "wei", 4)
g84.title = "魏武帝"
g84.trueName = "曹操"
g84:addSkills { "wzzz__shuzhi", "wzzz_v__ex__jianxiong", "wzzz_v__mou__qingzheng" }
Fk:loadTranslationTable {
  ["wzzz__caocao"] = "曹操",
  ["#" .. "wzzz__caocao"] = "魏武帝",
}

-- 85. 曹冲
local g85 = General:new(extension, "wzzz__caochong", "wei", 3)
g85.title = "仁爱的神童"
g85.trueName = "曹冲"
g85:addSkills { "wzzz_v__ty_ex__chengxiang", "wzzz_v__renxin" }
Fk:loadTranslationTable {
  ["wzzz__caochong"] = "曹冲",
  ["#" .. "wzzz__caochong"] = "仁爱的神童",
}

-- 86. 曹仁
local g86 = General:new(extension, "wzzz__caoren", "wei", 4)
g86.title = "大将军"
g86.trueName = "曹仁"
g86:addSkills { "wzzz_v__ol__jushou", "wzzz_v__ol__jiewei" }
Fk:loadTranslationTable {
  ["wzzz__caoren"] = "曹仁",
  ["#" .. "wzzz__caoren"] = "大将军",
}

-- 87. SP曹仁
local g87 = General:new(extension, "wzzz_sp__sp_caoren", "wei", 4)
g87.title = "险不辞难"
g87.trueName = "SP曹仁"
g87:addSkills { "wzzz_v__weikui", "wzzz_v__lizhan" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_caoren"] = "SP曹仁",
  ["#" .. "wzzz_sp__sp_caoren"] = "险不辞难",
}

-- 88. 曹叡
local g88 = General:new(extension, "wzzz__caorui", "wei", 3)
g88.title = "天姿的明君"
g88.trueName = "曹叡"
g88:addSkills { "wzzz_v__ty_ex__mingjian", "wzzz_v__huituo" }
Fk:loadTranslationTable {
  ["wzzz__caorui"] = "曹叡",
  ["#" .. "wzzz__caorui"] = "天姿的明君",
}

-- 89. 曹彰
local g89 = General:new(extension, "wzzz__caozhang", "wei", 4)
g89.title = "黄须儿"
g89.trueName = "曹彰"
g89:addSkills { "wzzz_v__ty_ex__jiangchi" }
Fk:loadTranslationTable {
  ["wzzz__caozhang"] = "曹彰",
  ["#" .. "wzzz__caozhang"] = "黄须儿",
}

-- 90. 陈群
local g90 = General:new(extension, "wzzz__chenqun", "wei", 3)
g90.title = "万世臣表"
g90.trueName = "陈群"
g90:addSkills { "wzzz_v__ty_ex__pindi", "wzzz_v__faen" }
Fk:loadTranslationTable {
  ["wzzz__chenqun"] = "陈群",
  ["#" .. "wzzz__chenqun"] = "万世臣表",
}

-- 91. 崔琰
local g91 = General:new(extension, "wzzz__cuiyan", "wei", 3)
g91.title = "伯夷之风"
g91.trueName = "崔琰"
g91:addSkills { "wzzz_v__yajun", "wzzz_v__zundi" }
Fk:loadTranslationTable {
  ["wzzz__cuiyan"] = "崔琰",
  ["#" .. "wzzz__cuiyan"] = "伯夷之风",
}

-- 92. 典韦
local g92 = General:new(extension, "wzzz__dianwei", "wei", 4)
g92.title = "古之恶来"
g92.trueName = "典韦"
g92:addSkills { "wzzz_v__ol__qiangxi", "wzzz_v__ninge" }
Fk:loadTranslationTable {
  ["wzzz__dianwei"] = "典韦",
  ["#" .. "wzzz__dianwei"] = "古之恶来",
}

-- 93. 邓艾
local g93 = General:new(extension, "wzzz__dengai", "wei", 4)
g93.title = "矫然的壮士"
g93.trueName = "邓艾"
g93:addSkills { "wzzz_v__ol_ex__tuntian", "wzzz_v__zaoxian" }
g93:addRelatedSkills { "wzzz_v__jixi" }
Fk:loadTranslationTable {
  ["wzzz__dengai"] = "邓艾",
  ["#" .. "wzzz__dengai"] = "矫然的壮士",
}

-- 94. 郭淮
local g94 = General:new(extension, "wzzz__guohuai", "wei", 4)
g94.title = "垂问秦雍"
g94.trueName = "郭淮"
g94:addSkills { "wzzz_v__ol__jingce" }
Fk:loadTranslationTable {
  ["wzzz__guohuai"] = "郭淮",
  ["#" .. "wzzz__guohuai"] = "垂问秦雍",
}

-- 95. 郭嘉
local g95 = General:new(extension, "wzzz__guojia", "wei", 3)
g95.title = "早终的先知"
g95.trueName = "郭嘉"
g95:addSkills { "wzzz_v__tiandu", "wzzz_v__ex__yiji" }
Fk:loadTranslationTable {
  ["wzzz__guojia"] = "郭嘉",
  ["#" .. "wzzz__guojia"] = "早终的先知",
}

-- 96. 郝昭
local g96 = General:new(extension, "wzzz__haozhao", "wei", 4)
g96.title = "扣弦的豪将"
g96.trueName = "郝昭"
g96:addSkills { "wzzz_v__zhengu" }
Fk:loadTranslationTable {
  ["wzzz__haozhao"] = "郝昭",
  ["#" .. "wzzz__haozhao"] = "扣弦的豪将",
}

-- 97. SP姜维
local g97 = General:new(extension, "wzzz_sp__sp_jiangwei", "wei", 4)
g97.title = "幼麒"
g97.trueName = "SP姜维"
g97:addSkills { "wzzz_v__kunfenEx", "wzzz_v__fengliang" }
g97:addRelatedSkills { "wzzz_v__m_ex__tiaoxin" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_jiangwei"] = "SP姜维",
  ["#" .. "wzzz_sp__sp_jiangwei"] = "幼麒",
}

-- 98. 蒋干
local g98 = General:new(extension, "wzzz__jianggan", "wei", 3)
g98.title = "锋镝悬信"
g98.trueName = "蒋干"
g98:addSkills { "wzzz_v__daoshu", "wzzz_v__weicheng", "wzzz_v__daizui" }
Fk:loadTranslationTable {
  ["wzzz__jianggan"] = "蒋干",
  ["#" .. "wzzz__jianggan"] = "锋镝悬信",
}

-- 99. 蒯越蒯良
local g99 = General:new(extension, "wzzz__kuaiyuekuailiang", "wei", 3)
g99.title = "雍论臼谋"
g99.trueName = "蒯越蒯良"
g99:addSkills { "wzzz_v__jianxiang", "wzzz_v__shenshi", "wzzz_v__m_heg__duoshi" }
Fk:loadTranslationTable {
  ["wzzz__kuaiyuekuailiang"] = "蒯越蒯良",
  ["#" .. "wzzz__kuaiyuekuailiang"] = "雍论臼谋",
}

-- 100. 李典
local g100 = General:new(extension, "wzzz__lidian", "wei", 3)
g100.title = "深明大义"
g100.trueName = "李典"
g100:addSkills { "wzzz_v__xunxun", "wzzz_v__ol_ex__wangxi" }
Fk:loadTranslationTable {
  ["wzzz__lidian"] = "李典",
  ["#" .. "wzzz__lidian"] = "深明大义",
}

-- 101. 鲁芝
local g101 = General:new(extension, "wzzz__luzhi", "wei", 3)
g101.title = "夷夏慕德"
g101.trueName = "鲁芝"
g101:addSkills { "wzzz_v__qingzhong", "wzzz_v__weijing" }
Fk:loadTranslationTable {
  ["wzzz__luzhi"] = "鲁芝",
  ["#" .. "wzzz__luzhi"] = "夷夏慕德",
}

-- 102. 满宠
local g102 = General:new(extension, "wzzz__manchong", "wei", 3)
g102.title = "政法兵谋"
g102.trueName = "满宠"
g102:addSkills { "wzzz_v__m_ex__junxing", "wzzz_v__yuce" }
Fk:loadTranslationTable {
  ["wzzz__manchong"] = "满宠",
  ["#" .. "wzzz__manchong"] = "政法兵谋",
}

-- 103. 毛玠
local g103 = General:new(extension, "wzzz__maojie", "wei", 3)
g103.title = "清公素履"
g103.trueName = "毛玠"
g103:addSkills { "wzzz_v__bingqing", "wzzz_v__ty__fengying" }
Fk:loadTranslationTable {
  ["wzzz__maojie"] = "毛玠",
  ["#" .. "wzzz__maojie"] = "清公素履",
}

-- 104. 牛金
local g104 = General:new(extension, "wzzz__niujin", "wei", 4)
g104.title = "独进的兵胆"
g104.trueName = "牛金"
g104:addSkills { "wzzz_v__ol__cuorui", "wzzz_v__ty__liewei" }
Fk:loadTranslationTable {
  ["wzzz__niujin"] = "牛金",
  ["#" .. "wzzz__niujin"] = "独进的兵胆",
}

-- 105. 司马朗
local g105 = General:new(extension, "wzzz__simalang", "wei", 3)
g105.title = "再世神农"
g105.trueName = "司马朗"
g105:addSkills { "wzzz_v__ty_ex__junbing", "wzzz_v__quji" }
Fk:loadTranslationTable {
  ["wzzz__simalang"] = "司马朗",
  ["#" .. "wzzz__simalang"] = "再世神农",
}

-- 106. 司马懿
local g106 = General:new(extension, "wzzz__simayi", "wei", 3)
g106.title = "狼顾之鬼"
g106.trueName = "司马懿"
g106:addSkills { "wzzz_v__guicai", "wzzz_v__ex__fankui" }
Fk:loadTranslationTable {
  ["wzzz__simayi"] = "司马懿",
  ["#" .. "wzzz__simayi"] = "狼顾之鬼",
}

-- 107. 王基
local g107 = General:new(extension, "wzzz__wangji", "wei", 3)
g107.title = "经行合一"
g107.trueName = "王基"
g107:addSkills { "wzzz_v__qizhi", "wzzz_v__jinqu" }
Fk:loadTranslationTable {
  ["wzzz__wangji"] = "王基",
  ["#" .. "wzzz__wangji"] = "经行合一",
}

-- 108. 王异
local g108 = General:new(extension, "wzzz__wangyi", "wei", 4, 4, General.Female)
g108.title = "决意的巾帼"
g108.trueName = "王异"
g108:addSkills { "wzzz_v__zhenlie", "wzzz_v__miji" }
Fk:loadTranslationTable {
  ["wzzz__wangyi"] = "王异",
  ["#" .. "wzzz__wangyi"] = "决意的巾帼",
}

-- 109. 文聘
local g109 = General:new(extension, "wzzz__wenpin", "wei", 5)
g109.title = "坚城宿将"
g109.trueName = "文聘"
g109:addSkills { "wzzz_v__tg__jiancheng", "wzzz_v__zhenwei" }
g109:addRelatedSkills { "wzzz__shouyu" }
Fk:loadTranslationTable {
  ["wzzz__wenpin"] = "文聘",
  ["#" .. "wzzz__wenpin"] = "坚城宿将",
}

-- 110. 戏志才
local g110 = General:new(extension, "wzzz__xizhicai", "wei", 3)
g110.title = "负俗的夭才"
g110.trueName = "戏志才"
g110:addSkills { "wzzz_v__tiandu", "wzzz_v__xianfu", "wzzz_v__chouce" }
Fk:loadTranslationTable {
  ["wzzz__xizhicai"] = "戏志才",
  ["#" .. "wzzz__xizhicai"] = "负俗的夭才",
}

-- 111. 夏侯惇
local g111 = General:new(extension, "wzzz__xiahoudun", "wei", 4)
g111.title = "独眼的罗刹"
g111.trueName = "夏侯惇"
g111:addSkills { "wzzz_v__ex__ganglie", "wzzz_v__ex__qingjian" }
Fk:loadTranslationTable {
  ["wzzz__xiahoudun"] = "夏侯惇",
  ["#" .. "wzzz__xiahoudun"] = "独眼的罗刹",
}

-- 112. 夏侯渊
local g112 = General:new(extension, "wzzz__xiahouyuan", "wei", 4)
g112.title = "疾行的猎豹"
g112.trueName = "夏侯渊"
g112:addSkills { "wzzz_v__shensu", "wzzz_v__shebian" }
Fk:loadTranslationTable {
  ["wzzz__xiahouyuan"] = "夏侯渊",
  ["#" .. "wzzz__xiahouyuan"] = "疾行的猎豹",
}

-- 113. 徐晃
local g113 = General:new(extension, "wzzz__xuhuang", "wei", 4)
g113.title = "周亚夫之风"
g113.trueName = "徐晃"
g113:addSkills { "wzzz_v__m_ex__duanliang", "wzzz_v__m_ex__jiezi" }
Fk:loadTranslationTable {
  ["wzzz__xuhuang"] = "徐晃",
  ["#" .. "wzzz__xuhuang"] = "周亚夫之风",
}

-- 114. 许褚
local g114 = General:new(extension, "wzzz__xuchu", "wei", 4)
g114.title = "虎痴，血战禁将"
g114.trueName = "许褚"
g114:addSkills { "wzzz_v__ex__luoyi", "wzzz_v__v11__xiechan" }
Fk:loadTranslationTable {
  ["wzzz__xuchu"] = "许褚",
  ["#" .. "wzzz__xuchu"] = "虎痴，血战禁将",
}

-- 115. 荀攸
local g115 = General:new(extension, "wzzz__xunyou", "wei", 3)
g115.title = "曹魏的谋主"
g115.trueName = "荀攸"
g115:addSkills { "wzzz_v__qice", "wzzz_v__ty_ex__zhiyu" }
Fk:loadTranslationTable {
  ["wzzz__xunyou"] = "荀攸",
  ["#" .. "wzzz__xunyou"] = "曹魏的谋主",
}

-- 116. 荀彧
local g116 = General:new(extension, "wzzz__xunyu", "wei", 3)
g116.title = "王佐之才"
g116.trueName = "荀彧"
g116:addSkills { "wzzz_v__quhu", "wzzz_v__ol_ex__jieming" }
Fk:loadTranslationTable {
  ["wzzz__xunyu"] = "荀彧",
  ["#" .. "wzzz__xunyu"] = "王佐之才",
}

-- 117. 阎柔
local g117 = General:new(extension, "wzzz__yanrou", "wei", 4)
g117.title = "冠玉啸北"
g117.trueName = "阎柔"
g117:addSkills { "wzzz_v__choutao", "wzzz_v__xiangshu" }
Fk:loadTranslationTable {
  ["wzzz__yanrou"] = "阎柔",
  ["#" .. "wzzz__yanrou"] = "冠玉啸北",
}

-- 118. 张春华
local g118 = General:new(extension, "wzzz__zhangchunhua", "wei", 3, 3, General.Female)
g118.title = "冷血皇后"
g118.trueName = "张春华"
g118:addSkills { "wzzz_v__ty_ex__jueqing", "wzzz_v__shangshi", "wzzz_v__jianmie" }
Fk:loadTranslationTable {
  ["wzzz__zhangchunhua"] = "张春华",
  ["#" .. "wzzz__zhangchunhua"] = "冷血皇后",
}

-- 119. 张辽
local g119 = General:new(extension, "wzzz__zhangliao", "wei", 4)
g119.title = "前将军"
g119.trueName = "张辽"
g119:addSkills { "wzzz_v__tuxi" }
Fk:loadTranslationTable {
  ["wzzz__zhangliao"] = "张辽",
  ["#" .. "wzzz__zhangliao"] = "前将军",
}

-- 120. 甄姬
local g120 = General:new(extension, "wzzz__zhenji", "wei", 3, 3, General.Female)
g120.title = "薄幸的美人"
g120.trueName = "甄姬"
g120:addSkills { "wzzz_v__ex__luoshen", "wzzz_v__qingguo" }
Fk:loadTranslationTable {
  ["wzzz__zhenji"] = "甄姬",
  ["#" .. "wzzz__zhenji"] = "薄幸的美人",
}

-- 121. 钟会
local g121 = General:new(extension, "wzzz__zhonghui", "wei", 4)
g121.title = "桀骜的野心家"
g121.trueName = "钟会"
g121:addSkills { "wzzz_v__m_ex__quanji", "wzzz_v__zili" }
g121:addRelatedSkills { "wzzz_v__m_ex__paiyi" }
Fk:loadTranslationTable {
  ["wzzz__zhonghui"] = "钟会",
  ["#" .. "wzzz__zhonghui"] = "桀骜的野心家",
}

-- 122. 钟繇
local g122 = General:new(extension, "wzzz__zhongyao", "wei", 3)
g122.title = "正楷萧曹"
g122.trueName = "钟繇"
g122:addSkills { "wzzz_v__huomo", "wzzz_v__zuoding" }
Fk:loadTranslationTable {
  ["wzzz__zhongyao"] = "钟繇",
  ["#" .. "wzzz__zhongyao"] = "正楷萧曹",
}

-- 123. 朱灵
local g123 = General:new(extension, "wzzz__zhuling", "wei", 4)
g123.title = "良将之亚"
g123.trueName = "朱灵"
g123:addSkills { "wzzz_v__jixian" }
Fk:loadTranslationTable {
  ["wzzz__zhuling"] = "朱灵",
  ["#" .. "wzzz__zhuling"] = "良将之亚",
}

-- 124. 诸葛诞
local g124 = General:new(extension, "wzzz__zhugedan", "wei", 4)
g124.title = "薤露蒿里，血战禁将"
g124.trueName = "诸葛诞"
g124:addSkills { "wzzz_v__ty_ex__gongao", "wzzz_v__ty_ex__juyi" }
g124:addRelatedSkills { "wzzz_v__weizhong", "wzzz_v__benghuai" }
Fk:loadTranslationTable {
  ["wzzz__zhugedan"] = "诸葛诞",
  ["#" .. "wzzz__zhugedan"] = "薤露蒿里，血战禁将",
}

-- 125. 蔡夫人
local g125 = General:new(extension, "wzzz__caifuren", "qun", 3, 3, General.Female)
g125.title = "襄江的蒲苇"
g125.trueName = "蔡夫人"
g125:addSkills { "wzzz_v__ol_ex__qieting", "wzzz_v__xianzhou" }
Fk:loadTranslationTable {
  ["wzzz__caifuren"] = "蔡夫人",
  ["#" .. "wzzz__caifuren"] = "襄江的蒲苇",
}

-- 126. SP蔡文姬
local g126 = General:new(extension, "wzzz_sp__sp_caiwenji", "qun", 3, 3, General.Female)
g126.title = "金璧之才"
g126.trueName = "SP蔡文姬"
g126:addSkills { "wzzz__beijia", "wzzz_v__mozhi", "wzzz_v__chenqing", "wzzz_v__duanchang" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_caiwenji"] = "SP蔡文姬",
  ["#" .. "wzzz_sp__sp_caiwenji"] = "金璧之才",
}

-- 127. 陈宫
local g127 = General:new(extension, "wzzz__chengong", "qun", 3)
g127.title = "刚直壮烈"
g127.trueName = "陈宫"
g127:addSkills { "wzzz_v__ty_ex__mingce", "wzzz_v__zhichi" }
Fk:loadTranslationTable {
  ["wzzz__chengong"] = "陈宫",
  ["#" .. "wzzz__chengong"] = "刚直壮烈",
}

-- 128. 貂蝉
local g128 = General:new(extension, "wzzz__diaochan", "qun", 3, 3, General.Female)
g128.title = "绝世的舞姬"
g128.trueName = "貂蝉"
g128:addSkills { "wzzz_v__qingshic", "wzzz_v__lijian", "wzzz_v__lihun", "wzzz_v__ex__biyue" }
Fk:loadTranslationTable {
  ["wzzz__diaochan"] = "貂蝉",
  ["#" .. "wzzz__diaochan"] = "绝世的舞姬",
}

-- 129. 丁原
local g129 = General:new(extension, "wzzz__dingyuan", "qun", 4)
g129.title = "养虎为患"
g129.trueName = "丁原"
g129:addSkills { "wzzz_v__cixiao", "wzzz_v__xianshuai" }
g129:addRelatedSkills { "wzzz_v__panshi" }
Fk:loadTranslationTable {
  ["wzzz__dingyuan"] = "丁原",
  ["#" .. "wzzz__dingyuan"] = "养虎为患",
}

-- 130. 董卓
local g130 = General:new(extension, "wzzz__dongzhuo", "qun", 8)
g130.title = "魔王"
g130.trueName = "董卓"
g130:addSkills { "wzzz_v__ol_ex__jiuchi", "wzzz_v__roulin", "wzzz_v__benghuai" }
Fk:loadTranslationTable {
  ["wzzz__dongzhuo"] = "董卓",
  ["#" .. "wzzz__dongzhuo"] = "魔王",
}

-- 131. 杜预
local g131 = General:new(extension, "wzzz__duyu", "qun", 4)
g131.title = "文成武德"
g131.trueName = "杜预"
g131:addSkills { "wzzz_v__sanchen" }
g131:addRelatedSkills { "wzzz_v__pozhu" }
Fk:loadTranslationTable {
  ["wzzz__duyu"] = "杜预",
  ["#" .. "wzzz__duyu"] = "文成武德",
}

-- 132. 伏完
local g132 = General:new(extension, "wzzz__fuwan", "qun", 4)
g132.title = "沉毅的国丈"
g132.trueName = "伏完"
g132:addSkills { "wzzz_v__ty__moukui" }
Fk:loadTranslationTable {
  ["wzzz__fuwan"] = "伏完",
  ["#" .. "wzzz__fuwan"] = "沉毅的国丈",
}

-- 133. 高览
local g133 = General:new(extension, "wzzz__gaolan", "qun", 4)
g133.title = "绝击坚营"
g133.trueName = "高览"
g133:addSkills { "wzzz_v__jungong", "wzzz_v__dengli" }
Fk:loadTranslationTable {
  ["wzzz__gaolan"] = "高览",
  ["#" .. "wzzz__gaolan"] = "绝击坚营",
}

-- 134. 高顺
local g134 = General:new(extension, "wzzz__gaoshun", "qun", 4)
g134.title = "攻无不克"
g134.trueName = "高顺"
g134:addSkills { "wzzz_v__ty_ex__xianzhen", "wzzz_v__ty_ex__jinjiu" }
Fk:loadTranslationTable {
  ["wzzz__gaoshun"] = "高顺",
  ["#" .. "wzzz__gaoshun"] = "攻无不克",
}

-- 135. 公孙渊
local g135 = General:new(extension, "wzzz__gongsunyuan", "qun", 4)
g135.title = "狡徒悬海"
g135.trueName = "公孙渊"
g135:addSkills { "wzzz_v__huaiyi" }
Fk:loadTranslationTable {
  ["wzzz__gongsunyuan"] = "公孙渊",
  ["#" .. "wzzz__gongsunyuan"] = "狡徒悬海",
}

-- 136. 公孙瓒
local g136 = General:new(extension, "wzzz__gongsunzan", "qun", 4)
g136.title = "白马将军"
g136.trueName = "公孙瓒"
g136:addSkills { "wzzz_v__ty_ex__yicong", "wzzz_v__ty_ex__qiaomeng" }
Fk:loadTranslationTable {
  ["wzzz__gongsunzan"] = "公孙瓒",
  ["#" .. "wzzz__gongsunzan"] = "白马将军",
}

-- 137. 郭图逄纪
local g137 = General:new(extension, "wzzz__guotupangji", "qun", 3)
g137.title = "凶蛇两端"
g137.trueName = "郭图逄纪"
g137:addSkills { "wzzz_v__ty_ex__jigong", "wzzz_v__shifei" }
Fk:loadTranslationTable {
  ["wzzz__guotupangji"] = "郭图逄纪",
  ["#" .. "wzzz__guotupangji"] = "凶蛇两端",
}

-- 138. 韩遂
local g138 = General:new(extension, "wzzz__hansui", "qun", 4)
g138.title = "雄踞北疆"
g138.trueName = "韩遂"
g138:addSkills { "wzzz_v__ty__niluan", "wzzz_v__weiwu", "wzzz_v__mobile__xiaoxi" }
Fk:loadTranslationTable {
  ["wzzz__hansui"] = "韩遂",
  ["#" .. "wzzz__hansui"] = "雄踞北疆",
}

-- 139. 何进
local g139 = General:new(extension, "wzzz__hejin", "qun", 4)
g139.title = "色厉内荏，血战禁将"
g139.trueName = "何进"
g139:addSkills { "wzzz_v__ty__mouzhu", "wzzz_v__ol__yanhuo" }
Fk:loadTranslationTable {
  ["wzzz__hejin"] = "何进",
  ["#" .. "wzzz__hejin"] = "色厉内荏，血战禁将",
}

-- 140. 华佗
local g140 = General:new(extension, "wzzz__huatuo", "qun", 3)
g140.title = "神医，血战禁将"
g140.trueName = "华佗"
g140:addSkills { "wzzz_v__jishi", "wzzz_v__ex__chuli", "wzzz_v__m_ex__qingnang", "wzzz_s__6025_6551" }
Fk:loadTranslationTable {
  ["wzzz__huatuo"] = "华佗",
  ["#" .. "wzzz__huatuo"] = "神医，血战禁将",
}

-- 141. 华雄
local g141 = General:new(extension, "wzzz__huaxiong", "qun", 6)
g141.title = "魔将"
g141.trueName = "华雄"
g141:addSkills { "wzzz_v__ol_ex__yaowu", "wzzz_v__shizhan" }
Fk:loadTranslationTable {
  ["wzzz__huaxiong"] = "华雄",
  ["#" .. "wzzz__huaxiong"] = "魔将",
}

-- 142. 贾诩
local g142 = General:new(extension, "wzzz__jiaxu", "qun", 3)
g142.title = "冷酷的毒士"
g142.trueName = "贾诩"
g142:addSkills { "wzzz_v__ol_ex__wansha", "wzzz_v__mou__luanwu", "wzzz_v__ol_ex__weimu" }
Fk:loadTranslationTable {
  ["wzzz__jiaxu"] = "贾诩",
  ["#" .. "wzzz__jiaxu"] = "冷酷的毒士",
}

-- 143. 沮授
local g143 = General:new(extension, "wzzz__jushou", "qun", 3)
g143.title = "监军谋国"
g143.trueName = "沮授"
g143:addSkills { "wzzz_v__m_ex__jianying", "wzzz_v__ty_ex__shibei" }
Fk:loadTranslationTable {
  ["wzzz__jushou"] = "沮授",
  ["#" .. "wzzz__jushou"] = "监军谋国",
}

-- 144. 李傕
local g144 = General:new(extension, "wzzz__lijue", "qun", 4, 6)
g144.title = "奸谋恶勇"
g144.trueName = "李傕"
g144:addSkills { "wzzz_v__langxi", "wzzz_v__xh__yisuan" }
Fk:loadTranslationTable {
  ["wzzz__lijue"] = "李傕",
  ["#" .. "wzzz__lijue"] = "奸谋恶勇",
}

-- 145. 李儒
local g145 = General:new(extension, "wzzz__liru", "qun", 3)
g145.title = "魔仕"
g145.trueName = "李儒"
g145:addSkills { "wzzz_v__juece", "wzzz_v__m_ex__mieji", "wzzz_v__fencheng" }
Fk:loadTranslationTable {
  ["wzzz__liru"] = "李儒",
  ["#" .. "wzzz__liru"] = "魔仕",
}

-- 146. 刘辩
local g146 = General:new(extension, "wzzz__liubian", "qun", 3)
g146.title = "弘农怀王"
g146.trueName = "刘辩"
g146:addSkills { "wzzz_v__shiyuan", "wzzz_v__dushi" }
Fk:loadTranslationTable {
  ["wzzz__liubian"] = "刘辩",
  ["#" .. "wzzz__liubian"] = "弘农怀王",
}

-- 147. 刘琦
local g147 = General:new(extension, "wzzz__liuqi", "qun", 3)
g147.title = "居外而安"
g147.trueName = "刘琦"
g147:addSkills { "wzzz_v__wenji", "wzzz_v__tunjiang" }
Fk:loadTranslationTable {
  ["wzzz__liuqi"] = "刘琦",
  ["#" .. "wzzz__liuqi"] = "居外而安",
}

-- 148. 刘协
local g148 = General:new(extension, "wzzz__liuxie", "qun", 3)
g148.title = "真命天子"
g148.trueName = "刘协"
g148:addSkills { "wzzz_v__tianming", "wzzz_v__mizhao" }
Fk:loadTranslationTable {
  ["wzzz__liuxie"] = "刘协",
  ["#" .. "wzzz__liuxie"] = "真命天子",
}

-- 149. 刘焉
local g149 = General:new(extension, "wzzz__liuyan", "qun", 3)
g149.title = "裂土之宗"
g149.trueName = "刘焉"
g149:addSkills { "wzzz_v__tushe", "wzzz_v__limu" }
Fk:loadTranslationTable {
  ["wzzz__liuyan"] = "刘焉",
  ["#" .. "wzzz__liuyan"] = "裂土之宗",
}

-- 150. 吕布
local g150 = General:new(extension, "wzzz__lvbu", "qun", 4)
g150.title = "武的化身"
g150.trueName = "吕布"
g150:addSkills { "wzzz_v__v33__zhanshen" }
Fk:loadTranslationTable {
  ["wzzz__lvbu"] = "吕布",
  ["#" .. "wzzz__lvbu"] = "武的化身",
}

-- 151. 吕布
local g151 = General:new(extension, "wzzz__lvbu_wushuang", "qun", 5)
g151.title = "最强神话"
g151.trueName = "吕布"
g151:addSkills { "wzzz_v__hs__wushuang", "wzzz_v__liyu", "wzzz__zhanshen_awaken" }
g151:addRelatedSkills { "wzzz_v__mashu", "wzzz_v__shenji" }
Fk:loadTranslationTable {
  ["wzzz__lvbu_wushuang"] = "吕布",
  ["#" .. "wzzz__lvbu_wushuang"] = "最强神话",
}

-- 152. SP马超
local g152 = General:new(extension, "wzzz_sp__sp_machao", "qun", 4)
g152.title = "西凉的猛狮"
g152.trueName = "SP马超"
g152:addSkills { "wzzz_v__ol__zhuiji", "wzzz_v__ol__shichou" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_machao"] = "SP马超",
  ["#" .. "wzzz_sp__sp_machao"] = "西凉的猛狮",
}

-- 153. 马腾
local g153 = General:new(extension, "wzzz__mateng", "qun", 4)
g153.title = "勇冠西州"
g153.trueName = "马腾"
g153:addSkills { "wzzz_v__mashu", "wzzz_v__xh__xiongyi" }
Fk:loadTranslationTable {
  ["wzzz__mateng"] = "马腾",
  ["#" .. "wzzz__mateng"] = "勇冠西州",
}

-- 154. 孟获
local g154 = General:new(extension, "wzzz__menghuo", "qun", 4)
g154.title = "南蛮王"
g154.trueName = "孟获"
g154:addSkills { "wzzz_v__huoshou", "wzzz_v__ofl_mou__zaiqi" }
Fk:loadTranslationTable {
  ["wzzz__menghuo"] = "孟获",
  ["#" .. "wzzz__menghuo"] = "南蛮王",
}

-- 155. 潘凤
local g155 = General:new(extension, "wzzz__panfeng", "qun", 4)
g155.title = "联军上将"
g155.trueName = "潘凤"
g155:addSkills { "wzzz_v__ty__kuangfu" }
Fk:loadTranslationTable {
  ["wzzz__panfeng"] = "潘凤",
  ["#" .. "wzzz__panfeng"] = "联军上将",
}

-- 156. 庞德公
local g156 = General:new(extension, "wzzz__pangdegong", "qun", 3)
g156.title = "德懿举世"
g156.trueName = "庞德公"
g156:addSkills { "wzzz_v__yinship", "wzzz_v__pingcai" }
Fk:loadTranslationTable {
  ["wzzz__pangdegong"] = "庞德公",
  ["#" .. "wzzz__pangdegong"] = "德懿举世",
}

-- 157. 麹义
local g157 = General:new(extension, "wzzz__quyi", "qun", 4)
g157.title = "名门的骁将"
g157.trueName = "麹义"
g157:addSkills { "wzzz_v__fuji", "wzzz_v__jiaozi" }
Fk:loadTranslationTable {
  ["wzzz__quyi"] = "麹义",
  ["#" .. "wzzz__quyi"] = "名门的骁将",
}

-- 158. SP孙策
local g158 = General:new(extension, "wzzz_sp__sp_sunce", "qun", 4)
g158.title = "壮武命世"
g158.trueName = "SP孙策"
g158:addSkills { "wzzz_v__liantao" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_sunce"] = "SP孙策",
  ["#" .. "wzzz_sp__sp_sunce"] = "壮武命世",
}

-- 159. 许攸
local g159 = General:new(extension, "wzzz__xuyou", "qun", 3)
g159.title = "朝秦暮楚"
g159.trueName = "许攸"
g159:addSkills { "wzzz_v__chenglue", "wzzz_v__shicai", "wzzz_v__cunmu" }
Fk:loadTranslationTable {
  ["wzzz__xuyou"] = "许攸",
  ["#" .. "wzzz__xuyou"] = "朝秦暮楚",
}

-- 160. 颜良文丑
local g160 = General:new(extension, "wzzz__yanliangwenchou", "qun", 4)
g160.title = "虎狼兄弟"
g160.trueName = "颜良文丑"
g160:addSkills { "wzzz_v__fhyx_ex__shuangxiong", "wzzz_v__fhyx_ex__xiayong" }
Fk:loadTranslationTable {
  ["wzzz__yanliangwenchou"] = "颜良文丑",
  ["#" .. "wzzz__yanliangwenchou"] = "虎狼兄弟",
}

-- 161. 于禁
local g161 = General:new(extension, "wzzz__yujin", "qun", 4)
g161.title = "讨暴坚垒"
g161.trueName = "于禁"
g161:addSkills { "wzzz_v__yizhong", "wzzz_v__ol_ex__zhenjun" }
Fk:loadTranslationTable {
  ["wzzz__yujin"] = "于禁",
  ["#" .. "wzzz__yujin"] = "讨暴坚垒",
}

-- 162. 袁绍
local g162 = General:new(extension, "wzzz__yuanshao", "qun", 4)
g162.title = "高贵的名门"
g162.trueName = "袁绍"
g162:addSkills { "wzzz_v__ofl_mou__luanji" }
Fk:loadTranslationTable {
  ["wzzz__yuanshao"] = "袁绍",
  ["#" .. "wzzz__yuanshao"] = "高贵的名门",
}

-- 163. 袁术
local g163 = General:new(extension, "wzzz__yuanshu", "qun", 4)
g163.title = "仲家帝，血战禁将"
g163.trueName = "袁术"
g163:addSkills { "wzzz_v__m_ex__yongsi", "wzzz_v__weidi" }
Fk:loadTranslationTable {
  ["wzzz__yuanshu"] = "袁术",
  ["#" .. "wzzz__yuanshu"] = "仲家帝，血战禁将",
}

-- 164. 张郃
local g164 = General:new(extension, "wzzz__zhanghe", "qun", 4)
g164.title = "料敌机先"
g164.trueName = "张郃"
g164:addSkills { "wzzz_v__ol_ex__qiaobian" }
Fk:loadTranslationTable {
  ["wzzz__zhanghe"] = "张郃",
  ["#" .. "wzzz__zhanghe"] = "料敌机先",
}

-- 165. 张角
local g165 = General:new(extension, "wzzz__zhangjiao", "qun", 3)
g165.title = "天公将军"
g165.trueName = "张角"
g165:addSkills { "wzzz_v__ol_ex__leiji", "wzzz_v__ol_ex__guidao" }
Fk:loadTranslationTable {
  ["wzzz__zhangjiao"] = "张角",
  ["#" .. "wzzz__zhangjiao"] = "天公将军",
}

-- 166. 张鲁
local g166 = General:new(extension, "wzzz__zhanglu", "qun", 3)
g166.title = "政宽教惠"
g166.trueName = "张鲁"
g166:addSkills { "wzzz_v__yishe", "wzzz_v__bushi", "wzzz_v__midao" }
Fk:loadTranslationTable {
  ["wzzz__zhanglu"] = "张鲁",
  ["#" .. "wzzz__zhanglu"] = "政宽教惠",
}

-- 167. SP赵云
local g167 = General:new(extension, "wzzz_sp__sp_zhaoyun", "qun", 3)
g167.title = "常山的游龙"
g167.trueName = "SP赵云"
g167:addSkills { "wzzz_v__ol_ex__longdan", "wzzz_v__chongzhen", "wzzz_v__jiuzhu" }
g167:addRelatedSkills { "wzzz_v__yajiao" }
Fk:loadTranslationTable {
  ["wzzz_sp__sp_zhaoyun"] = "SP赵云",
  ["#" .. "wzzz_sp__sp_zhaoyun"] = "常山的游龙",
}

-- 168. 左慈
local g168 = General:new(extension, "wzzz__zuoci", "qun", 3)
g168.title = "谜之仙人，血战禁将"
g168.trueName = "左慈"
g168:addSkills { "wzzz_v__huashen", "wzzz_v__xinsheng" }
Fk:loadTranslationTable {
  ["wzzz__zuoci"] = "左慈",
  ["#" .. "wzzz__zuoci"] = "谜之仙人，血战禁将",
}

return extension
