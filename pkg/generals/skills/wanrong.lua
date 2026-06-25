local wanrong = fk.CreateSkill {
  name = "wzzz__wanrong",
}

Fk:loadTranslationTable{
  ["wzzz__wanrong"] = "婉容",
  [":wzzz__wanrong"] = "当你使用或弃置方块牌时，你可以摸一张牌。",
  ["#wzzz__wanrong-invoke"] = "婉容：你可以摸一张牌",

  ["$wzzz__wanrong1"] = "呵哼哼~",
  ["$wzzz__wanrong2"] = "看这里，看这里哦~",
}

wanrong:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wanrong.name) and data.card and data.card.suit == Card.Diamond
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = wanrong.name,
      prompt = "#wzzz__wanrong-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, wanrong.name)
  end,
})

wanrong:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(wanrong.name) then return false end
    for _, move in ipairs(data) do
      if move.from == player and move.moveReason == fk.ReasonDiscard then
        for _, info in ipairs(move.moveInfo) do
          if Fk:getCardById(info.cardId).suit == Card.Diamond then
            return true
          end
        end
      end
    end
  end,
  trigger_times = function(self, event, target, player, data)
    local n = 0
    for _, move in ipairs(data) do
      if move.from == player and move.moveReason == fk.ReasonDiscard then
        for _, info in ipairs(move.moveInfo) do
          if Fk:getCardById(info.cardId).suit == Card.Diamond then
            n = n + 1
          end
        end
      end
    end
    return n
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = wanrong.name,
      prompt = "#wzzz__wanrong-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, wanrong.name)
  end,
})

return wanrong
