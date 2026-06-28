# 武将技能实现审查记录

## 第一轮：常备主公

审查范围：`pkg/lords/init.lua` 中登记的 16 名常备主公及其关联技能。

修复项：

- `wzzz_v__shouyue`：补全文本提示中的“其他蜀势力角色”，使发动提示与描述主体一致。
- `wzzz_v__zhiba` / `wzzz_v__zhiba_active&`：补上主公本人出牌阶段限一次主动与一名其他吴势力角色拼点的实现；移除附属技能对孙策觉醒状态的错误限制；目标没赢时，主公可获得双方拼点牌。
- `wzzz_v__os_ex__polu`：将摸牌目标上限和摸牌数改为至多 3，符合“至多三名角色”“摸 X 张牌，X 为发动次数且至多为 3”。
- `wzzz_v__ol__pingtao`：改为锁定技；在孙坚使用【杀】对无手牌角色或拥有 `wzzz_v__os_ex__polu` 的角色造成伤害时，伤害值 +1。
- `wzzz_v__ol__canshi`：摸牌阶段改为直接摸 X 张牌，X 至少为 4，而不是在常规摸牌数上额外增加；`wzzz_v__guiming` 的吴势力计数包含技能拥有者自己。
- `wzzz_v__ol__kuizhu` / `wzzz_v__kuizhu_active`：补上缺失的主动选择技能；伤害分支改为目标体力值之和不大于弃牌数，而不是必须等于弃牌数。
- `wzzz_v__ol__chezheng`：出牌阶段结束效果改为检查所有攻击范围内不包含孙亮的其他角色；弃置其中一名可弃牌角色的一张牌后，按这些角色数摸牌且最多摸 2 张。
- `wzzz_v__ol_ex__huangtian` / `wzzz_v__ol_ex__huangtian_active&`：附属发动可给【闪】、【闪电】或黑桃手牌；新增其他群势力角色每回合首次使用或打出【闪】后，张角获得该【闪】的处理。
- `wzzz_v__mou__xueyi`：出牌阶段使用第一张指定唯一目标的黑色牌时摸一张牌；主公杀死忠臣时免除弃置所有牌的惩罚。
- `wzzz_v__ofl_mou__luanji`：其他角色响应【闪】后，袁绍手牌数小于手牌上限才摸一张牌；袁绍回合内杀死角色后，本回合手牌上限 +2。
- `wzzz_v__ol_ex__leiji`：只在“雷击”自身判定完成且结果为黑色时继续结算，避免误触发其他黑色判定；伤害目标改为“一名角色”，允许选择自己。

已核对暂未修改：

- `wzzz_v__shuzhi`、`wzzz_v__jianxiong`、`wzzz_v__qingzheng`、`wzzz_v__hujia`、`wzzz_v__xingshang`、`wzzz_v__fangzhu`、`wzzz_v__songwei`、`wzzz_v__mingjian`、`wzzz_v__huituo`、`wzzz_v__xingshuai`、`wzzz_v__rende`、`wzzz_v__renwang`、`wzzz_v__jijiang`、`wzzz_v__xiangle`、`wzzz_v__fangquan`、`wzzz_v__ruoyu`、`wzzz_v__zhiheng`、`wzzz_v__jiuyuan`、`wzzz_v__tongye`、`wzzz_v__jiang`、`wzzz_v__hunzi`、`wzzz_v__chouhai`、`wzzz_v__yinghun`、`wzzz_v__wulie`、`wzzz_v__tianming`、`wzzz_v__mizhao`、`wzzz_v__zhuiting`、`wzzz_v__jiuchi`、`wzzz_v__roulin`、`wzzz_v__benghuai`、`wzzz_v__baonue`、`wzzz_v__shiyuan`、`wzzz_v__dushi`、`wzzz_v__yuwei`、`wzzz_v__mashu`、`wzzz_v__xiongzheng`、`wzzz_v__luannian`、`wzzz_v__ol__lijun`、`wzzz_v__mengjing`、`wzzz_v__guidao`。

## 第一轮：非常备主公-蜀国

审查范围：`pkg/generals/init.lua` 中 1-40 号蜀势力非常备主公武将及其关联/派生技能。

修复项：

