local extension = Package:new("wangzhe_mode", Package.SpecialPack)

local wangzhe_role = require "packages.wangzhezhizhan.pkg.gamemodes.wangzhe_role"

Fk:loadTranslationTable{
  ["wangzhe_mode"] = "王者之战模式",
  ["wangzhe_role_mode"] = "王者之战身份局",
  [":wangzhe_role_mode"] = "三国杀王者之战身份模式：仅支持6人（1主1忠1内3反）或8人（1主2忠1内4反）。选将固定60秒，使用王者之战武将包；游戏开始时主公获得四象标记；指定轮次后进入鏖战。",
}

extension:loadSkillSkels(wangzhe_role.skills)
extension:addGameMode(wangzhe_role.mode)

return extension
