local wzzz_v__bingyi = fk.CreateSkill {
  name = "wzzz_v__bingyi"
}

Fk:loadTranslationTable{
  ["wzzz_v__bingyi"] = "秉壹",
  [":wzzz_v__bingyi"] = "结束阶段，你可以展示所有手牌，若其中红色/黑色牌更多，你选择至多等量名角色并观看牌堆顶/牌堆底等量张牌，然后将这些牌分配给这些角色各一张。",

  ["#wzzz_v__bingyi-choose"] = "秉壹：选择至多%arg名角色，各分配一张牌",
  ["#wzzz_v__bingyi-give"] = "秉壹：选择要分配给 %dest 的一张牌",

  ["$wzzz_v__bingyi1"] = "公正无私，秉持如一。",
  ["$wzzz_v__bingyi2"] = "诸君看仔细了！",
}

wzzz_v__bingyi:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__bingyi.name) and player.phase == Player.Finish and
      not player:isKongcheng()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = player:getCardIds("h")
    player:showCards(cards)
    if player.dead then return end
    local red, black = 0, 0
    for _, id in ipairs(cards) do
      local color = Fk:getCardById(id).color
      if color == Card.Red then
        red = red + 1
      elseif color == Card.Black then
        black = black + 1
      end
    end
    if red ~= black then
      local fromTop = red > black
      local n = math.max(red, black)
      local tos = room:askToChoosePlayers(player, {
        skill_name = wzzz_v__bingyi.name,
        min_num = 1,
        max_num = n,
        targets = room.alive_players,
        prompt = "#wzzz_v__bingyi-choose:::"..n,
        cancelable = true,
      })
      if #tos > 0 then
        room:sortByAction(tos)
        n = #tos
        local pileCards = {}
        if fromTop then
          pileCards = room:getNCards(n)
        else
          for i = math.max(1, #room.draw_pile - n + 1), #room.draw_pile do
            table.insert(pileCards, room.draw_pile[i])
          end
        end
        if #pileCards == 0 then return end
        room:turnOverCardsFromDrawPile(player, pileCards, wzzz_v__bingyi.name)
        for _, p in ipairs(tos) do
          if not p.dead and #pileCards > 0 then
            local id = pileCards[1]
            if #pileCards > 1 then
              local chosen = room:askToCards(player, {
                min_num = 1,
                max_num = 1,
                include_equip = false,
                skill_name = wzzz_v__bingyi.name,
                pattern = tostring(Exppattern{ id = pileCards }),
                prompt = "#wzzz_v__bingyi-give::"..p.id,
                expand_pile = pileCards,
                cancelable = false,
              })
              id = chosen[1]
            end
            table.removeOne(pileCards, id)
            room:moveCardTo(id, Card.PlayerHand, p, fk.ReasonJustMove, wzzz_v__bingyi.name, nil, false, player)
          end
        end
      end
    end
  end,
})

return wzzz_v__bingyi
