local extension = Package:new("wzzz_generals")
extension.extensionName = "wangzhezhizhan"
require("packages.wangzhezhizhan.pkg.load_skills")(extension)

Fk:loadTranslationTable {
  ["wzzz_generals"] = "非主公",
}

-- 11. SP 曹仁
local g11 = General:new(extension, "wzzz__sp_caoren", "wei", 4)
g11:addSkills { "wzzz_v__weikui", "wzzz_v__lizhan" }
Fk:loadTranslationTable {
  ["wzzz__sp_caoren"] = "SP 曹仁",
}

-- 12. 鲁芝
local g12 = General:new(extension, "wzzz__luzhi", "wei", 3)
g12:addSkills { "wzzz_v__qingzhong", "wzzz_v__weijing" }
Fk:loadTranslationTable {
  ["wzzz__luzhi"] = "鲁芝",
}

-- 13. 朱灵
local g13 = General:new(extension, "wzzz__zhuling", "wei", 4)
g13:addSkills { "wzzz_v__jixian" }
Fk:loadTranslationTable {
  ["wzzz__zhuling"] = "朱灵",
}

-- 14. 陈群
local g14 = General:new(extension, "wzzz__chenqun", "wei", 3)
g14:addSkills { "wzzz_v__ty_ex__pindi", "wzzz_v__faen" }
Fk:loadTranslationTable {
  ["wzzz__chenqun"] = "陈群",
}

-- 15. 李典
local g15 = General:new(extension, "wzzz__lidian", "wei", 3)
g15:addSkills { "wzzz_v__xunxun", "wzzz_v__ol_ex__wangxi" }
Fk:loadTranslationTable {
  ["wzzz__lidian"] = "李典",
}

-- 16. 典韦
local g16 = General:new(extension, "wzzz__dianwei", "wei", 4)
g16:addSkills { "wzzz_v__ol__qiangxi", "wzzz_v__ninge" }
Fk:loadTranslationTable {
  ["wzzz__dianwei"] = "典韦",
}

-- 17. 夏侯惇
local g17 = General:new(extension, "wzzz__xiahoudun", "wei", 4)
g17:addSkills { "wzzz_v__ex__ganglie", "wzzz_v__ex__qingjian" }
Fk:loadTranslationTable {
  ["wzzz__xiahoudun"] = "夏侯惇",
}

-- 18. 文聘
local g18 = General:new(extension, "wzzz__wenpin", "wei", 5)
g18:addSkills { "wzzz_v__tg__jiancheng", "wzzz_v__zhenwei" }
g18:addRelatedSkills { "wzzz__shouyu" }
Fk:loadTranslationTable {
  ["wzzz__wenpin"] = "文聘",
}

-- 19. 荀攸
local g19 = General:new(extension, "wzzz__xunyou", "wei", 3)
g19:addSkills { "wzzz_v__qice", "wzzz_v__ty_ex__zhiyu" }
Fk:loadTranslationTable {
  ["wzzz__xunyou"] = "荀攸",
}

-- 20. 蒋干
local g20 = General:new(extension, "wzzz__jianggan", "wei", 3)
g20:addSkills { "wzzz_v__daoshu", "wzzz_v__weicheng", "wzzz_v__daizui" }
Fk:loadTranslationTable {
  ["wzzz__jianggan"] = "蒋干",
}

-- 21. 张辽
local g21 = General:new(extension, "wzzz__zhangliao", "wei", 4)
g21:addSkills { "wzzz_v__tuxi" }
Fk:loadTranslationTable {
  ["wzzz__zhangliao"] = "张辽",
}

-- 22. 郭嘉
local g22 = General:new(extension, "wzzz__guojia", "wei", 3)
g22:addSkills { "wzzz_v__tiandu", "wzzz_v__ex__yiji" }
Fk:loadTranslationTable {
  ["wzzz__guojia"] = "郭嘉",
}

-- 23. 司马懿
local g23 = General:new(extension, "wzzz__simayi", "wei", 3)
g23:addSkills { "wzzz_v__guicai", "wzzz_v__ex__fankui" }
Fk:loadTranslationTable {
  ["wzzz__simayi"] = "司马懿",
}

-- 24. 荀彧
local g24 = General:new(extension, "wzzz__xunyu", "wei", 3)
g24:addSkills { "wzzz_v__quhu", "wzzz_v__ol_ex__jieming" }
Fk:loadTranslationTable {
  ["wzzz__xunyu"] = "荀彧",
}

-- 25. 曹昂
local g25 = General:new(extension, "wzzz__caoang", "wei", 4)
g25:addSkills { "wzzz_v__kangkai", "wzzz_v__vd_sheshen" }
Fk:loadTranslationTable {
  ["wzzz__caoang"] = "曹昂",
}

-- 26. 张春华
local g26 = General:new(extension, "wzzz__zhangchunhua", "wei", 3, 3, General.Female)
g26:addSkills { "wzzz_v__ty_ex__jueqing", "wzzz_v__shangshi", "wzzz_v__jianmie" }
Fk:loadTranslationTable {
  ["wzzz__zhangchunhua"] = "张春华",
}

