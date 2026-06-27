local zhiyan = fk.CreateSkill{
  name = "wzzz_v__ol_ex__zhiyan",
}

Fk:loadTranslationTable{
  ["wzzz_v__ol_ex__zhiyan"] = "直言",
  [":wzzz_v__ol_ex__zhiyan"] = "结束阶段，你可以令一名角色摸一张牌并展示之，若此牌为：装备牌，则其使用之并回复1点体力；非装备牌，若其体力值不等于你，其失去1点体力。",

  ["#wzzz_v__ol_ex__zhiyan-choose"] = "直言：你可以令一名角色摸一张牌并展示之",
  ["#wzzz_v__ol_ex__zhiyan-use"] = "直言：请使用%arg",

  ["$wzzz_v__ol_ex__zhiyan1"] = "尔降虏，何敢与吾君齐马首乎！",
  ["$wzzz_v__ol_ex__zhiyan2"] = "当闭反开，当开反闭，匹夫何故反复？",
}

zhiyan:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and target.phase == Player.Finish and player:hasSkill(zhiyan.name)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      targets = room.alive_players,
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__ol_ex__zhiyan-choose",
      skill_name = zhiyan.name,
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
    local ids = to:drawCards(1, zhiyan.name)
    if #ids == 0 then return false end
    local id = ids[1]
    if not table.contains(to:getCardIds("h"), id) then return false end
    local card = Fk:getCardById(id)
    to:showCards(card)
    if not table.contains(to:getCardIds("h"), id) or to.dead then return false end
    room:delay(1000)
    if card.type == Card.TypeEquip then
      if to:canUse(card) then
        if to:canUseTo(card, to) then
          room:useCard({
            from = to,
            tos = {to},
            card = card,
          })
        else
          room:askToUseRealCard(to, {
            pattern = {card.id},
            skill_name = zhiyan.name,
            prompt = "#wzzz_v__ol_ex__zhiyan-use:::"..card:toLogString(),
            cancelable = false,
          })
        end
        if to:isWounded() and not to.dead then
          room:recover{
            who = to,
            num = 1,
            recoverBy = player,
            skillName = zhiyan.name
          }
        end
      end
    elseif to.hp ~= player.hp then
      room:loseHp(to, 1, zhiyan.name)
    end
  end,
})

return zhiyan
