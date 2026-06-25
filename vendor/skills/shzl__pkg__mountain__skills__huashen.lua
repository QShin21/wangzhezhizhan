local huashen = fk.CreateSkill {
  name = "wzzz_v__huashen",
}

Fk:loadTranslationTable{
  ["wzzz_v__huashen"] = "化身",
  [":wzzz_v__huashen"] = "游戏开始时，你将三张未加入游戏的武将牌扣置于此武将牌一侧，称为“化身”，然后亮出其中一张并声明此“化身”的一个技能（主公技、限定技、觉醒技除外），你视为拥有该技能；回合开始时和回合结束后，你可以更改亮出的“化身”和声明的技能；你的性别和势力视为与亮出的“化身”相同。你不能由于“化身”技能增加体力上限。",

  ["@[private]&huanshen"] = "化身",
  ["#wzzz_v__huashen"] = "化身：请选择要化身的技能",
  ["@huanshen_skill"] = "化身",

  ["$wzzz_v__huashen1"] = "哼，肉眼凡胎，岂能窥视仙人变幻？",
  ["$wzzz_v__huashen2"] = "万物苍生，幻化由心。",
}

local U = require "packages.wangzhezhizhan.vendor.modules.utility.utility"

WzzzHuashen = WzzzHuashen or {}
local Huashen = WzzzHuashen

local BANNED_HUASHEN_GENERALS = {
  wzzz__zhugedan = true,
  wzzz__zhoutai = true,
  wzzz__xuyou = true,
  wzzz__xiahouba = true,
  wzzz__lvbu = true,
}

local MODIFIED_MARK = "wzzz_v__huashen_modified_skills"
local LOST_MARK = "wzzz_v__huashen_lost_skills"
local TIMING_BLOCK_MARK = "wzzz_v__huashen_timing_block-turn"

local function getMarkTable(player, mark)
  local value = player:getMark(mark)
  if type(value) == "table" then return table.simpleClone(value) end
  return {}
end

local function getGeneralTrueName(general)
  if not general then return "" end
  return general.trueName or Fk:translate(general.name)
end

local function getGeneralTitle(general)
  if not general then return "" end
  return general.title or Fk:translate("#" .. general.name)
end

local function isSameNameTitleGeneral(a, b)
  local ga, gb = Fk.generals[a], Fk.generals[b]
  if not ga or not gb then return a == b end
  return getGeneralTrueName(ga) == getGeneralTrueName(gb) and getGeneralTitle(ga) == getGeneralTitle(gb)
end

local function isAllowedHuashenGeneral(player, name)
  if BANNED_HUASHEN_GENERALS[name] or not Fk.generals[name] then return false end
  local lord = player.room:getLord()
  if lord then
    if isSameNameTitleGeneral(name, lord.general) or isSameNameTitleGeneral(name, lord.deputyGeneral) then
      return false
    end
  end
  return true
end

local function normalizeGeneralPick(picked)
  if picked == nil then return {} end
  if type(picked) == "table" then return picked end
  return { picked }
end

local function getAvailableHuashenPool(player)
  return table.filter(player.room.general_pile, function(name)
    return isAllowedHuashenGeneral(player, name)
  end)
end