-- 27. 徐晃
local g27 = General:new(extension, "wzzz__xuhuang", "wei", 4)
g27:addSkills { "wzzz_v__m_ex__duanliang", "wzzz_v__m_ex__jiezi" }
Fk:loadTranslationTable {
  ["wzzz__xuhuang"] = "徐晃",
}

-- 28. 阎柔
local g28 = General:new(extension, "wzzz__yanrou", "wei", 4)
g28:addSkills { "wzzz_v__choutao", "wzzz_v__xiangshu" }
Fk:loadTranslationTable {
  ["wzzz__yanrou"] = "阎柔",
}

-- 29. 郝昭
local g29 = General:new(extension, "wzzz__haozhao", "wei", 4)
g29:addSkills { "wzzz_v__zhengu" }
Fk:loadTranslationTable {
  ["wzzz__haozhao"] = "郝昭",
}

-- 30. 毛玠
local g30 = General:new(extension, "wzzz__maojie", "wei", 3)
g30:addSkills { "wzzz_v__bingqing", "wzzz_v__ty__fengying" }
Fk:loadTranslationTable {
  ["wzzz__maojie"] = "毛玠",
}

-- 31. 夏侯渊
local g31 = General:new(extension, "wzzz__xiahouyuan", "wei", 4)
g31:addSkills { "wzzz_v__shensu", "wzzz_v__shebian" }
Fk:loadTranslationTable {
  ["wzzz__xiahouyuan"] = "夏侯渊",
}

-- 32. 邓艾
local g32 = General:new(extension, "wzzz__dengai", "wei", 4)
g32:addSkills { "wzzz_v__ol_ex__tuntian", "wzzz_v__zaoxian" }
g32:addRelatedSkills { "wzzz_v__jixi" }
Fk:loadTranslationTable {
  ["wzzz__dengai"] = "邓艾",
}

-- 33. 王基
local g33 = General:new(extension, "wzzz__wangji", "wei", 3)
g33:addSkills { "wzzz_v__qizhi", "wzzz_v__jinqu" }
Fk:loadTranslationTable {
  ["wzzz__wangji"] = "王基",
}

-- 34. SP 姜维
local g34 = General:new(extension, "wzzz__sp_jiangwei", "wei", 4)
g34:addSkills { "wzzz_v__kunfenEx", "wzzz_v__fengliang" }
g34:addRelatedSkills { "wzzz_v__m_ex__tiaoxin" }
Fk:loadTranslationTable {
  ["wzzz__sp_jiangwei"] = "SP 姜维",
}

-- 35. 钟会
local g35 = General:new(extension, "wzzz__zhonghui", "wei", 4)
g35:addSkills { "wzzz_v__m_ex__quanji", "wzzz_v__zili" }
g35:addRelatedSkills { "wzzz_v__m_ex__paiyi" }
Fk:loadTranslationTable {
  ["wzzz__zhonghui"] = "钟会",
}

-- 36. 王异
local g36 = General:new(extension, "wzzz__wangyi", "wei", 4, 4, General.Female)
g36:addSkills { "wzzz_v__zhenlie", "wzzz_v__miji" }
Fk:loadTranslationTable {
  ["wzzz__wangyi"] = "王异",
}

-- 37. 曹冲
local g37 = General:new(extension, "wzzz__caochong", "wei", 3)
g37:addSkills { "wzzz_v__ty_ex__chengxiang", "wzzz_v__renxin" }
Fk:loadTranslationTable {
  ["wzzz__caochong"] = "曹冲",
}

-- 38. 甄姬
local g38 = General:new(extension, "wzzz__zhenji", "wei", 3, 3, General.Female)
g38:addSkills { "wzzz_v__ex__luoshen", "wzzz_v__qingguo" }
Fk:loadTranslationTable {
  ["wzzz__zhenji"] = "甄姬",
}

-- 39. 许褚
local g39 = General:new(extension, "wzzz__xuchu", "wei", 4)
g39:addSkills { "wzzz_v__ex__luoyi", "wzzz_v__v11__xiechan" }
Fk:loadTranslationTable {
  ["wzzz__xuchu"] = "许褚",
}

-- 40. 诸葛诞
local g40 = General:new(extension, "wzzz__zhugedan", "wei", 4)
g40:addSkills { "wzzz_v__ty_ex__gongao", "wzzz_v__ty_ex__juyi" }
g40:addRelatedSkills { "wzzz_v__weizhong", "wzzz_v__benghuai" }
Fk:loadTranslationTable {
  ["wzzz__zhugedan"] = "诸葛诞",
}

-- 41. 刘谌
local g41 = General:new(extension, "wzzz__liuchen", "shu", 4)
g41:addSkills { "wzzz_v__zhanjue", "wzzz_v__qinwang" }
Fk:loadTranslationTable {
  ["wzzz__liuchen"] = "刘谌",
}

-- 42. 庞统
local g42 = General:new(extension, "wzzz__pangtong", "shu", 3)
g42:addSkills { "wzzz_v__m_ex__lianhuan", "wzzz_v__niepan" }
g42:addRelatedSkills { "wzzz_v__bazhen", "wzzz_v__ol_ex__huoji", "wzzz_v__ol_ex__kanpo" }
Fk:loadTranslationTable {
  ["wzzz__pangtong"] = "庞统",
}

