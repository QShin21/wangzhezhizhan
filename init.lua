local extension = Package:new("wangzhezhizhan")
extension.extensionName = "wangzhezhizhan"

local prefix = "packages.wangzhezhizhan."
local wangzhe_role = require(prefix .. "pkg.gamemodes.wangzhe_role")

extension:loadSkillSkels(wangzhe_role.skills)
extension:addGameMode(wangzhe_role.mode)
Fk:loadTranslationTable(require(prefix .. "i18n.zh_CN"))

local ok, ltk_util = pcall(require, "ltk.client.util")
if ok and ltk_util and type(ltk_util.entitle) == "function" and not ltk_util.__wangzhe_summary_patched then
  local old_entitle = ltk_util.entitle

  local function translate_general_key(key)
    if not key or key == "" then return Fk:translate("wangzhe_none") end
    local names = key:split("/")
    return table.concat(table.map(names, function(name)
      return Fk:translate(name)
    end), "/")
  end

  local function translate_general_list(list)
    if type(list) ~= "table" or #list == 0 then return Fk:translate("wangzhe_none") end
    return table.concat(table.map(list, translate_general_key), "、")
  end

  function ltk_util:entitle(data, seat, winner)
    local ret = old_entitle(self, data, seat, winner)
    if data and data.wangzhe_score ~= nil then
      local extra = {}
      if seat == 0 and data.wangzhe_overview then
        table.insert(extra, data.wangzhe_overview)
      end
      table.insert(extra, Fk:translate("wangzhe_score") .. "：" .. tostring(data.wangzhe_score))
      table.insert(extra, Fk:translate("wangzhe_kill_targets") .. "：" ..
        translate_general_list(data.wangzhe_kill_targets))
      table.insert(extra, Fk:translate("wangzhe_death_source") .. "：" ..
        translate_general_key(data.wangzhe_death_source))
      if ret.honor and ret.honor ~= "" then table.insert(extra, ret.honor) end
      ret.honor = table.concat(extra, "；")
    end
    return ret
  end

  ltk_util.__wangzhe_summary_patched = true
end

return extension