- `wzzz_v__sheyan`：增加普通锦囊牌目标时使用无距离限制目标检查；目标数大于 1 时改为令其中一个目标无效。
- `wzzz_v__bingzheng` / `wzzz_v__bingzheng_active`：补上缺失的主动选择技能，限定目标为手牌数不等于体力值的角色，并正确区分“摸一张牌/弃置一张手牌”。
- `wzzz_v__ol_ex__enyuan`：伤害来源选择给红色手牌时，先展示再交给法正。
- `wzzz_v__ol_ex__xuanhuo` / `wzzz_v__ol_ex__xuanhuo_active`：补上主动交两张牌的选择技能；【杀】分支无距离限制，取牌分支可从手牌区或装备区共取两张。
- `wzzz_v__xiaosi`：目标不能弃置基本牌时，先展示所有手牌，再令傅肜摸一张牌。
- `wzzz_v__shzj_guansuo__wuji`：觉醒后改为二选一：获得“偃月”并失去“虎啸”、摸两张且可弃置武器，或获得“武圣”并摸一张。
- `wzzz_v__renshi`：改为每回合第一次受【杀】伤害时伤害 -1 并获得该【杀】，再减 1 点体力上限。
- `wzzz_v__ty__qinqing`：结束阶段可弃置至多 X 名攻击范围包含一号位角色的各一张牌，并按其与一号位手牌数大小分别摸牌。
- `wzzz_v__tujue`：进入濒死后只将所有牌交给一名其他角色，移除额外回复和摸牌。
- `wzzz_v__ofl_mou__jizhi`：改为可选发动，触发范围为非转化锦囊牌，不再限定普通锦囊。
- `wzzz_v__ol__jiqiao`：补上限定技次数限制。
- `wzzz_v__jianji`：目标摸牌后展示该牌，并允许按展示牌可转化使用。
- `wzzz_v__zhongyi`：改为限定技置一张红色“忠义”牌；存在“忠义”牌时己方【杀】伤害 +1，下个准备阶段移去；己方击杀后复原并改为己方其他角色【杀】伤害 +1。
- `wzzz_v__v11__renwang`：改为每回合限一次，适用于其他角色而非仅 1v1 对手。
- `wzzz_v__zhanjue`：改为出牌阶段限两次，使用后自己摸一张牌、因此受伤角色摸牌；若刘谌本阶段因此受伤则本阶段失效。
- `wzzz_v__niepan`：濒死结算后补上获得“八阵”“火计”“看破”之一的选择。
- `wzzz_v__bazhen` / `wzzz_v__pangtong__bazhen`：拆分同名不同文本实现；卧龙诸葛亮的共用“八阵”仅视为装备【八卦阵】，庞统涅槃获得的派生“八阵”额外保留判定失效摸一张。
- `wzzz_v__mobile__zishu`：回合外获得牌数按回合记录，并在其他角色回合结束后弃置等量牌；自己回合内非因此法获得牌后摸牌。
- `wzzz_v__yingyuan`：改为每回合限两次，触发牌限定为基本牌或普通锦囊牌，移除每种牌名限一次。
- `wzzz_v__sxfy__xiemu` / `wzzz_v__sxfy__xiemu&`：修复附属主动技目标过滤变量错误；交给并展示基本牌后，由马良选择是否令其本回合攻击范围 +1。
- `wzzz_v__ty__cunsi`：发动时先回复 1 点体力，失去“清玉”，令目标获得“勇决”；若目标不是自己，则目标摸两张牌。
- `wzzz_v__ty__yongjue`：获得【杀】分支延迟到该【杀】结算结束后执行；另一分支令该【杀】无次数限制。
- `wzzz_v__m_shi__kuanggu`：改为固定三选一效果，并加入每回合限一次的背水分支。
- `wzzz_v__m_ex__benxi`：弃牌数上限改为 4，造成伤害后的摸牌数改为 X。
- `wzzz_v__zhiyi`：改为可选发动，并按“摸一张/视为使用本回合使用或打出过的基本牌”二选一。
- `wzzz_v__changbiao`：补上限定技次数限制。
- `wzzz_v__ex__guanxing`：加入“星”牌机制，准备/结束阶段按 X 张观看并可置一张为“星”，满足条件时结束阶段可再发动。
- `wzzz_v__zhitian`：重写为限定主动技，获得所有“星”后可弃武器；“星”数达标且无武器时本回合视为装备【诸葛连弩】。
- `wzzz_v__hs__kongcheng`：移除国战“琴”牌相关效果，仅保留无手牌时不能成为【杀】或【决斗】目标。
- `wzzz_v__ol_ex__huoji` / `wzzz_v__ol_ex__huoji_fire_attack_skill`：改为红色手牌转化【火攻】，并按牌堆顶牌替代弃牌、伤害后本回合观看牌数递减的描述重做结算。
- `wzzz_v__m_ex__lianhuan`：可将装备区或手牌区的梅花牌当【铁索连环】使用或重铸。
- `wzzz_v__ex__tishen`：结算后记录“咆哮”修改状态，描述补齐“然后修改咆哮”。
- `wzzz_v__ty__baobian`：修正依次获得的技能 ID 为“挑衅”“咆哮”“神速”。
- `wzzz_v__xingbu`：亮出牌后选择获得效果的其他角色改为可取消。