-- 43. 马超
local g43 = General:new(extension, "wzzz__machao", "shu", 4)
g43:addSkills { "wzzz_v__mashu", "wzzz_v__ex__tieji", "wzzz__jinzi" }
Fk:loadTranslationTable {
  ["wzzz__machao"] = "马超",
}

-- 44. 黄权
local g44 = General:new(extension, "wzzz__huangquan", "shu", 3)
g44:addSkills { "wzzz_v__choujin", "wzzz_v__jianji", "wzzz_v__tujue" }
Fk:loadTranslationTable {
  ["wzzz__huangquan"] = "黄权",
}

-- 45. 关兴&张苞
local g45 = General:new(extension, "wzzz__guanxingzhangbao", "shu", 4)
g45:addSkills { "wzzz_v__fuhun", "wzzz_v__ty_ex__tongxin" }
g45:addRelatedSkills { "wzzz_v__wusheng", "wzzz_v__mou__paoxiao" }
Fk:loadTranslationTable {
  ["wzzz__guanxingzhangbao"] = "关兴&张苞",
}

-- 46. 马谡
local g46 = General:new(extension, "wzzz__masu", "shu", 3)
g46:addSkills { "wzzz_v__ol__sanyao", "wzzz_v__ty_ex__zhiman", "wzzz_v__huilei" }
Fk:loadTranslationTable {
  ["wzzz__masu"] = "马谡",
}

-- 47. 夏侯氏
local g47 = General:new(extension, "wzzz__xiahoushi", "shu", 3, 3, General.Female)
g47:addSkills { "wzzz_v__qiaoshi", "wzzz_v__ty_ex__yanyu" }
Fk:loadTranslationTable {
  ["wzzz__xiahoushi"] = "夏侯氏",
}

-- 48. 张星彩
local g48 = General:new(extension, "wzzz__zhangxingcai", "shu", 3, 3, General.Female)
g48:addSkills { "wzzz_v__ol__shenxian", "wzzz_v__qiangwu" }
Fk:loadTranslationTable {
  ["wzzz__zhangxingcai"] = "张星彩",
}

-- 49. 祝融
local g49 = General:new(extension, "wzzz__zhurong", "shu", 4, 4, General.Female)
g49:addSkills { "wzzz_v__juxiang", "wzzz_v__os_ex__lieren", "wzzz_v__changbiao" }
Fk:loadTranslationTable {
  ["wzzz__zhurong"] = "祝融",
}

-- 50. 马良
local g50 = General:new(extension, "wzzz__maliang", "shu", 3)
g50:addSkills { "wzzz_v__mobile__zishu", "wzzz_v__yingyuan", "wzzz_v__sxfy__xiemu" }
Fk:loadTranslationTable {
  ["wzzz__maliang"] = "马良",
}

-- 51. 吴懿
local g51 = General:new(extension, "wzzz__wuyi", "shu", 4)
g51:addSkills { "wzzz_v__m_ex__benxi" }
Fk:loadTranslationTable {
  ["wzzz__wuyi"] = "吴懿",
}

-- 52. 夏侯霸
local g52 = General:new(extension, "wzzz__xiahouba", "shu", 4)
g52:addSkills { "wzzz_v__ty__baobian", "wzzz__baolie" }
g52:addRelatedSkills { "wzzz_v__ol_ex__tiaoxin", "wzzz_v__ex__paoxiao", "wzzz_v__shensu" }
Fk:loadTranslationTable {
  ["wzzz__xiahouba"] = "夏侯霸",
}

-- 53. 秦宓
local g53 = General:new(extension, "wzzz__qinmi", "shu", 3)
g53:addSkills { "wzzz_v__jianzhengq", "wzzz_v__zhuandui", "wzzz_v__tianbian" }
Fk:loadTranslationTable {
  ["wzzz__qinmi"] = "秦宓",
}

-- 54. 诸葛瞻
local g54 = General:new(extension, "wzzz__zhugezhan", "shu", 3)
g54:addSkills { "wzzz_v__zuilun", "wzzz_v__fuyin" }
Fk:loadTranslationTable {
  ["wzzz__zhugezhan"] = "诸葛瞻",
}

-- 55. 黄忠
local g55 = General:new(extension, "wzzz__huangzhong", "shu", 4)
g55:addSkills { "wzzz_v__ol_ex__liegong", "wzzz_v__yizhuang" }
Fk:loadTranslationTable {
  ["wzzz__huangzhong"] = "黄忠",
}

-- 56. 沙摩柯
local g56 = General:new(extension, "wzzz__shamoke", "shu", 4)
g56:addSkills { "wzzz_v__jilis" }
Fk:loadTranslationTable {
  ["wzzz__shamoke"] = "沙摩柯",
}

-- 57. 糜竺
local g57 = General:new(extension, "wzzz__mizhu", "shu", 3)
g57:addSkills { "wzzz_v__jugu", "wzzz_v__ziyuan" }
Fk:loadTranslationTable {
  ["wzzz__mizhu"] = "糜竺",
}

