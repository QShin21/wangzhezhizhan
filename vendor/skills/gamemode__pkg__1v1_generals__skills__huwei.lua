local huwei = fk.CreateSkill {
  name = "wzzz_v__v11__huwei",
}

local function is_team_mode(room)
  local mode = room:getSettings("gameMode") or ""
  return room:isGameMode("1v1_mode") or room:isGameMode("2v2_mode") or room:isGameMode("3v3_mode") or
    mode:find("1v1", 1, true) ~= nil or mode:find("2v2", 1, true) ~= nil or
    mode:find("3v3", 1, true) ~= nil or mode:find("team", 1, true) ~= nil
end

Fk:loadTranslationTable {
  ["wzzz_v__v11__huwei"] = "虎威",
  [":wzzz_v__v11__huwei"] = "若本局为团队模式，亮将后，你可以失去“义绝”，获得“忠义”。",
}

huwei:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huwei.name) and is_team_mode(player.room) and
      player:hasSkill("wzzz_v__ex__yijue", true) and not player:hasSkill("wzzz_v__zhongyi", true) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, huwei.name))
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, { skill_name = huwei.name })
  end,
  on_use = function(self, event, target, player, data)
    player.room:handleAddLoseSkills(player, "-wzzz_v__ex__yijue|wzzz_v__zhongyi", nil, false, true)
  end,
})

return huwei