已核对暂未修改：

- `wzzz_v__ty_ex__longyin`、`wzzz_v__fuhun`、`wzzz_v__wusheng`、`wzzz_v__gxzb__paoxiao`、`wzzz_v__ol__xuehen`、`wzzz_v__ol__huxiao`、`wzzz_v__qinglong`、`wzzz_v__ex__yijue`、`wzzz_v__huaizi`、`wzzz_v__wuyuan`、`wzzz_v__huisheng`、`wzzz_v__cunwei`、`wzzz_v__qicai`、`wzzz_v__ol_ex__liegong`、`wzzz_v__yizhuang`、`wzzz_v__ol_ex__tiaoxin`、`wzzz_v__ol_ex__zhiji`、`wzzz_v__jiangwei__guanxing`、`wzzz_v__ex__rende`、`wzzz_v__ty_ex__xiansi`、`wzzz_v__xiangle`、`wzzz_v__m_ex__fangquan`、`wzzz_v__mashu`、`wzzz_v__ex__tieji`、`wzzz__jinzi`、`wzzz_v__ol__sanyao`、`wzzz_v__ty_ex__zhiman`、`wzzz_v__huilei`、`wzzz_v__mobile__guixiu`、`wzzz_v__qingyu`、`wzzz_v__jugu`、`wzzz_v__ziyuan`、`wzzz_v__pangtong__huoji`、`wzzz_v__pangtong__kanpo`、`wzzz_v__os__zhiming`、`wzzz_v__jianzhengq`、`wzzz_v__zhuandui`、`wzzz_v__tianbian`、`wzzz_v__jilis`、`wzzz_v__feijun`、`wzzz_v__binglue`、`wzzz_v__m_ex__qimou`、`wzzz_v__qiaoshi`、`wzzz_v__ty_ex__yanyu`、`wzzz_v__qiangzhi`、`wzzz_v__ol__shenxian`、`wzzz_v__qiangwu`、`wzzz_v__dianjun`、`wzzz_v__kangrui`、`wzzz_v__zuilun`、`wzzz_s__7236_840c`、`wzzz_v__juxiang`、`wzzz_v__os_ex__lieren`。

## 第一轮：非常备主公-魏国

审查范围：`pkg/generals/init.lua` 中 83-124 号魏势力非常备主公武将及其关联/派生技能。
修复项：