-- 58. 魏延
local g58 = General:new(extension, "wzzz__weiyan", "shu", 4)
g58:addSkills { "wzzz_v__m_shi__kuanggu", "wzzz_v__m_ex__qimou" }
Fk:loadTranslationTable {
  ["wzzz__weiyan"] = "魏延",
}

-- 59. 刘封
local g59 = General:new(extension, "wzzz__liufeng", "shu", 4)
g59:addSkills { "wzzz_v__ty_ex__xiansi" }
Fk:loadTranslationTable {
  ["wzzz__liufeng"] = "刘封",
}

-- 60. 张翼
local g60 = General:new(extension, "wzzz__zhangyi", "shu", 4)
g60:addSkills { "wzzz_v__zhiyi" }
Fk:loadTranslationTable {
  ["wzzz__zhangyi"] = "张翼",
}

-- 61. 姜维
local g61 = General:new(extension, "wzzz__jiangwei", "shu", 4)
g61:addSkills { "wzzz_v__ol_ex__tiaoxin", "wzzz_v__ol_ex__zhiji" }
g61:addRelatedSkills { "wzzz_v__ex__guanxing" }
Fk:loadTranslationTable {
  ["wzzz__jiangwei"] = "姜维",
}

-- 62. 董允
local g62 = General:new(extension, "wzzz__dongyun", "shu", 3)
g62:addSkills { "wzzz_v__sheyan", "wzzz_v__bingzheng" }
Fk:loadTranslationTable {
  ["wzzz__dongyun"] = "董允",
}

-- 63. 张飞
local g63 = General:new(extension, "wzzz__zhangfei", "shu", 4)
g63:addSkills { "wzzz_v__ex__paoxiao", "wzzz_v__ex__tishen" }
Fk:loadTranslationTable {
  ["wzzz__zhangfei"] = "张飞",
}

-- 64. 王平
local g64 = General:new(extension, "wzzz__wangping", "shu", 4)
g64:addSkills { "wzzz_v__feijun", "wzzz_v__binglue" }
Fk:loadTranslationTable {
  ["wzzz__wangping"] = "王平",
}

-- 65. 关羽
local g65 = General:new(extension, "wzzz__guanyu", "shu", 4)
g65:addSkills { "wzzz_v__v11__huwei", "wzzz_v__wusheng", "wzzz__qinglong", "wzzz_v__ex__yijue" }
g65:addRelatedSkills { "wzzz_v__zhongyi" }
Fk:loadTranslationTable {
  ["wzzz__guanyu"] = "关羽",
}

-- 66. 法正
local g66 = General:new(extension, "wzzz__fazheng", "shu", 3)
g66:addSkills { "wzzz_v__ol_ex__enyuan", "wzzz_v__ol_ex__xuanhuo" }
Fk:loadTranslationTable {
  ["wzzz__fazheng"] = "法正",
}

-- 67. 谯周
local g67 = General:new(extension, "wzzz__qiaozhou", "shu", 3)
g67:addSkills { "wzzz_v__os__zhiming", "wzzz_v__xingbu" }
Fk:loadTranslationTable {
  ["wzzz__qiaozhou"] = "谯周",
}

-- 68. 张松
local g68 = General:new(extension, "wzzz__zhangsong", "shu", 3)
g68:addSkills { "wzzz_v__xiantu", "wzzz_v__qiangzhi" }
Fk:loadTranslationTable {
  ["wzzz__zhangsong"] = "张松",
}

-- 69. 关平
local g69 = General:new(extension, "wzzz__guanping", "shu", 4)
g69:addSkills { "wzzz_v__ty_ex__longyin", "wzzz_v__ty_ex__jiezhong" }
Fk:loadTranslationTable {
  ["wzzz__guanping"] = "关平",
}

-- 70. 黄月英
local g70 = General:new(extension, "wzzz__huangyueying", "shu", 3, 3, General.Female)
g70:addSkills { "wzzz_v__ofl_mou__jizhi", "wzzz_v__qicai", "wzzz_v__ol__jiqiao" }
Fk:loadTranslationTable {
  ["wzzz__huangyueying"] = "黄月英",
}

-- 71. 丁奉
local g71 = General:new(extension, "wzzz__dingfeng", "wu", 4)
g71:addSkills { "wzzz_v__ol__duanbing", "wzzz_v__qshm__fenxun" }
Fk:loadTranslationTable {
  ["wzzz__dingfeng"] = "丁奉",
}

-- 72. 韩当
local g72 = General:new(extension, "wzzz__handang", "wu", 4)
g72:addSkills { "wzzz_v__gongqi", "wzzz_v__jiefan" }
Fk:loadTranslationTable {
  ["wzzz__handang"] = "韩当",
}

-- 73. 凌统
local g73 = General:new(extension, "wzzz__lingtong", "wu", 4)
g73:addSkills { "wzzz_v__m_ex__xuanfeng", "wzzz_v__ty_ex__yongjin" }
Fk:loadTranslationTable {
  ["wzzz__lingtong"] = "凌统",
}