local function drawHuashenGenerals(player, n)
  local room = player.room
  local pool = getAvailableHuashenPool(player)
  if #pool == 0 or n <= 0 then return {} end
  local picked = normalizeGeneralPick(room:tableRandomPick(pool, math.min(n, #pool)))
  for _, name in ipairs(picked) do
    table.removeOne(room.general_pile, name)
  end
  return picked
end

local function recordModifiedSkill(player, from, to)
  if not from or not to or from == to then return end
  local modified = getMarkTable(player, MODIFIED_MARK)
  modified[from] = to
  player.room:setPlayerMark(player, MODIFIED_MARK, modified)
end

local function recordLostSkill(player, skill)
  if not skill then return end
  local lost = getMarkTable(player, LOST_MARK)
  lost[skill] = true
  player.room:setPlayerMark(player, LOST_MARK, lost)
end

local function getEffectiveHuashenSkill(player, skill)
  local lost = getMarkTable(player, LOST_MARK)
  if lost[skill] then return end
  local modified = getMarkTable(player, MODIFIED_MARK)
  local seen = {}
  while modified[skill] and not seen[skill] do
    seen[skill] = true
    skill = modified[skill]
    if lost[skill] then return end
  end
  return skill
end

local function splitSkillChanges(changes)
  local removed, added = {}, {}
  if type(changes) ~= "string" then return removed, added end
  for item in string.gmatch(changes, "[^|]+") do
    if string.sub(item, 1, 1) == "-" then
      removed[string.sub(item, 2)] = true
    elseif item ~= "" then
      table.insert(added, item)
    end
  end
  return removed, added
end

local function ensureRoomPatch(room)
  if room._wzzz_huashen_patched then return end
  room._wzzz_huashen_patched = true
  local rawHandleAddLoseSkills = room.handleAddLoseSkills
  room.handleAddLoseSkills = function(self, target, changes, ...)
    rawHandleAddLoseSkills(self, target, changes, ...)
    if self._wzzz_huashen_switching or not target or target.dead then return end
    local current = target:getMark("@huanshen_skill")
    if type(current) ~= "string" or current == "" then return end
    if not target:hasSkill(huashen.name, true) then return end

    local removed, added = splitSkillChanges(changes)
    if not removed[current] then return end
    if #added > 0 then
      recordModifiedSkill(target, current, added[1])
      self:setPlayerMark(target, "@huanshen_skill", added[1])
    else
      recordLostSkill(target, current)
      self:setPlayerMark(target, "@huanshen_skill", 0)
    end
  end
end

local function getAvailableSkills(player, general)
  local skills = {}
  for _, skill_name in ipairs(general:getSkillNameList()) do
    local s = Fk.skills[skill_name]
    if s and not table.find({Skill.Lord, Skill.Limited, Skill.Wake}, function (tag)
        return s:hasTag(tag)
      end) then
      if not s:hasTag(Skill.AttachedKingdom) or table.contains(s:getSkeleton().attached_kingdom, player.kingdom) then
        local effective = getEffectiveHuashenSkill(player, s.name)
        if effective and Fk.skills[effective] and not table.contains(skills, effective) then
          table.insert(skills, effective)
        end
      end
    end
  end
  return skills
end

Huashen.getAvailableGenerals = getAvailableHuashenPool
Huashen.drawGenerals = drawHuashenGenerals
Huashen.isHuashenSkill = function(player, skill)
  return player and player:getMark("@huanshen_skill") == skill
end
Huashen.shouldSkipOpeningTiming = function(player, skill)
  return Huashen.isHuashenSkill(player, skill)
end
Huashen.shouldPreventMaxHpGain = function(player, skill)
  return Huashen.isHuashenSkill(player, skill)
end
Huashen.isBlockedTiming = function(player, skill, timing)
  if not Huashen.isHuashenSkill(player, skill) then return false end
  local mark = player:getMark(TIMING_BLOCK_MARK)
  return type(mark) == "table" and mark.skill == skill and mark.timing == timing
end

local function DoHuashen(player, timing)
  local room = player.room
  ensureRoomPatch(room)
  local huashens = table.filter(U.getPrivateMark(player, "&huanshen"), function(name)
    return isAllowedHuashenGeneral(player, name)
  end)
  U.setPrivateMark(player, "&huanshen", huashens)
  if huashens == 0 or #huashens == 0 then return end
  local name = room:askToChooseGeneral(player, {
    generals = huashens,
    n = 1,
  })
  local general = Fk.generals[name]

  local kingdom = general.kingdom
  if general.kingdom == "god" or general.subkingdom then
    local allKingdoms = {}
    if general.kingdom == "god" then
      allKingdoms = {"wei", "shu", "wu", "qun", "jin"}
    elseif general.subkingdom then
      allKingdoms = { general.kingdom, general.subkingdom }
    end
    kingdom = room:askToChoice(player, {
      choices = allKingdoms,
      skill_name = "AskForKingdom",
      prompt = "#ChooseInitialKingdom",
    })
  end
  player.kingdom = kingdom
  room:broadcastProperty(player, "kingdom")
  player.gender = general.gender
  room:broadcastProperty(player, "gender")
  local original_general = player.general
  player.general = general.name
  room:broadcastProperty(player, "general")

  local skills = getAvailableSkills(player, general)
  if #skills > 0 then
    local skill = room:askToChoice(player, {
      choices = skills,
      skill_name = "wzzz_v__huashen",
      prompt = "#wzzz_v__huashen",
      detailed = true,
    })
    local huanshen_skill
    local old_skill = player:getMark("@huanshen_skill")
    if type(old_skill) == "string" and old_skill ~= "" and old_skill ~= skill then
      huanshen_skill = "-" .. old_skill .. "|" .. skill
    elseif old_skill ~= skill then
      huanshen_skill = skill
    end
    if huanshen_skill then
      room._wzzz_huashen_switching = true
      room:handleAddLoseSkills(player, huanshen_skill, nil, true, false)
      room._wzzz_huashen_switching = false
    end
    room:setPlayerMark(player, "@huanshen_skill", skill)
    room:setPlayerMark(player, TIMING_BLOCK_MARK, { skill = skill, timing = timing })
  end
  player.general = original_general
  room:broadcastProperty(player, "general")
end

huashen:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huashen.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    ensureRoomPatch(room)
    local generals = drawHuashenGenerals(player, 3)
    U.setPrivateMark(player, "&huanshen", generals)
    DoHuashen(player, "GameStart")
  end,
})
huashen:addEffect(fk.TurnStart, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(huashen.name)
  end,
  on_cost = function (self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = huashen.name,
    })
  end,
  on_use = function(self, event, target, player, data)
    DoHuashen(player, "TurnStart")
  end,
})
huashen:addEffect(fk.TurnEnd, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(huashen.name)
  end,
  on_cost = function (self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = huashen.name,
    })
  end,
  on_use = function(self, event, target, player, data)
    DoHuashen(player, "TurnEnd")
  end,
})

return huashen
