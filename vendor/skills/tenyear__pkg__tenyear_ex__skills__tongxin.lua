local tongxin = fk.CreateSkill {
  name = "wzzz_v__ty_ex__tongxin",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__tongxin"] = "同心",
  [":wzzz_v__ty_ex__tongxin"] = "（团队模式中失去此技能）限定技，出牌阶段开始时，你可以令你本回合使用的第一张【杀】攻击范围+2。",
  ["#wzzz_v__ty_ex__tongxin-invoke"] = "同心：令你本回合使用的第一张【杀】攻击范围+2",
}

local function is_team_mode(room)
  local mode = room:getSettings("gameMode") or ""
  return room:isGameMode("1v1_mode") or room:isGameMode("2v2_mode") or room:isGameMode("3v3_mode") or
    mode:find("1v1", 1, true) ~= nil or mode:find("2v2", 1, true) ~= nil or
    mode:find("3v3", 1, true) ~= nil or mode:find("team", 1, true) ~= nil
end

tongxin:addEffect(fk.GameStart, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tongxin.name) and is_team_mode(player.room)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:handleAddLoseSkills(player, "-" .. tongxin.name, nil, false, true)
  end,
})

tongxin:addEffect(fk.EventPhaseStart, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(tongxin.name) and player.phase == Player.Play and
      player:usedSkillTimes(tongxin.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = tongxin.name,
      prompt = "#wzzz_v__ty_ex__tongxin-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@wzzz_v__ty_ex__tongxin-turn", 1)
  end,
})

tongxin:addEffect("atkrange", {
  correct_func = function(self, from, to)
    if from:getMark("@@wzzz_v__ty_ex__tongxin-turn") > 0 then
      return 2
    end
  end,
})

tongxin:addEffect(fk.CardUsing, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("@@wzzz_v__ty_ex__tongxin-turn") > 0 and
      data.card and data.card.trueName == "slash"
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@wzzz_v__ty_ex__tongxin-turn", 0)
  end,
})

return tongxin