-- 74. 诸葛瑾
local g74 = General:new(extension, "wzzz__zhugejin", "wu", 3)
g74:addSkills { "wzzz_v__huanshi", "wzzz_v__hongyuan", "wzzz_v__mingzhe" }
Fk:loadTranslationTable {
  ["wzzz__zhugejin"] = "诸葛瑾",
}

-- 75. SP 庞统
local g75 = General:new(extension, "wzzz__sp_pangtong", "wu", 3)
g75:addSkills { "wzzz_v__guolun", "wzzz_v__zhanji", "wzzz_v__qshm__songsang" }
Fk:loadTranslationTable {
  ["wzzz__sp_pangtong"] = "SP 庞统",
}

-- 76. 步练师
local g76 = General:new(extension, "wzzz__bulianshi", "wu", 3, 3, General.Female)
g76:addSkills { "wzzz_v__m_ex__anxu", "wzzz_v__zhuiyi" }
Fk:loadTranslationTable {
  ["wzzz__bulianshi"] = "步练师",
}

-- 77. 徐盛
local g77 = General:new(extension, "wzzz__xusheng", "wu", 4)
g77:addSkills { "wzzz_v__ty_ex__pojun", "wzzz_v__v33__yicheng" }
Fk:loadTranslationTable {
  ["wzzz__xusheng"] = "徐盛",
}

-- 78. 留赞
local g78 = General:new(extension, "wzzz__liuzan", "wu", 4)
g78:addSkills { "wzzz_v__sxfy__fenyin" }
Fk:loadTranslationTable {
  ["wzzz__liuzan"] = "留赞",
}

-- 79. 大乔
local g79 = General:new(extension, "wzzz__daqiao", "wu", 3, 3, General.Female)
g79:addSkills { "wzzz_v__ex__guose", "wzzz_v__mou__liuli", "wzzz__wanrong" }
Fk:loadTranslationTable {
  ["wzzz__daqiao"] = "大乔",
}

-- 80. 文鸯
local g80 = General:new(extension, "wzzz__wenyang", "wu", 4)
g80:addSkills { "wzzz_v__quedi", "wzzz_v__mobile__choujue", "wzzz_v__ofl__chongjian" }
Fk:loadTranslationTable {
  ["wzzz__wenyang"] = "文鸯",
}

-- 81. 岑昏
local g81 = General:new(extension, "wzzz__cenhun", "wu", 4)
g81:addSkills { "wzzz_v__jishe", "wzzz_v__lianhuo", "wzzz_v__sxfy__wudu" }
Fk:loadTranslationTable {
  ["wzzz__cenhun"] = "岑昏",
}

-- 82. 孙尚香
local g82 = General:new(extension, "wzzz__sunshangxiang", "wu", 3, 3, General.Female)
g82:addSkills { "wzzz__yuanding", "wzzz_v__jieyin", "wzzz_v__liangzhu", "wzzz_v__xiaoji" }
Fk:loadTranslationTable {
  ["wzzz__sunshangxiang"] = "孙尚香",
}

-- 83. 诸葛恪
local g83 = General:new(extension, "wzzz__zhugeke", "wu", 3)
g83:addSkills { "wzzz_v__duwu", "wzzz_v__ol__aocai" }
Fk:loadTranslationTable {
  ["wzzz__zhugeke"] = "诸葛恪",
}

-- 84. 朱桓
local g84 = General:new(extension, "wzzz__zhuhuan", "wu", 4)
g84:addSkills { "wzzz_v__fenli", "wzzz_v__pingkou" }
Fk:loadTranslationTable {
  ["wzzz__zhuhuan"] = "朱桓",
}

-- 85. 鲁肃
local g85 = General:new(extension, "wzzz__lusu", "wu", 3)
g85:addSkills { "wzzz_v__haoshi", "wzzz_v__ol_ex__dimeng" }
Fk:loadTranslationTable {
  ["wzzz__lusu"] = "鲁肃",
}

-- 86. 蒋钦
local g86 = General:new(extension, "wzzz__jiangqin", "wu", 4)
g86:addSkills { "wzzz_v__jianyi", "wzzz_v__mobile__shangyi" }
Fk:loadTranslationTable {
  ["wzzz__jiangqin"] = "蒋钦",
}

-- 87. 陆逊
local g87 = General:new(extension, "wzzz__luxun", "wu", 3)
g87:addSkills { "wzzz_v__ex__qianxun", "wzzz_v__ex__lianying", "wzzz__shunshi" }
Fk:loadTranslationTable {
  ["wzzz__luxun"] = "陆逊",
}

-- 88. 步骘
local g88 = General:new(extension, "wzzz__buzhi", "wu", 3)
g88:addSkills { "wzzz_v__hongde", "wzzz_v__dingpan" }
Fk:loadTranslationTable {
  ["wzzz__buzhi"] = "步骘",
}

-- 89. 甘宁
local g89 = General:new(extension, "wzzz__ganning", "wu", 4)
g89:addSkills { "wzzz_v__qixi", "wzzz_v__fenwei" }
Fk:loadTranslationTable {
  ["wzzz__ganning"] = "甘宁",
}

