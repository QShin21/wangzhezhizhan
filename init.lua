local prefix = "packages.wangzhezhizhan."

local gamemodes = require(prefix .. "pkg.gamemodes")
local lords = require(prefix .. "pkg.lords")
local generals = require(prefix .. "pkg.generals")
local cards = require(prefix .. "pkg.wzzz_cards")

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

local WANGZHE_RESULT_TITLE_KEYS = {
  ["Game Win"] = true,
  ["Game Lose"] = true,
  ["Game Draw"] = true,
}
local WANGZHE_BLANK_COLUMN = "\194\160"
local wangzhe_pending_row_result_translations = 0

local function wangzhe_overview_from_summary(summary)
  if type(summary) ~= "table" then return nil end
  for _, row in ipairs(summary) do
    if is_wangzhe_summary_row(row) and row.wangzhe_overview and row.wangzhe_overview ~= "" then
      return row.wangzhe_overview
    end
  end
  return nil
end

local function mark_wangzhe_row_result_translation()
  wangzhe_pending_row_result_translations = wangzhe_pending_row_result_translations + 1
end

local function reset_wangzhe_row_result_translations()
  wangzhe_pending_row_result_translations = 0
end

local function translate_wangzhe_result_title(src)
  if not WANGZHE_RESULT_TITLE_KEYS[src] then return nil end
  local summary = get_game_summary()
  if type(summary) ~= "table" or not is_wangzhe_summary_row(summary[1]) then return nil end
  if wangzhe_pending_row_result_translations > 0 then
    wangzhe_pending_row_result_translations = wangzhe_pending_row_result_translations - 1
    return nil
  end
  return wangzhe_overview_from_summary(summary)
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
  if found then reset_wangzhe_row_result_translations() end
  return found
end

local function format_wangzhe_summary_rows(summary)
  if type(summary) ~= "table" then return end
  for _, row in ipairs(summary) do
    if is_wangzhe_summary_row(row) then
      row.turn = tostring(row.wangzhe_score)
      row.recover = translate_general_key(row.wangzhe_death_source)
      row.damage = translate_general_list(row.wangzhe_kill_targets)
      row.damaged = WANGZHE_BLANK_COLUMN
      row.kill = WANGZHE_BLANK_COLUMN
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
      mark_wangzhe_row_result_translation()
      ret.wangzhe_score = data.wangzhe_score
      ret.wangzhe_kill_targets = translate_general_list(data.wangzhe_kill_targets)
      ret.wangzhe_death_source = translate_general_key(data.wangzhe_death_source)
      ret.wangzhe_overview = data.wangzhe_overview
      ret.honor = WANGZHE_BLANK_COLUMN
    end
    return ret
  end
end

local function patch_wangzhe_global_entitle(old_entitle)
  return function(data, seat, winner)
    local raw_data = raw_wangzhe_entitle_data(data)
    local ret = old_entitle(raw_data, seat, winner)
    if is_wangzhe_summary_row(data) then
      mark_wangzhe_row_result_translation()
      ret.wangzhe_score = data.wangzhe_score
      ret.wangzhe_kill_targets = translate_general_list(data.wangzhe_kill_targets)
      ret.wangzhe_death_source = translate_general_key(data.wangzhe_death_source)
      ret.wangzhe_overview = data.wangzhe_overview
      ret.honor = WANGZHE_BLANK_COLUMN
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
    Turn = "积分",
    Recover = "死亡来源",
    Damage = "击杀对象",
    Damaged = WANGZHE_BLANK_COLUMN,
    Kill = WANGZHE_BLANK_COLUMN,
    Honor = WANGZHE_BLANK_COLUMN,
  }

  function Fk:translate(src, lang)
    if self ~= Fk then
      return old_translate(Fk, self, src)
    end
    local result_title = translate_wangzhe_result_title(src)
    if result_title then
      return result_title
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

local function patch_ltk_summary_util(ltk_util)
  if not ltk_util or type(ltk_util.entitle) ~= "function" or ltk_util.__wangzhe_summary_patched then return end
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

for _, util_module in ipairs({
  "packages.freekill-core.ltk.client.util",
  "ltk.client.util",
}) do
  local ok, ltk_util = pcall(require, util_module)
  if ok then patch_ltk_summary_util(ltk_util) end
end

return {
  gamemodes,
  lords,
  generals,
  cards,
}
