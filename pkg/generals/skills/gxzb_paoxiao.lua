local gxzbPaoxiao = fk.CreateSkill {
  name = "wzzz_v__gxzb__paoxiao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__gxzb__paoxiao"] = "咆哮",
  [":wzzz_v__gxzb__paoxiao"] = "锁定技，你使用【杀】无次数限制，每回合你使用第二张【杀】时，摸一张牌。",
}

gxzbPaoxiao:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card)
    return player:hasSkill(gxzbPaoxiao.name) and card and skill.trueName == "slash_skill" and
      scope == Player.HistoryPhase
  end,
})

gxzbPaoxiao:addEffect(fk.CardUsing, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(gxzbPaoxiao.name) and
      data.card.trueName == "slash" and player:usedCardTimes("slash") == 2
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, gxzbPaoxiao.name)
  end,
})

return gxzbPaoxiao