-- 90. 凌操
local g90 = General:new(extension, "wzzz__lingcao", "wu", 4, 5)
g90:addSkills { "wzzz_v__ol__dujin", "wzzz_v__dufeng" }
Fk:loadTranslationTable {
  ["wzzz__lingcao"] = "凌操",
}

-- 91. 黄盖
local g91 = General:new(extension, "wzzz__huanggai", "wu", 4)
g91:addSkills { "wzzz_v__ex__kurou", "wzzz_v__ol_ex__zhaxiang" }
Fk:loadTranslationTable {
  ["wzzz__huanggai"] = "黄盖",
}

-- 92. 孙茹
local g92 = General:new(extension, "wzzz__sunru", "wu", 3, 3, General.Female)
g92:addSkills { "wzzz_v__yingjian", "wzzz_v__shixin" }
Fk:loadTranslationTable {
  ["wzzz__sunru"] = "孙茹",
}

-- 93. 周鲂
local g93 = General:new(extension, "wzzz__zhoufang", "wu", 3)
g93:addSkills { "wzzz_v__duanfa", "wzzz_v__sp__youdi" }
Fk:loadTranslationTable {
  ["wzzz__zhoufang"] = "周鲂",
}

-- 94. 太史慈
local g94 = General:new(extension, "wzzz__taishici", "wu", 4)
g94:addSkills { "wzzz_v__tianyi", "wzzz_v__hanzhan" }
Fk:loadTranslationTable {
  ["wzzz__taishici"] = "太史慈",
}

-- 95. 吕蒙
local g95 = General:new(extension, "wzzz__lvmeng", "wu", 4)
g95:addSkills { "wzzz_v__keji", "wzzz_v__ol_ex__qinxue", "wzzz_v__botu" }
g95:addRelatedSkills { "wzzz_v__gundam__gongxin" }
Fk:loadTranslationTable {
  ["wzzz__lvmeng"] = "吕蒙",
}

-- 96. 唐咨
local g96 = General:new(extension, "wzzz__tangzi", "wu", 4)
g96:addSkills { "wzzz_v__xingzhao", "wzzz_v__xunxun" }
Fk:loadTranslationTable {
  ["wzzz__tangzi"] = "唐咨",
}

-- 97. 周瑜
local g97 = General:new(extension, "wzzz__zhouyu", "wu", 3)
g97:addSkills { "wzzz_v__ex__yingzi", "wzzz_v__wzzz__fanjian" }
Fk:loadTranslationTable {
  ["wzzz__zhouyu"] = "周瑜",
}

-- 98. 张昭&张纮
local g98 = General:new(extension, "wzzz__zhangzhaozhanghong", "wu", 3)
g98:addSkills { "wzzz_v__ol_ex__zhijian", "wzzz_v__guzheng" }
Fk:loadTranslationTable {
  ["wzzz__zhangzhaozhanghong"] = "张昭&张纮",
}

-- 99. 李儒
local g99 = General:new(extension, "wzzz__liru", "qun", 3)
g99:addSkills { "wzzz_v__juece", "wzzz_v__m_ex__mieji", "wzzz_v__fencheng" }
Fk:loadTranslationTable {
  ["wzzz__liru"] = "李儒",
}

-- 100. 华雄
local g100 = General:new(extension, "wzzz__huaxiong", "qun", 6)
g100:addSkills { "wzzz_v__ol_ex__yaowu", "wzzz_v__shizhan" }
Fk:loadTranslationTable {
  ["wzzz__huaxiong"] = "华雄",
}

-- 101. 高顺
local g101 = General:new(extension, "wzzz__gaoshun", "qun", 4)
g101:addSkills { "wzzz_v__ty_ex__xianzhen", "wzzz_v__ty_ex__jinjiu" }
Fk:loadTranslationTable {
  ["wzzz__gaoshun"] = "高顺",
}

-- 102. 张郃
local g102 = General:new(extension, "wzzz__zhanghe", "qun", 4)
g102:addSkills { "wzzz_v__ol_ex__qiaobian" }
Fk:loadTranslationTable {
  ["wzzz__zhanghe"] = "张郃",
}

-- 103. 公孙渊
local g103 = General:new(extension, "wzzz__gongsunyuan", "qun", 4)
g103:addSkills { "wzzz_v__huaiyi" }
Fk:loadTranslationTable {
  ["wzzz__gongsunyuan"] = "公孙渊",
}

-- 104. SP 蔡文姬
local g104 = General:new(extension, "wzzz__sp_caiwenji", "qun", 3, 3, General.Female)
g104:addSkills { "wzzz__beijia", "wzzz_v__mozhi", "wzzz_v__chenqing", "wzzz_v__duanchang" }
Fk:loadTranslationTable {
  ["wzzz__sp_caiwenji"] = "SP 蔡文姬",
}

-- 105. 于禁
local g105 = General:new(extension, "wzzz__yujin", "qun", 4)
g105:addSkills { "wzzz_v__yizhong", "wzzz_v__ol_ex__zhenjun" }
Fk:loadTranslationTable {
  ["wzzz__yujin"] = "于禁",
}