- `wzzz_v__ty_ex__chengxiang`：获得牌点数和为 13 时改为可选择复原武将牌或令下次“称象”亮出五张牌。
- `wzzz_v__ol_ex__tuntian`：红桃判定结果改为获得判定牌，非红桃仍置为“田”。
- `wzzz_v__ty_ex__pindi`：目标已受伤时改为只横置陈群，不再重置。
- `wzzz_v__ty_ex__jiangchi`：第一项补上弃牌阶段展示【杀】并令这些牌不计入本阶段手牌上限。
- `wzzz_v__ex__yiji`：补上每轮首次进入濒死时摸一张并可交给其他角色一张手牌的分支。
- `wzzz_v__qizhi` / `wzzz_v__jinqu`：奇制触发范围改为使用任意牌指定目标；进趋弃牌目标改为 X+1 张。
- `wzzz_v__ty__weicheng`：触发条件改为手牌数不大于体力值。
- `wzzz_v__daoshu`：获得目标手牌后展示之；花色不同时改为展示并交给与获得牌花色不同的手牌。
- `wzzz_v__daizui`：重写为受到致命伤害时对伤害来源发动一次“盗书”，仅在“盗书”造成伤害后防止该致命伤害。
- `wzzz_v__shenshi` / `wzzz_v__m_heg__duoshi`：审时移除转换技阳分支并按受伤后给牌展示、回合末补牌实现；度势改为出牌阶段给手牌数最多角色一张牌并造成伤害，若其因此死亡可令一名角色摸至四张。
- `wzzz_v__qingzhong`：阶段结束时若不是唯一最少手牌，必须与一名手牌最少的其他角色交换手牌。
- `wzzz_v__ty__fengying` / `wzzz_v__ol__cuorui` / `wzzz_v__ty__liewei`：奉迎额外回合开始摸至体力值且需已受伤；挫锐改为准备阶段限定技；裂围改为每回合限一次可摸牌，并在杀死角色后可复原挫锐或摸两张。
- `wzzz_v__quji`：回复后仍受伤的目标各摸一张牌。
- `wzzz_v__ex__fankui`：改为受伤后可选择获得任意角色区域牌，或每轮限一次观看手牌并获得其中一张。
- `wzzz_v__ex__ganglie`：改为先选择一名其他角色再判定，红色伤害该角色、黑色弃置其牌。
- `wzzz_v__m_ex__duanliang` / `wzzz_v__m_ex__jiezi`：断粮无距离限制条件改为本回合未造成过伤害；截辎改为可令一名角色摸一张牌，且不再是锁定技。
- `wzzz_v__ex__luoyi`：补上使用的【杀】被【闪】抵消后可摸一张牌。
- `wzzz_v__ol_ex__jieming`：受伤分支改为令目标将手牌摸至 X，死亡分支才摸 X 后弃至 X。
- `wzzz_v__jianmie`：补上限定技；改为目标先选颜色、自己后选颜色，双方展示手牌后弃置对应颜色手牌，再由弃置较多者视为使用【决斗】。
- `wzzz_v__tuxi`：由摸牌阶段替换重写为回合内限两次、不以此法获得牌后可弃手牌并获得其他角色手牌。
- `wzzz_v__ex__luoshen`：改为每次判定均获得判定牌，黑色判定牌数量增加本回合手牌上限。
- `wzzz_v__huomo`：黑色非基本牌置于牌堆顶前先展示。
- `wzzz_v__ol__qiangxi`：不弃武器时改为受到 1 点伤害，而不是失去 1 点体力。
- `wzzz_v__fengliang`：觉醒后获得的“挑衅”修正为当前武将关联的 `wzzz_v__m_ex__tiaoxin`。
- `wzzz_v__ty_ex__junbing`：司马朗回赠等量牌改为不可取消。
- `wzzz_v__xianfu` / `wzzz_v__chouce`：筹策改为仅当本次伤害因“先辅”造成且选择目标为先辅角色时摸两张，并统一使用 `wzzz_v__xianfu` 标记。
- `wzzz_v__v11__xiechan`：目标从 1v1 对手改为任意一名可拼点的其他角色。
- `wzzz_v__xiangshu`：移除“本回合造成过伤害”触发门槛，按文本用本回合伤害值作为 X。
- `wzzz_v__zhenwei` / `wzzz_v__zhenwei_active`：补上缺失的主动选择技能，并限制虚拟牌不能选择“无效并回收”分支。
- `wzzz_v__ninge`：弃牌范围由场上牌改为目标区域里的牌。

已核对暂未修改：

- `wzzz_v__kangkai`、`wzzz_v__renxin`、`wzzz_v__ol__jushou`、`wzzz_v__ol__jiewei`、`wzzz_v__weikui`、`wzzz_v__lizhan`、`wzzz_v__huituo`、`wzzz_v__faen`、`wzzz_v__yajun`、`wzzz_v__zundi`、`wzzz_v__zaoxian`、`wzzz_v__ol__jingce`、`wzzz_v__zhengu`、`wzzz_v__m_ex__tiaoxin`、`wzzz_v__ol_ex__wangxi`、`wzzz_v__weijing`、`wzzz_v__m_ex__junxing`、`wzzz_v__yuce`、`wzzz_v__bingqing`、`wzzz_v__zhenlie`、`wzzz_v__miji`、`wzzz_v__zhenwei`的转移分支、`wzzz_v__ex__qingjian`、`wzzz_v__shebian`、`wzzz_v__qice`、`wzzz_v__ty_ex__zhiyu`、`wzzz_v__quhu`、`wzzz_v__choutao`、`wzzz_v__ty_ex__jueqing`、`wzzz_v__shangshi`、`wzzz_v__m_ex__quanji`、`wzzz_v__zili`、`wzzz_v__zuoding`、`wzzz_v__jixian`、`wzzz_v__ty_ex__gongao`、`wzzz_v__ty_ex__juyi`、`wzzz_v__benghuai`。

## 第一轮：非常备主公-吴国

审查范围：`pkg/generals/init.lua` 中 41-82 号吴势力非常备主公武将及其关联/派生技能。
修复项：

