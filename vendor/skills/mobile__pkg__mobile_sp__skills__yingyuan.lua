local yingyuan = fk.CreateSkill {
  name = "wzzz_v__yingyuan",
}

Fk:loadTranslationTable{
  ["wzzz_v__yingyuan"] = "应援",
  [":wzzz_v__yingyuan"] = "每回合限两次，当你于回合内使用的基本牌或普通锦囊牌结算结束后，你可以将之交给一名其他角色。",

  ["#wzzz_v__yingyuan-card"] = "应援：你可以将 %arg 交给一名其他角色",

  ["$wzzz_v__yingyuan_mobile__maliang1"] = "皇叔辅者少有，良当及时应召。",
  ["$wzzz_v__yingyuan_mobile__maliang2"] = "今幸明主亲召，良安可不应乎？",
}

yingyuan:addEffect(fk.CardUseFinished, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yingyuan.name) and player.room.current == player and
      (data.card.type == Card.TypeBasic or data.card:isCommonTrick()) and
      player.room:getCardArea(data.card) == Card.Processing and
      player:usedSkillTimes(yingyuan.name, Player.HistoryTurn) < 2 and
      #player.room:getOtherPlayers(player, false) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      skill_name = yingyuan.name,
      min_num = 1,
      max_num = 1,
      targets = room:getOtherPlayers(player, false),
      prompt = "#wzzz_v__yingyuan-card:::"..data.card:toLogString(),
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:moveCardTo(data.card, Card.PlayerHand, to, fk.ReasonGive, yingyuan.name, nil, true, player)
  end,
})

return yingyuan
