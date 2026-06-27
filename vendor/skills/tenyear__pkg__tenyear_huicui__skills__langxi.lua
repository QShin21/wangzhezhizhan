local langxi = fk.CreateSkill {
  name = "wzzz_v__langxi",
}

Fk:loadTranslationTable{
  ["wzzz_v__langxi"] = "狼袭",
  [":wzzz_v__langxi"] = "准备阶段，你可以选择一名体力值不大于你的其他角色，并亮出牌堆顶的一张牌，若此牌点数为：6~9，你对其造成1点伤害；10~K，你对其造成2点伤害；5，你可以重复此流程。",

  ["#wzzz_v__langxi-choose"] = "狼袭：选择一名体力值不大于你的其他角色并亮出牌堆顶一张牌",
  ["#wzzz_v__langxi-repeat"] = "狼袭：你可以重复此流程",

  ["$wzzz_v__langxi1"] = "袭夺之势，如狼噬骨。",
  ["$wzzz_v__langxi2"] = "引吾至此，怎能不袭掠之？"
}

langxi:addEffect(fk.EventPhaseStart, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(langxi.name) and player.phase == Player.Start and
      table.find(player.room:getOtherPlayers(player, false), function(p)
        return p.hp <= player.hp
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      return p.hp <= player.hp
    end)
    local to = room:askToChoosePlayers(player, {
      targets = targets,
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__langxi-choose",
      skill_name = langxi.name,
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
    while not player.dead and not to.dead do
      local ids = room:getNCards(1)
      if #ids == 0 then return end
      room:turnOverCardsFromDrawPile(player, ids, langxi.name)
      local card = Fk:getCardById(ids[1])
      if card.number >= 6 and card.number <= 9 then
        room:damage({
          from = player,
          to = to,
          damage = 1,
          skillName = langxi.name,
        })
      elseif card.number >= 10 and card.number <= 13 then
        room:damage({
          from = player,
          to = to,
          damage = 2,
          skillName = langxi.name,
        })
      end
      room:moveCardTo(ids, Card.DiscardPile, nil, fk.ReasonPutIntoDiscardPile, langxi.name, nil, true, player)
      if card.number ~= 5 or player.dead or to.dead or not room:askToSkillInvoke(player, {
        skill_name = langxi.name,
        prompt = "#wzzz_v__langxi-repeat",
      }) then
        break
      end
    end
  end,
})

return langxi