- `wzzz_v__m_ex__anxu`：获得牌后展示；只有获得来源为手牌且非黑桃时步练师摸一张，移除额外令手牌较少者摸牌。
- `wzzz_v__dingpan`：发动次数改为最多阵营存活数且至多 3；第一项改为弃置目标一至两张牌。
- `wzzz_v__sxfy__wudu`：补上限定技次数；结算顺序改为先防止伤害再减体力上限。
- `wzzz_v__ex__guose`：移除选项结算后的额外摸牌。
- `wzzz_v__mou__liuli`：移除红桃标记和额外出牌阶段分支，仅保留弃牌并转移【杀】。
- `wzzz_v__qshm__fenxun`：弃牌数量改为一张；移除造成伤害后获得手牌分支，改为出牌阶段结束时按【杀】对距离 1 内角色造成伤害总量摸两张。
- `wzzz_v__qixi` / `wzzz_v__fenwei`：奇袭使用的【过河拆桥】弃置同花色牌时复原“奋威”；奋威首轮结束已使用时复原。
- `wzzz_v__bingyi`：重写为展示手牌后按红/黑较多数观看牌堆顶/底并分配给等量角色。
- `wzzz_v__gongqi`：弃置非基本牌即可弃置一名其他角色的一张牌，不再限定装备牌。
- `wzzz_v__jiefan`：第一轮发动后于回合结束复原限定次数。
- `wzzz_v__dufeng`：重写为限定技，出牌阶段开始可失去 1 点体力，并按已损失体力值增加本回合【杀】次数。
- `wzzz_v__m_ex__xuanfeng`：移除移动装备分支，改为依次弃置至多两名其他角色共计两张牌。
- `wzzz_v__sxfy__fenyin`：重写为回合内使用牌颜色与上一张不同可摸一张。
- `wzzz_v__ol_ex__qinxue`：觉醒结算顺序改为减体力上限并获得“攻心”，再选择回复或摸牌。
- `wzzz_v__botu`：每轮发动上限固定为两次。
- `wzzz_v__guanwei`：只统计非虚拟牌是否至少两张且花色一致/均无色。
- `wzzz_v__guolun`：交换后增加“较小点数角色摸牌/较大点数角色回复”二选一。
- `wzzz_v__qshm__songsang`：移除获得“展骥”的额外效果。
- `wzzz_v__ol__yaoming`：重写为出牌阶段弃牌/摸牌分支各限一次，或受到 1 点伤害后发动；目标手牌数比较改为不小于/不大于且弃置范围为一张牌。
- `wzzz_v__jiang`：补上每回合限一次失去 1 点体力获得因弃置进入弃牌堆的【决斗】或红色【杀】。
- `wzzz_v__yinghun`：选项顺序和提示改为文本顺序，先“摸一弃 X”，后“摸 X 弃一”。
- `wzzz_v__kuangbi`：补上游戏开始可发动、目标可置一至三张牌且可令其立即摸等量牌、准备阶段获得“匡弼”牌。
- `wzzz_v__ol__canshi`：摸牌阶段改为摸 X 张（X 至少为 4），并同步当前描述。
- `wzzz_v__ty__mumu`：第二项限定为获得一名角色装备区的防具牌，第一项仍为弃置其他角色装备牌，并按文本增减【杀】次数。
- `wzzz_v__ty__zhixi`：弃牌触发范围限定为出牌阶段使用【杀】或普通锦囊牌。
- `wzzz_v__shixin`：防止范围由火属性伤害扩展为所有属性伤害。
- `wzzz_v__jieyin`：重写为弃一张手牌或将装备牌置入男性角色装备区，然后按双方体力高低分别摸牌/回复。
- `wzzz_v__liangzhu`：补上每回合限一次，并排除因“结姻”造成的回复。
- `wzzz_v__hanzhan`：拼点前改为由太史慈选择对方手牌，不再随机。
- `wzzz_v__ofl__chongjian`：改为限定主动技，出牌阶段减体力上限后将装备牌当【酒】或无视防具的【杀】使用。
- `wzzz_v__ol_ex__hongyan`：手牌上限条件改为装备区有任意牌。
- `wzzz_v__ty_ex__pojun`：移除旧的装备弃置/锦囊摸牌奖励，补上【杀】造成伤害时按手牌区和装备区牌数比较伤害 +1。
- `wzzz_v__v33__yicheng`：触发目标改为相邻角色，结算改为摸一张后弃置一张牌。
- `wzzz_v__m_ex__zongxuan`：补上上家每回合首次弃置入弃牌堆触发；可交出一张锦囊牌并可将其余任意张置于牌堆顶。
- `wzzz_v__ol_ex__zhiyan`：触发时机改为自己的结束阶段，不再包含上家的结束阶段。
- `wzzz_v__hs__buqu`：有“创”时手牌上限等于“创”的数量。
- `wzzz_v__m_ex__fenji`：补上手牌被其他角色弃置或获得时可失去体力令失去手牌角色摸两张；结束阶段分支改为先失去体力再令目标摸牌。
- `wzzz_v__fenli`：按判定/出牌/弃牌阶段开始前分别跳过对应阶段，并支持装备数为 0 时判断最多。
- `wzzz_v__pingkou`：若造成伤害目标数小于跳过阶段数，可获得其中一名目标装备区一张牌。
- `wzzz_v__ty_ex__danshou`：重写为其他角色回合限一次成为基本牌或普通锦囊目标后摸一张；结束阶段未摸牌时可弃 X+1 张牌造成伤害。
- `wzzz_v__hongyuan`：改为摸牌阶段结束后可依次交给至多两名其他角色各一张手牌。
- `wzzz_v__mingzhe`：触发范围改为回合外或摸牌阶段失去红色牌，展示后摸等量牌，摸牌阶段限一次。
- `wzzz_v__duwu`：目标允许为自己或攻击范围内角色；只有目标因此进入濒死且濒死结算后仍存活时才失去体力并令技能本回合失效。
- `wzzz_v__qshm__yinbing`：补上游戏开始触发、自己可放置手牌、受【杀】或【决斗】伤害后由祖茂移去“引兵”牌。
- `wzzz_v__juedi`：两个分支均改为处理所有“引兵”牌。