-- 106. 韩遂
local g106 = General:new(extension, "wzzz__hansui", "qun", 4)
g106:addSkills { "wzzz_v__ty__niluan", "wzzz_v__weiwu", "wzzz_v__mobile__xiaoxi" }
Fk:loadTranslationTable {
  ["wzzz__hansui"] = "韩遂",
}

-- 107. 马腾
local g107 = General:new(extension, "wzzz__mateng", "qun", 4)
g107:addSkills { "wzzz_v__mashu", "wzzz_v__xh__xiongyi" }
Fk:loadTranslationTable {
  ["wzzz__mateng"] = "马腾",
}

-- 108. 杜预
local g108 = General:new(extension, "wzzz__duyu", "qun", 3)
g108:addSkills { "wzzz_v__sanchen" }
g108:addRelatedSkills { "wzzz_v__pozhu" }
Fk:loadTranslationTable {
  ["wzzz__duyu"] = "杜预",
}

-- 109. 麴义
local g109 = General:new(extension, "wzzz__quyi", "qun", 4)
g109:addSkills { "wzzz_v__fuji", "wzzz_v__jiaozi" }
Fk:loadTranslationTable {
  ["wzzz__quyi"] = "麴义",
}

-- 110. 陈宫
local g110 = General:new(extension, "wzzz__chengong", "qun", 3)
g110:addSkills { "wzzz_v__ty_ex__mingce", "wzzz_v__zhichi" }
Fk:loadTranslationTable {
  ["wzzz__chengong"] = "陈宫",
}

-- 111. 沮授
local g111 = General:new(extension, "wzzz__jushou", "qun", 3)
g111:addSkills { "wzzz_v__m_ex__jianying", "wzzz_v__ty_ex__shibei" }
Fk:loadTranslationTable {
  ["wzzz__jushou"] = "沮授",
}

-- 112. SP 孙策
local g112 = General:new(extension, "wzzz__sp_sunce", "qun", 4)
g112:addSkills { "wzzz_v__liantao" }
Fk:loadTranslationTable {
  ["wzzz__sp_sunce"] = "SP 孙策",
}

-- 113. 吕布
local g113 = General:new(extension, "wzzz__lvbu", "qun", 4)
g113:addSkills { "wzzz_v__v33__zhanshen" }
Fk:loadTranslationTable {
  ["wzzz__lvbu"] = "吕布",
}

-- 114. 贾诩
local g114 = General:new(extension, "wzzz__jiaxu", "qun", 3)
g114:addSkills { "wzzz_v__ol_ex__wansha", "wzzz_v__mou__luanwu", "wzzz_v__ol_ex__weimu" }
Fk:loadTranslationTable {
  ["wzzz__jiaxu"] = "贾诩",
}

-- 115. 貂蝉
local g115 = General:new(extension, "wzzz__diaochan", "qun", 3, 3, General.Female)
g115:addSkills { "wzzz_v__qingshic", "wzzz_v__lijian", "wzzz_v__lihun", "wzzz_v__ex__biyue" }
Fk:loadTranslationTable {
  ["wzzz__diaochan"] = "貂蝉",
}

-- 116. SP 马超
local g116 = General:new(extension, "wzzz__sp_machao", "qun", 4)
g116:addSkills { "wzzz_v__ol__zhuiji", "wzzz_v__ol__shichou" }
Fk:loadTranslationTable {
  ["wzzz__sp_machao"] = "SP 马超",
}

-- 117. 庞德公
local g117 = General:new(extension, "wzzz__pangdegong", "qun", 3)
g117:addSkills { "wzzz_v__yinship", "wzzz_v__pingcai" }
Fk:loadTranslationTable {
  ["wzzz__pangdegong"] = "庞德公",
}

-- 118. 伏完
local g118 = General:new(extension, "wzzz__fuwan", "qun", 4)
g118:addSkills { "wzzz_v__ty__moukui" }
Fk:loadTranslationTable {
  ["wzzz__fuwan"] = "伏完",
}

-- 119. 高览
local g119 = General:new(extension, "wzzz__gaolan", "qun", 4)
g119:addSkills { "wzzz_v__jungong", "wzzz_v__dengli" }
Fk:loadTranslationTable {
  ["wzzz__gaolan"] = "高览",
}

-- 120. SP 赵云
local g120 = General:new(extension, "wzzz__sp_zhaoyun", "qun", 3)
g120:addSkills { "wzzz_v__ol_ex__longdan", "wzzz_v__chongzhen", "wzzz_v__jiuzhu" }
g120:addRelatedSkills { "wzzz_v__yajiao" }
Fk:loadTranslationTable {
  ["wzzz__sp_zhaoyun"] = "SP 赵云",
}

-- 121. 李傕
local g121 = General:new(extension, "wzzz__lijue", "qun", 4, 6)
g121:addSkills { "wzzz_v__langxi", "wzzz_v__xh__yisuan" }
Fk:loadTranslationTable {
  ["wzzz__lijue"] = "李傕",
}

