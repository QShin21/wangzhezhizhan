local extension = Package:new("wangzhe_mode", Package.SpecialPack)

local wangzhe_role = require "packages.wangzhezhizhan.pkg.gamemodes.wangzhe_role"

extension:loadSkillSkels(wangzhe_role.skills)
extension:addGameMode(wangzhe_role.mode)

Fk:loadTranslationTable{
  ["wangzhe_mode"] = "王者之战模式",
}

return extension
