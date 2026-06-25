local wzzz_v__cunmu = fk.CreateSkill {
  name = "wzzz_v__cunmu",
  tags = {Skill.Compulsory},
}

Fk:loadTranslationTable{
  ["wzzz_v__cunmu"] = "寸目",
  [":wzzz_v__cunmu"] = "锁定技，当你摸牌时，改为从牌堆底摸牌。",

  ["$wzzz_v__cunmu_xuyou1"] = "哼！目光所及，短寸之间。",
  ["$wzzz_v__cunmu_xuyou2"] = "狭目之见，只能窥底。",
}

wzzz_v__cunmu:addEffect(fk.BeforeDrawCard, {
  anim_type = "negative",
  on_use = function(self, event, target, player, data)
    data.fromPlace = "bottom"
  end,
})

wzzz_v__cunmu:addTest(function (room, me)
  FkTest.runInRoom(function ()
    room:handleAddLoseSkills(me, wzzz_v__cunmu.name)
  end)
  local card = room:printCard("slash", Card.Spade, 1)
  FkTest.runInRoom(function ()
    room:moveCards({
      ids = {card.id},
      moveReason = fk.ReasonJustMove,
      toArea = Card.DrawPile,
      drawPilePosition = -1,
    })
    me:drawCards(1, wzzz_v__cunmu.name)
  end)
  lu.assertEquals(me:getCardIds(Player.Hand), {card.id})

  local iron_chain = room:printCard("iron_chain", Card.Spade, 1)
  FkTest.setNextReplies(me, {FkTest.ReplyUseSkill("recast", nil, {iron_chain.id})})
  FkTest.runInRoom(function ()
    room:moveCards({
      ids = {card.id},
      moveReason = fk.ReasonJustMove,
      fromArea = Card.PlayerHand,
      from = me,
      toArea = Card.DrawPile,
      drawPilePosition = -1,
    })
    me:gainAnExtraPhase(Player.Play)
  end)
end)

return wzzz_v__cunmu
