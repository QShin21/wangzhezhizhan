local extension = Package:new("wangzhezhizhan")
extension.extensionName = "wangzhezhizhan"

local prefix = "packages."
if UsingNewCore then prefix = "packages.wangzhezhizhan." end

extension:addGameMode(require(prefix .. "wangzhezhizhan.pkg.gamemodes.wangzhe_role"))
Fk:loadTranslationTable(require(prefix .. "wangzhezhizhan.i18n.zh_CN"))

return extension