-- 122. 袁术
local g122 = General:new(extension, "wzzz__yuanshu", "qun", 4)
g122:addSkills { "wzzz_v__m_ex__yongsi", "wzzz_v__weidi" }
Fk:loadTranslationTable {
  ["wzzz__yuanshu"] = "袁术",
}

-- 123. 刘辩
local g123 = General:new(extension, "wzzz__liubian", "qun", 3)
g123:addSkills { "wzzz_v__shiyuan", "wzzz_v__dushi" }
Fk:loadTranslationTable {
  ["wzzz__liubian"] = "刘辩",
}

-- 124. 袁绍
local g124 = General:new(extension, "wzzz__yuanshao", "qun", 4)
g124:addSkills { "wzzz_v__ofl_mou__luanji" }
Fk:loadTranslationTable {
  ["wzzz__yuanshao"] = "袁绍",
}

-- 125. 刘琦
local g125 = General:new(extension, "wzzz__liuqi", "qun", 3)
g125:addSkills { "wzzz_v__wenji", "wzzz_v__tunjiang" }
Fk:loadTranslationTable {
  ["wzzz__liuqi"] = "刘琦",
}

-- 126. 左慈
local g126 = General:new(extension, "wzzz__zuoci", "qun", 3)
g126:addSkills { "wzzz_v__huashen", "wzzz_v__xinsheng" }
Fk:loadTranslationTable {
  ["wzzz__zuoci"] = "左慈",
}

-- 127. 孟获
local g127 = General:new(extension, "wzzz__menghuo", "qun", 4)
g127:addSkills { "wzzz_v__huoshou", "wzzz_v__ofl_mou__zaiqi" }
Fk:loadTranslationTable {
  ["wzzz__menghuo"] = "孟获",
}

-- 128. 公孙瓒
local g128 = General:new(extension, "wzzz__gongsunzan", "qun", 4)
g128:addSkills { "wzzz_v__ty_ex__yicong", "wzzz_v__ty_ex__qiaomeng" }
Fk:loadTranslationTable {
  ["wzzz__gongsunzan"] = "公孙瓒",
}

-- 129. 潘凤
local g129 = General:new(extension, "wzzz__panfeng", "qun", 4)
g129:addSkills { "wzzz_v__ty__kuangfu" }
Fk:loadTranslationTable {
  ["wzzz__panfeng"] = "潘凤",
}

-- 130. 曹操
local g130 = General:new(extension, "wzzz__caocao", "wei", 4)
g130:addSkills { "wzzz__shuzhi", "wzzz_v__ex__jianxiong", "wzzz_v__mou__qingzheng" }
Fk:loadTranslationTable {
  ["wzzz__caocao"] = "曹操",
}

-- 131. 曹叡
local g131 = General:new(extension, "wzzz__caorui", "wei", 3)
g131:addSkills { "wzzz_v__ty_ex__mingjian", "wzzz_v__huituo" }
Fk:loadTranslationTable {
  ["wzzz__caorui"] = "曹叡",
}

-- 132. 刘备
local g132 = General:new(extension, "wzzz__liubei", "shu", 4)
g132:addSkills { "wzzz_v__ex__rende", "wzzz_v__v11__renwang" }
Fk:loadTranslationTable {
  ["wzzz__liubei"] = "刘备",
}

-- 133. 刘禅
local g133 = General:new(extension, "wzzz__liushan", "shu", 3)
g133:addSkills { "wzzz_v__xiangle", "wzzz_v__m_ex__fangquan" }
Fk:loadTranslationTable {
  ["wzzz__liushan"] = "刘禅",
}

-- 134. 孙皓
local g134 = General:new(extension, "wzzz__sunhao", "wu", 5)
g134:addSkills { "wzzz_v__ol__canshi", "wzzz_v__chouhai" }
Fk:loadTranslationTable {
  ["wzzz__sunhao"] = "孙皓",
}

-- 135. 孙权
local g135 = General:new(extension, "wzzz__sunquan", "wu", 4)
g135:addSkills { "wzzz_v__tycl__zhiheng" }
Fk:loadTranslationTable {
  ["wzzz__sunquan"] = "孙权",
}

-- 136. 孙策
local g136 = General:new(extension, "wzzz__sunce", "wu", 4)
g136:addSkills { "wzzz_v__jiang", "wzzz_v__ol_ex__hunzi" }
g136:addRelatedSkills { "wzzz_v__ex__yingzi", "wzzz_v__yinghun" }
Fk:loadTranslationTable {
  ["wzzz__sunce"] = "孙策",
}

-- 137. 孙坚
local g137 = General:new(extension, "wzzz__sunjian", "wu", 4, 5)
g137:addSkills { "wzzz_v__yinghun", "wzzz_v__wulie" }
Fk:loadTranslationTable {
  ["wzzz__sunjian"] = "孙坚",
}

-- 138. 刘协
local g138 = General:new(extension, "wzzz__liuxie", "qun", 3)
g138:addSkills { "wzzz_v__tianming", "wzzz_v__mizhao" }
Fk:loadTranslationTable {
  ["wzzz__liuxie"] = "刘协",
}

return extension
