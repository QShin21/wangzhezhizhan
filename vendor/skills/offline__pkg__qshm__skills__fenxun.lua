local fenxun = fk.CreateSkill {
  name = "wzzz_v__qshm__fenxun",
}

Fk:loadTranslationTable{
  ["wzzz_v__qshm__fenxun"] = "奋迅",
  [":wzzz_v__qshm__fenxun"] = "出牌阶段限一次，你可以弃置一张牌并选择一名其他角色，然后本回合你计算与其的距离视为1，若如此做，此阶段结束时，若你本阶段使用【杀】对距离1以内的角色造成过至少2点伤害，你可以摸两张牌。",

  ["#wzzz_v__qshm__fenxun"] = "奋迅：弃一张牌，本回合你至一名其他角色的距离视为1",
  ["@wzzz_v__qshm__fenxun-turn"] = "被奋迅",
  ["#wzzz_v__qshm__fenxun-draw"] = "奋迅：你本阶段使用【杀】造成过至少2点伤害，是否摸两张牌？",

  ["$wzzz_v__qshm__fenxun1"] = "端午竞舟，于中流击水，可立潮头！",
  ["$wzzz_v__qshm__fenxun2"] = "百舸争渡，驾艨艟弄潮，舍我其谁！",
}

fenxun:addEffect("active", {
  anim_type = "offensive",
  card_num = 1,
  target_num = 1,
  prompt = "#wzzz_v__qshm__fenxun",
  can_use = function(self, player)
    return player:usedSkillTimes(fenxun.name, Player.HistoryPhase) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    return not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:addTableMarkIfNeed(player, "wzzz_v__qshm__fenxun-turn", target.id)
    room:setPlayerMark(target, "@wzzz_v__qshm__fenxun-turn", 1)
    room:throwCard(effect.cards, fenxun.name, player, player)
  end,
})

fenxun:addEffect(fk.EventPhaseEnd, {
  anim_type = "drawcard",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    if target ~= player or player.phase ~= Player.Play or
      #player:getTableMark("wzzz_v__qshm__fenxun-turn") == 0 then
      return false
    end
    local damage = 0
    player.room.logic:getActualDamageEvents(1, function(e)
      local damageData = e.data
      if damageData.from == player and damageData.card and damageData.card.trueName == "slash" and
        player:distanceTo(damageData.to) <= 1 then
        damage = damage + damageData.damage
      end
    end, Player.HistoryPhase)
    return damage >= 2
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = fenxun.name,
      prompt = "#wzzz_v__qshm__fenxun-draw",
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(2, fenxun.name)
  end,
})

fenxun:addEffect("distance", {
  fixed_func = function(self, from, to)
    if table.contains(from:getTableMark("wzzz_v__qshm__fenxun-turn"), to.id) then
      return 1
    end
  end,
})

return fenxun
