local xiahoubaPaoxiao = fk.CreateSkill {
  name = "wzzz_v__xiahouba__paoxiao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__xiahouba__paoxiao"] = "咆哮",
  [":wzzz_v__xiahouba__paoxiao"] = "锁定技，你使用【杀】无次数限制；你使用的【杀】被抵消时，本回合你下一次因【杀】造成的伤害+1。",
  ["@wzzz_v__xiahouba__paoxiao-turn"] = "咆哮",
}

xiahoubaPaoxiao:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card)
    return player:hasSkill(xiahoubaPaoxiao.name) and card and
      skill.trueName == "slash_skill" and scope == Player.HistoryPhase
  end,
})

xiahoubaPaoxiao:addEffect(fk.CardEffectCancelledOut, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player == target and data.card.trueName == "slash" and player:hasSkill(xiahoubaPaoxiao.name)
  end,
  on_use = function(self, event, target, player, data)
    player.room:addPlayerMark(player, "@wzzz_v__xiahouba__paoxiao-turn")
  end,
})

xiahoubaPaoxiao:addEffect(fk.DamageCaused, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return player == target and data.card and data.card.trueName == "slash" and
      player.room.logic:damageByCardEffect() and
      player:getMark("@wzzz_v__xiahouba__paoxiao-turn") > 0 and
      player:hasSkill(xiahoubaPaoxiao.name)
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(player:getMark("@wzzz_v__xiahouba__paoxiao-turn"))
    player.room:setPlayerMark(player, "@wzzz_v__xiahouba__paoxiao-turn", 0)
  end,
})

return xiahoubaPaoxiao
