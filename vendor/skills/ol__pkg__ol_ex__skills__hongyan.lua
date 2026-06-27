local hongyan = fk.CreateSkill {
  name = "wzzz_v__ol_ex__hongyan",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__hongyan"] = "红颜",
  [":wzzz_v__ol_ex__hongyan"] = "锁定技，你的黑桃牌和你的黑桃判定牌视为红桃牌；若你的装备区里有牌，你的手牌上限等于你的体力上限。",

  ["$wzzz_v__ol_ex__hongyan1"] = "红颜娇花好，折花门前盼。",
  ["$wzzz_v__ol_ex__hongyan2"] = "我的容貌，让你心动了吗？",
}

hongyan:addEffect("filter", {
  card_filter = function(self, to_select, player, isJudgeEvent)
    return to_select.suit == Card.Spade and player:hasSkill(hongyan.name) and
      (table.contains(player:getCardIds("he"), to_select.id) or isJudgeEvent)
  end,
  view_as = function (self, player, card)
    return Fk:cloneCard(card.name, Card.Heart, card.number)
  end,
})

hongyan:addEffect("maxcards", {
  fixed_func = function (self, player)
    if player:hasSkill(hongyan.name) and #player:getCardIds("e") > 0 then
      return player.maxHp
    end
  end,
})

return hongyan