已核对暂未修改：

- `wzzz_v__jishe`、`wzzz_v__lianhuo`、`wzzz_v__ol__duanbing`、`wzzz_v__ty_ex__shenxing`、`wzzz_v__ex__kurou`、`wzzz_v__ol_ex__zhaxiang`、`wzzz_v__jianyi`、`wzzz_v__mobile__shangyi`、`wzzz_v__ol__dujin`、`wzzz_v__ty_ex__yongjin`、`wzzz_v__haoshi`、`wzzz_v__ol_ex__dimeng`、`wzzz_v__ex__qianxun`、`wzzz_v__ex__lianying`、`wzzz_v__keji`、`wzzz_v__gongxin`、`wzzz_v__gongqing`、`wzzz_v__zhanji`、`wzzz_v__ol_ex__hunzi`、`wzzz_v__chouhai`、`wzzz_v__yinghun`的两个实际效果、`wzzz_v__ty__meibu`、`wzzz_v__tianyi`、`wzzz_v__xingzhao`、`wzzz_v__quedi`、`wzzz_v__mobile__choujue`、`wzzz_v__ol_ex__tianxiang`、`wzzz_v__ol_ex__piaoling`、`wzzz_v__ol_ex__zhijian`、`wzzz_v__guzheng`、`wzzz_v__duanfa`、`wzzz_v__sp__youdi`、`wzzz_v__wzzz__fanjian`、`wzzz_v__huanshi`、`wzzz_v__ol__aocai`。

## 第一轮：非常备主公-群雄

审查范围：`pkg/generals/init.lua` 中 125-168 号群雄势力非常备主公武将及其关联/派生技能。
修复项：

