local jiang = fk.CreateSkill {
  name = "wzzz_v__jiang",
}

Fk:loadTranslationTable{
  ["wzzz_v__jiang"] = "激昂",
  [":wzzz_v__jiang"] = "当你使用【决斗】或红色【杀】指定目标后，或成为【决斗】或红色【杀】目标后，你可以摸一张牌；【决斗】或红色【杀】因弃置进入弃牌堆后，你可以失去1点体力获得之（每回合限一次）。",
  ["#wzzz_v__jiang-obtain"] = "激昂：是否失去1点体力，获得一张进入弃牌堆的【决斗】或红色【杀】？",

  ["$wzzz_v__jiang1"] = "吾乃江东小霸王孙伯符！",
  ["$wzzz_v__jiang2"] = "江东子弟，何惧于天下！",
}

jiang:addEffect(fk.TargetSpecified, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiang.name) and data.firstTarget and
      ((data.card.trueName == "slash" and data.card.color == Card.Red) or data.card.name == "duel")
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, jiang.name)
  end,
})

jiang:addEffect(fk.TargetConfirmed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiang.name) and
      ((data.card.trueName == "slash" and data.card.color == Card.Red) or data.card.name == "duel")
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, jiang.name)
  end,
})

jiang:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(jiang.name) or player:getMark("wzzz_v__jiang_obtain-turn") > 0 or player.hp < 1 then
      return false
    end
    local cards = {}
    for _, move in ipairs(data) do
      if move.toArea == Card.DiscardPile and move.moveReason == fk.ReasonDiscard then
        for _, info in ipairs(move.moveInfo) do
          local card = Fk:getCardById(info.cardId)
          if card.name == "duel" or (card.trueName == "slash" and card.color == Card.Red) then
            table.insert(cards, info.cardId)
          end
        end
      end
    end
    cards = table.filter(cards, function(id)
      return player.room:getCardArea(id) == Card.DiscardPile
    end)
    if #cards > 0 then
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_cost = function(self, event, target, player, data)
    local cards = event:getCostData(self).cards
    if player.room:askToSkillInvoke(player, {
      skill_name = jiang.name,
      prompt = "#wzzz_v__jiang-obtain",
    }) then
      if #cards > 1 then
        cards = player.room:askToCards(player, {
          min_num = 1,
          max_num = 1,
          include_equip = false,
          skill_name = jiang.name,
          pattern = tostring(Exppattern{ id = cards }),
          expand_pile = cards,
          cancelable = false,
        })
      end
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "wzzz_v__jiang_obtain-turn", 1)
    room:loseHp(player, 1, jiang.name)
    if not player.dead then
      room:obtainCard(player, event:getCostData(self).cards, true, fk.ReasonPrey, player, jiang.name)
    end
  end,
})

local AI = Fk.Ltk.AI
jiang:addAI(AI.reuse("biyue", AI.InvokeStrategy))

return jiang
