local prefix = "packages.wangzhezhizhan."

local gamemodes = require(prefix .. "pkg.gamemodes")
local lords = require(prefix .. "pkg.lords")
local generals = require(prefix .. "pkg.generals")

Fk:loadTranslationTable(require(prefix .. "i18n.zh_CN"))

local function is_wangzhe_summary_row(data)
  return type(data) == "table" and data.wangzhe_score ~= nil
end

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

local function get_game_summary()
  if not ClientInstance or type(ClientInstance.getBanner) ~= "function" then return nil end
  return ClientInstance:getBanner("GameSummary")
end

local function prepare_wangzhe_summary_rows(summary)
  if type(summary) ~= "table" then return false end
  local found = false
  for _, row in ipairs(summary) do
    if is_wangzhe_summary_row(row) then
      found = true
      row.wangzhe_raw_turn = row.wangzhe_raw_turn or row.turn
      row.wangzhe_raw_recover = row.wangzhe_raw_recover or row.recover
      row.wangzhe_raw_damage = row.wangzhe_raw_damage or row.damage
      row.wangzhe_raw_damaged = row.wangzhe_raw_damaged or row.damaged
      row.wangzhe_raw_kill = row.wangzhe_raw_kill or row.kill
      row.turn = row.wangzhe_raw_turn
      row.recover = row.wangzhe_raw_recover
      row.damage = row.wangzhe_raw_damage
      row.damaged = row.wangzhe_raw_damaged
      row.kill = row.wangzhe_raw_kill
    end
  end
  return found
end

local function format_wangzhe_summary_rows(summary)
  if type(summary) ~= "table" then return end
  for _, row in ipairs(summary) do
    if is_wangzhe_summary_row(row) then
      row.turn = translate_general_list(row.wangzhe_kill_targets)
      row.recover = translate_general_key(row.wangzhe_death_source)
      row.damage = tostring(row.wangzhe_score)
      row.damaged = ""
      row.kill = ""
    end
  end
end

local function raw_wangzhe_entitle_data(data)
  if not is_wangzhe_summary_row(data) then return data end
  local ret = table.simpleClone(data)
  ret.turn = data.wangzhe_raw_turn or data.turn
  ret.recover = data.wangzhe_raw_recover or data.recover
  ret.damage = data.wangzhe_raw_damage or data.damage
  ret.damaged = data.wangzhe_raw_damaged or data.damaged
  ret.kill = data.wangzhe_raw_kill or data.kill
  return ret
end

local function patch_wangzhe_entitle(old_entitle)
  return function(self, data, seat, winner)
    local raw_data = raw_wangzhe_entitle_data(data)
    local ret = old_entitle(self, raw_data, seat, winner)
    if is_wangzhe_summary_row(data) then
      ret.wangzhe_score = data.wangzhe_score
      ret.wangzhe_kill_targets = translate_general_list(data.wangzhe_kill_targets)
      ret.wangzhe_death_source = translate_general_key(data.wangzhe_death_source)
      ret.wangzhe_overview = data.wangzhe_overview
      ret.honor = data.wangzhe_overview or ""
    end
    return ret
  end
end

local function patch_wangzhe_global_entitle(old_entitle)
  return function(data, seat, winner)
    local raw_data = raw_wangzhe_entitle_data(data)
    local ret = old_entitle(raw_data, seat, winner)
    if is_wangzhe_summary_row(data) then
      ret.wangzhe_score = data.wangzhe_score
      ret.wangzhe_kill_targets = translate_general_list(data.wangzhe_kill_targets)
      ret.wangzhe_death_source = translate_general_key(data.wangzhe_death_source)
      ret.wangzhe_overview = data.wangzhe_overview
      ret.honor = data.wangzhe_overview or ""
    end
    return ret
  end
end

local function wangzhe_summary_active()
  local summary = get_game_summary()
  return type(summary) == "table" and is_wangzhe_summary_row(summary[1])
end

local function patch_summary_headers()
  if type(Fk.translate) ~= "function" or Fk.__wangzhe_summary_translate_patched then return end
  local old_translate = Fk.translate
  local header = {
    Turn = "击杀对象",
    Recover = "死亡来源",
    Damage = "积分",
    Damaged = "",
    Kill = "",
    Honor = "结算",
  }

  function Fk:translate(src, lang)
    if self ~= Fk then
      return old_translate(Fk, self, src)
    end
    if header[src] ~= nil and wangzhe_summary_active() then
      return header[src]
    end
    return old_translate(self, src, lang)
  end

  Fk.__wangzhe_summary_translate_patched = true
end

patch_summary_headers()

local function patch_global_summary_helpers()
  if type(FindMosts) == "function" and not _G.__wangzhe_global_find_mosts_patched then
    local old_find_mosts = FindMosts
    function FindMosts(...)
      local summary = get_game_summary()
      local is_wangzhe = prepare_wangzhe_summary_rows(summary)
      local ret = old_find_mosts(...)
      if is_wangzhe then format_wangzhe_summary_rows(summary) end
      return ret
    end
    _G.__wangzhe_global_find_mosts_patched = true
  end

  if type(Entitle) == "function" and not _G.__wangzhe_global_entitle_patched then
    Entitle = patch_wangzhe_global_entitle(_G.__wangzhe_old_global_entitle or Entitle)
    _G.__wangzhe_global_entitle_patched = true
  end
end

if type(Entitle) == "function" and not _G.__wangzhe_old_global_entitle then
  _G.__wangzhe_old_global_entitle = Entitle
end
patch_global_summary_helpers()

local ok, ltk_util = pcall(require, "ltk.client.util")
if ok and ltk_util and type(ltk_util.entitle) == "function" and not ltk_util.__wangzhe_summary_patched then
  local old_entitle = ltk_util.entitle

  if type(ltk_util.findMosts) == "function" then
    local old_find_mosts = ltk_util.findMosts
    function ltk_util:findMosts(...)
      local summary = get_game_summary()
      local is_wangzhe = prepare_wangzhe_summary_rows(summary)
      local ret = old_find_mosts(self, ...)
      if is_wangzhe then format_wangzhe_summary_rows(summary) end
      return ret
    end
  end

  ltk_util.entitle = patch_wangzhe_entitle(old_entitle)

  ltk_util.__wangzhe_summary_patched = true
end

return {
  gamemodes,
  lords,
  generals,
}