- `wzzz_v__cixiao` / `wzzz_v__panshi`：修正“义子/叛弑”技能 ID 与标记；叛弑改为【杀】结算结束后结束出牌阶段。
- `wzzz_v__xianshuai`：移除锁定技，改为本轮首次伤害后可摸牌，且伤害来源为自己时可选择造成 1 点伤害。
- `wzzz_v__ty_ex__mingce`：交出【杀】或装备牌前先展示。
- `wzzz_v__sanchen` / `wzzz_v__pozhu`：三陈在符合条件时本阶段临时获得“破竹”；破竹重写为弃一张手牌、展示其他角色一张手牌，花色不同则造成伤害并令技能失效。
- `wzzz_v__ty__moukui`：选择两项后【杀】被无效或抵消时，改为自己弃置一张牌。
- `wzzz_v__huaiyi`：补上一种颜色时摸一张并令本阶段发动次数改为两次。
- `wzzz_v__ty_ex__qiaomeng`：弃置牌类型改为武器牌令牌不可响应、坐骑牌改为获得。
- `wzzz_v__ty_ex__jigong`：摸牌数改为一至二张；回复判定改为弃牌阶段开始时。
- `wzzz_v__ol__yanhuo`：死亡时可选择令本局【杀】伤害 +1，或令伤害来源弃置至多 X 张牌。
- `wzzz_v__ex__chuli`、`wzzz_v__m_ex__qingnang`、`wzzz_v__ol_ex__yaowu`、`wzzz_v__shizhan`：分别补齐除疠文本和有牌/至少一名限制、青囊目标不再要求已受伤、耀武覆盖非牌伤害、势斩同回合目标不重复。
- `wzzz_v__ol_ex__wansha`、`wzzz_v__mou__luanwu`、`wzzz_v__ol_ex__weimu`：完杀描述同步；乱武移除旧升级分支，结算后可视为使用无距离次数限制【杀】；帷幕摸牌改为等同伤害数。
- `wzzz_v__m_ex__jianying`：主动技由转化基本牌改为指定花色，下一张基本牌或普通锦囊视为该花色。
- `wzzz_v__langxi`：由随机 0~2 伤害改为亮牌堆顶牌，按点数 6~9/10~K/5 处理伤害与重复流程。
- `wzzz_v__xh__yisuan`：改为普通锦囊结算结束后确实进入弃牌堆时，付出体力或体力上限代价后获得。
- `wzzz_v__m_ex__mieji`：可展示武器牌或锦囊牌置顶；目标围绕手牌交锦囊/弃非锦囊，无法弃第二张时展示所有手牌。
- `wzzz_v__shiyuan`、`wzzz_v__dushi`：诗怨大于体力分支摸两张；毒逝在脱离濒死或死亡时失去自身技能并交给其他角色。
- `wzzz_v__wenji`、`wzzz_v__tunjiang`、`wzzz_v__tushe`：问计展示交出的牌并按牌类型限制响应；屯江支持未执行出牌阶段；图射改为展示所有手牌并按是否有基本牌/判定区摸牌。
- `wzzz_v__huoshou`、`wzzz_v__ofl_mou__zaiqi`：祸首补上出牌阶段结束弃所有手牌并视为使用【南蛮入侵】；再起目标改为其他角色且 X 为本回合进入弃牌堆的红色弃牌数、至多 3，不再回复。
- `wzzz_v__pingcai`：移除擦拭宝物小游戏，改为展示一张手牌并按方块/红桃/黑桃/梅花执行伤害、摸牌回复、移动装备、横置。
- `wzzz_v__fuji`、`wzzz_v__jiaozi`：伏骑范围改为距离 2 以内其他角色不可响应；骄恣只在造成伤害且手牌数最多时增伤。
- `wzzz_v__chenglue`：移除转换技，改为摸一张弃一张手牌，直到回合结束同花色牌无距离次数限制。
- `wzzz_v__shicai`：限定为自己的回合内，排除延时锦囊，并按每种类型首次结算后置顶摸牌。
- `wzzz_v__fhyx_ex__shuangxiong`、`wzzz_v__fhyx_ex__xiayong`：双雄目标限定其他角色；狭勇描述同步为使用过的【杀】或【决斗】均造成过伤害。
- `wzzz_v__yizhong`、`wzzz_v__ol_ex__zhenjun`：毅重改为仅梅花【杀】无效；镇军触发时机扩展至准备/结束阶段，并将摸牌分支改为立即摸牌。
- `wzzz_v__ol_ex__qiaobian`：移除“变”标记旧机制，改为弃置手牌跳过阶段，跳过摸牌/出牌阶段执行对应效果，回合结束跳过至少三个阶段可摸两张牌。
- `wzzz_v__yishe` / `wzzz_v__bushi`：义舍支持游戏开始和“米”少于三张时补米，最后一张移走后可回复；布施限定 1 点伤害，造成伤害分支限定其他角色。
- `wzzz_v__jiuzhu`、`wzzz_v__chongzhen`、`wzzz_v__yajiao`：救主重写为限定技，其他角色进入濒死时失去“冲阵”并选择回复/摸三张；冲阵修复错误的 `on_cost` 引用并同步文本；涯角限定回合外使用或打出手牌。
- `wzzz_v__ty_ex__xianzhen`、`wzzz_v__ty_ex__jinjiu`、`wzzz_v__jungong`：陷阵改为出牌阶段限一次，失败后弃牌阶段可展示任意张【杀】不计入手牌上限；禁酒只转换手牌中的【酒】；峻攻的 X 改为本阶段此前发动次数 +1。
- `wzzz_v__ty__niluan`、`wzzz_v__ty__mouzhu`、`wzzz_v__zhichi`、`wzzz_v__ex__biyue`：逆乱描述同步；谋诛距离判断改为你到目标的距离；智迟只令其他角色使用的牌无效；闭月按手牌数小于体力值摸两张，否则摸一张。
- `wzzz_v__lijian`、`wzzz_v__ol_ex__guidao`、`wzzz_v__fencheng`、`wzzz_v__weidi`、`wzzz_v__ol_ex__longdan`、`wzzz_v__liyu`、`wzzz_v__mizhao`：同步确认正确实现的描述文本和提示。

已核对暂未修改：

