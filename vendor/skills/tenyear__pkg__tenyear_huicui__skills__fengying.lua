local fengying = fk.CreateSkill {
  name = "wzzz_v__ty__fengying",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__fengying"] = "奉迎",
  [":wzzz_v__ty__fengying"] = "限定技，出牌阶段，你可以弃置所有手牌并于此回合结束后执行一个额外的回合。此额外的回合开始时，若你已受伤且体力值为全场最少，你可以将手牌摸至体力值。",

  ["#wzzz_v__ty__fengying"] = "奉迎：你可以弃置所有手牌，此回合结束后执行一个额外回合！",

  ["$wzzz_v__ty__fengying1"] = "二臣恭奉，以迎皇嗣。",
  ["$wzzz_v__ty__fengying2"] = "奉旨典选，以迎忠良。",
}

fengying:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#wzzz_v__ty__fengying",
  card_num = 0,
  target_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(fengying.name, Player.HistoryGame) == 0 and
      table.find(player:getCardIds("h"), function(id)
        return not player:prohibitDiscard(Fk:getCardById(id))
      end)
  end,
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    player:throwAllCards("h", fengying.name)
    if not player.dead then
      player:gainAnExtraTurn(true, fengying.name)
    end
  end,
})

fengying:addEffect(fk.TurnStart, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getCurrentExtraTurnReason() == fengying.name and
      player:isWounded() and player:getHandcardNum() < player.hp and
      table.every(player.room.alive_players, function (p)
        return p.hp >= player.hp
      end)
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, { skill_name = fengying.name })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(player.hp - player:getHandcardNum(), fengying.name)
  end,
})

return fengying
