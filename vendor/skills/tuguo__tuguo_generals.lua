local jiancheng = fk.CreateSkill {
  name = "wzzz_v__tg__jiancheng",
}

local function is_team_mode(room)
  local mode = room:getSettings("gameMode") or ""
  return room:isGameMode("1v1_mode") or room:isGameMode("2v2_mode") or room:isGameMode("3v3_mode") or
    mode:find("1v1", 1, true) ~= nil or mode:find("2v2", 1, true) ~= nil or
    mode:find("3v3", 1, true) ~= nil or mode:find("team", 1, true) ~= nil
end

Fk:loadTranslationTable {
  ["wzzz_v__tg__jiancheng"] = "坚城",
  [":wzzz_v__tg__jiancheng"] = "若本局为团队模式，亮将后，你可以失去“镇卫”，获得“守御”。",
}

jiancheng:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jiancheng.name) and is_team_mode(player.room) and
      player:hasSkill("wzzz_v__zhenwei", true) and not player:hasSkill("wzzz__shouyu", true)
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askForSkillInvoke(player, jiancheng.name, data)
  end,
  on_use = function(self, event, target, player, data)
    player.room:handleAddLoseSkills(player, "-wzzz_v__zhenwei|wzzz__shouyu", nil, false, true)
  end,
})

return jiancheng