- `wzzz_v__xianzhou`、`wzzz_v__chenqing`、`wzzz_v__lihun`、`wzzz_v__ol_ex__jiuchi`、`wzzz_v__roulin`、`wzzz_v__dengli`、`wzzz_v__shifei`、`wzzz_v__limu`、`wzzz_v__v33__zhanshen`、`wzzz_v__hs__wushuang`、`wzzz_v__liantao`、`wzzz_v__ol__shichou`、`wzzz_v__ol_ex__leiji`、`wzzz_v__midao`、`wzzz_v__fencheng`、`wzzz_v__mizhao` 的主要结算、`wzzz_v__weidi` 的选择与抽取流程。

## 第二轮：全量复核

审查范围：重新检查常备主公、非常备主公蜀国、魏国、吴国、群雄五个阶段已核对的全部武将技能及本轮修复点，重点复查死亡后延迟效果、临时牌属性覆盖、阶段/回合限次、目标范围和描述同步。

第二轮修复项：

- `wzzz_v__ol__yanhuo`：将技能标记为 `mode_skill`，确保死亡后选择的“本局游戏【杀】造成的伤害 +1”通过房间标记继续作为全局延迟效果生效，而不是依赖已死亡角色继续持有可触发技能。
- `wzzz_v__m_ex__jianying`：指定下一张基本牌或普通锦囊牌花色时，记录该牌原始花色和颜色，并在该牌使用结算结束后恢复，避免临时“视为此花色”永久污染实体牌。
- `wzzz_v__wulie` / `wzzz_lord__wulie`：拆分普通孙坚与常备主公孙坚的“武烈”；普通版移除获得“平讨”的额外分支，主公版保留该分支并改挂专用技能 ID，避免同 ID 同时承载两段不同描述。
- `wzzz_v__pangtong__bazhen`：同步数据与翻译 ID，使庞统“涅槃”获得的“八阵”使用独立实现，保留判定失效摸牌；卧龙诸葛亮的 `wzzz_v__bazhen` 仅视为装备【八卦阵】。
- `wzzz_v__ol__canshi` / `wzzz_lord__ol__canshi`：拆分普通孙皓与常备主公孙皓的“残蚀”；普通版按“非装备牌”弃牌，主公版按“【杀】或普通锦囊牌”弃牌。

第二轮复核未再发现需改动项：

- 常备主公技能、蜀国势力、魏国势力、吴国势力和群雄势力第一轮已记录修复项均按文本描述重新比对；除上述机制风险点外，未发现新的实现与描述不一致项。

## 追加修复：曹操“述志”限定处理

- `wzzz__shuzhi` / `wzzz_v__ex__jianxiong` / `wzzz_v__mou__qingzheng`：为“述志”选择的技能增加本局限一次的硬性判定；“奸雄”和“清正”在触发前检查述志限定标记和本局发动记录，发动后由“述志”写入已用标记、同步本局使用次数并失效该技能，避免仅依赖动态添加限定技标签失败。
- `wzzz_v__ol_ex__baonue`：为游戏开始时变更势力的选人流程补充专用提示，明确当前没有其他群势力角色、可选择一名非群势力角色，并说明其势力会改为“群”。
- `wzzz_v__ty_ex__tongxin`：补充发动后的回合标记翻译，使标记显示为中文“同心”。
- `wzzz__jinzi`：为使用装备牌转化的【杀】后是否令其不计入次数限制并失去“锦姿”的二段选择补充明确提示。
- `wzzz_v__sxfy__xiemu` 等公开标记：补充“协穆”回合标记、1v1 先后手剩余/流放武将 banner 和“知天”扩展标记的中文翻译，避免界面显示英文标记 ID。
- `wzzz_v__m_shi__kuanggu`：补充“背水”选项翻译，避免狂骨第三项在前端显示为 `beishui`。
- `wzzz_v__ex__guanxing`：为“观星”选择“星”牌时的 `askToChooseCards` 补充目标参数，避免当前 FreeKill API 读取 `target.id` 时空值报错。
- `wzzz_v__ol__yaoming`：修复受伤触发只在伤害值等于 1 时生效的问题，改为按每点伤害逐次询问；主动发动时按当前选择显示“弃牌/摸牌”目标提示，区分出牌阶段主动发动与受伤后可选发动两条路径。
- `wzzz_v__ol__canshi`：普通孙皓“残蚀”移除摸牌阶段必须存在受伤角色的前置触发条件；无人受伤时按 0 人计数，仍因至少为 4 而可改摸 4 张牌。
- `wzzz__yuanding` / `wzzz_v__liangzhu`：参考“述志”的硬性限定处理，为“缘定”选择的“良助”增加本局限一次判定；“良助”触发前检查缘定限定标记和本局发动记录，发动后写入已用标记、同步本局使用次数并失效该技能。
