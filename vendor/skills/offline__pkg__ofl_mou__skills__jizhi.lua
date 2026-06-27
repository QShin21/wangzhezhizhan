local jizhi = fk.CreateSkill{
  name = "wzzz_v__ofl_mou__jizhi",
}

Fk:loadTranslationTable{
  ["wzzz_v__ofl_mou__jizhi"] = "集智",
  [":wzzz_v__ofl_mou__jizhi"] = "当你使用一张非转化锦囊牌时，你可以摸一张牌且本回合手牌上限+1。",

  ["$wzzz_v__ofl_mou__jizhi1"] = "奇思机上巧，妙想晦下明。",
  ["$wzzz_v__ofl_mou__jizhi2"] = "愚，固曾有，智，从未绝。",
}

jizhi:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jizhi.name) and
      data.card.type == Card.TypeTrick and not data.card:isVirtual()
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = jizhi.name,
    })
  end,
  on_use = function(self, event, target, player, data)
    player.room:addPlayerMark(player, MarkEnum.AddMaxCardsInTurn, 1)
    player:drawCards(1, jizhi.name)
  end,
})

return jizhi
