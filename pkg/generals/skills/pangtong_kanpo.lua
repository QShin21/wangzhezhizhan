local pangtongKanpo = fk.CreateSkill {
  name = "wzzz_v__pangtong__kanpo",
}

Fk:loadTranslationTable {
  ["wzzz_v__pangtong__kanpo"] = "看破",
  [":wzzz_v__pangtong__kanpo"] = "你可以将一张黑色牌当【无懈可击】使用；你的【无懈可击】不能被响应。",
  ["#wzzz_v__pangtong__kanpo"] = "看破：你可以将一张黑色牌当【无懈可击】使用",
}

pangtongKanpo:addEffect("viewas", {
  anim_type = "control",
  pattern = "nullification",
  prompt = "#wzzz_v__pangtong__kanpo",
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|black",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local card = Fk:cloneCard("nullification")
    card.skillName = pangtongKanpo.name
    card:addSubcard(cards[1])
    return card
  end,
  enabled_at_response = function(self, player, response)
    return not response
  end,
  enabled_at_nullification = function(self, player, data)
    return #player:getCardIds("he") > 0 or #player:getHandlyIds(false) > 0
  end,
})

pangtongKanpo:addEffect(fk.PreCardUse, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(pangtongKanpo.name) and
      data.card.trueName == "nullification"
  end,
  on_refresh = function(self, event, target, player, data)
    data.disresponsiveList = table.simpleClone(player.room.players)
  end,
})

return pangtongKanpo
