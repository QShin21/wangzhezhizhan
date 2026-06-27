local mingzhe = fk.CreateSkill {
  name = "wzzz_v__mingzhe",
}

Fk:loadTranslationTable{
  ["wzzz_v__mingzhe"] = "明哲",
  [":wzzz_v__mingzhe"] = "当你于回合外或摸牌阶段失去红色牌时，你可以展示之并摸一张牌。",
  ["#wzzz_v__mingzhe-invoke"] = "明哲：是否展示失去的红色牌并摸%arg张牌？",

  ["$wzzz_v__mingzhe1"] = "明以洞察，哲以保身。",
  ["$wzzz_v__mingzhe2"] = "塞翁失马，焉知非福？",
}

mingzhe:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(mingzhe.name) and
      (player.room.current ~= player or player.phase == Player.Draw) and
      not (player.phase == Player.Draw and player:usedSkillTimes(mingzhe.name, Player.HistoryPhase) > 0) then
      local cards = {}
      for _, move in ipairs(data) do
        if move.from == player then
          for _, info in ipairs(move.moveInfo) do
            if (info.fromArea == Card.PlayerHand or info.fromArea == Card.PlayerEquip) and
              Fk:getCardById(info.cardId).color == Card.Red then
              table.insert(cards, info.cardId)
            end
          end
        end
      end
      if #cards > 0 then
        event:setCostData(self, {cards = cards})
        return true
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    local cards = event:getCostData(self).cards
    return player.room:askToSkillInvoke(player, {
      skill_name = mingzhe.name,
      prompt = "#wzzz_v__mingzhe-invoke:::"..#cards,
    })
  end,
  on_use = function(self, event, target, player, data)
    local cards = event:getCostData(self).cards
    player:showCards(cards)
    if not player.dead then
      player:drawCards(#cards, mingzhe.name)
    end
  end,
})

return mingzhe
