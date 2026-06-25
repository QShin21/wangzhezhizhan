local mingjian = fk.CreateSkill {
  name = "wzzz_v__ty_ex__mingjian",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__mingjian"] = "明鉴",
  [":wzzz_v__ty_ex__mingjian"] = "出牌阶段限一次，你可以将所有手牌交给一名其他角色（至少一张），该角色于其下个回合使用【杀】的次数+1，手牌上限+1。",

  ["#wzzz_v__ty_ex__mingjian"] = "明鉴：将所有手牌交给一名其他角色，其下个回合手牌上限和【杀】次数+1",
  ["@@wzzz_v__ty_ex__mingjian"] = "明鉴",
  ["@@wzzz_v__ty_ex__mingjian-turn"] = "明鉴",

  ["$wzzz_v__ty_ex__mingjian1"] = "敌将寇边，还请将军领兵御之。",
  ["$wzzz_v__ty_ex__mingjian2"] = "逆贼滔乱，须得阁下出手相助。",
}

mingjian:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__ty_ex__mingjian",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return not player:isKongcheng() and player:usedSkillTimes(mingjian.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:addTableMark(target, "@@wzzz_v__ty_ex__mingjian", player.id)
    room:moveCardTo(player:getCardIds("h"), Player.Hand, target, fk.ReasonGive, mingjian.name, nil, false, player)
  end,
})

mingjian:addEffect(fk.TurnStart, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark("@@wzzz_v__ty_ex__mingjian") ~= 0
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(player, "@@wzzz_v__ty_ex__mingjian-turn", player:getMark("@@wzzz_v__ty_ex__mingjian"))
    room:addPlayerMark(player, MarkEnum.AddMaxCardsInTurn, #player:getTableMark("@@wzzz_v__ty_ex__mingjian"))
    room:setPlayerMark(player, "@@wzzz_v__ty_ex__mingjian", 0)
  end,
})

mingjian:addEffect("targetmod", {
  residue_func = function(self, player, skill, scope)
    if player:getMark("@@wzzz_v__ty_ex__mingjian-turn") ~= 0 and skill.trueName == "slash_skill" and scope == Player.HistoryPhase then
      return #player:getTableMark("@@wzzz_v__ty_ex__mingjian-turn")
    end
  end,
})

return mingjian
