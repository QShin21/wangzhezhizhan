# 新月杀武将拓展制作要点

本项目按新月杀拓展结构实现，顶层包名为 `wangzhezhizhan`，武将分为两个子拓展包：

- `wzzz_lords`：《常备主公》，只放赛事手册最后部分标注为常备主公的 16 名武将。
- `wzzz_generals`：《非主公》，放赛事非主公将池的 168 名武将；其中包含与常备主同名同称号的非主公版本，选将逻辑负责去重。

实现约定：

- 顶层 `init.lua` 只负责载入子包、模式和总翻译表；游戏模式由 `pkg/gamemodes/init.lua` 作为 `Package.SpecialPack` 注册。
- 子包用 `Package:new` 创建，并设置 `extensionName = "wangzhezhizhan"`。
- `pkg/load_skills.lua` 统一加载 `pkg/lords/skills`、`pkg/generals/skills`、`vendor/skills`，避免子包之间隐式依赖。
- 武将使用 `General:new(extension, code_name, kingdom, hp, maxHp, gender)` 创建；同名武将使用 `prefix__truename` 形式区分。
- 武将技能用 `addSkills{...}` 添加，觉醒或临时获得的相关技能用 `addRelatedSkills{...}` 保留展示关系。
- 技能文件返回一个 `fk.CreateSkill` 创建的技能对象；技能名、描述、提示和语音台词通过 `Fk:loadTranslationTable` 提供。
- 武将图放在 `image/generals/<武将代码名>.jpg`。
- 技能语音放在 `audio/skill/<技能代码名>[编号].mp3`。
- 阵亡语音放在 `audio/death/<武将代码名>.mp3`。
- 参考包技能复制入本仓库后统一改名到 `wzzz_v__` 命名空间；赛事自定义技能使用 `wzzz__` 命名空间。
- 技能实现不得 require 原始参考包；必要辅助逻辑复制到 `vendor/modules` 或本项目技能文件中。

资料来源：

- 新月杀拓展之书：`https://fkbook-all-in-one.readthedocs.io/zh-cn/latest/for-creators/anhe/index.html`
- 赛事手册原始抽取清单：`data/manual_roster.json`
- 本项目实际实现清单：`data/roster.json`
- 技能来源索引：`data/skill_sources.json`
- 图片/语音来源索引：`data/asset_sources.json`
