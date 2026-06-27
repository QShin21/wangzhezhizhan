local botu = fk.CreateSkill{
  name = "wzzz_v__botu",
}

Fk:loadTranslationTable {
  ["wzzz_v__botu"] = "博图",
  [":wzzz_v__botu"] = "每轮限两次，你的回合结束后，若本回合置入弃牌堆的牌包含四种花色，你可以执行一个额外的回合。",

  ["@wzzz_v__botu-turn"] = "博图",

  ["$wzzz_v__botu1"] = "厚积而薄发。",
  ["$wzzz_v__botu2"] = "我胸怀的是这天下！",
}

botu:addEffect(fk.TurnEnd, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(botu.name) and
      not (WzzzHuashen and WzzzHuashen.isBlockedTiming(player, botu.name, "TurnEnd")) and
      player:usedSkillTimes(botu.name, Player.HistoryRound) < 2 then
      local suits = {}
      player.room.logic:getEventsOfScope(GameEvent.MoveCards, 1, function (e)
        for _, move in ipairs(e.data) do
          if move.toArea == Card.DiscardPile then
            for _, info in ipairs(move.moveInfo) do
              table.insertIfNeed(suits, Fk:getCardById(info.cardId).suit)
            end
          end
        end
      end, Player.HistoryTurn)
      table.removeOne(suits, Card.NoSuit)
      return #suits == 4
    end
  end,
  on_use = function(self, event, target, player, data)
    player:gainAnExtraTurn()
  end,
})

botu:addEffect(fk.AfterCardsMove, {
  can_refresh = function (self, event, target, player, data)
    return player.room.current == player and player:hasSkill(botu.name, true) and
      #player:getTableMark("@wzzz_v__botu-turn") < 4
  end,
  on_refresh = function (self, event, target, player, data)
    for _, move in ipairs(data) do
      if move.toArea == Card.DiscardPile then
        for _, info in ipairs(move.moveInfo) do
          local suit = Fk:getCardById(info.cardId):getSuitString(true)
          if suit ~= "log_nosuit" then
            player.room:addTableMarkIfNeed(player, "@wzzz_v__botu-turn", suit)
          end
        end
      end
    end
  end
})

return botu
