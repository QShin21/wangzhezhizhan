local yisuan = fk.CreateSkill{
  name = "wzzz_v__xh__yisuan",
}

Fk:loadTranslationTable{
  ["wzzz_v__xh__yisuan"] = "亦算",
  [":wzzz_v__xh__yisuan"] = "出牌阶段限一次，当你使用的普通锦囊牌结算结束后进入弃牌堆时，你可以失去1点体力或减1点体力上限，获得之。",

  ["#wzzz_v__xh__yisuan-invoke"] = "亦算：是否付出代价获得%arg？",
  ["#wzzz_v__xh__yisuan-choice"] = "亦算：选择代价",
  ["$wzzz_v__xh__yisuan1"] = "吾亦能善算谋划。",
  ["$wzzz_v__xh__yisuan2"] = "算计人心，我也可略施一二。",
}

yisuan:addEffect(fk.CardUseFinished, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(yisuan.name, true) and player.phase == Player.Play and
      player.room.current == player and player:usedSkillTimes(yisuan.name, Player.HistoryPhase) == 0 and
      data.card and data.card:isCommonTrick() and not data.card:isConverted() and
      data.card.id and data.card.id > 0
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "wzzz_v__xh__yisuan_pending-phase", data.card.id)
  end,
})

yisuan:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(yisuan.name) or player:usedSkillTimes(yisuan.name, Player.HistoryPhase) > 0 then return false end
    local id = player:getMark("wzzz_v__xh__yisuan_pending-phase")
    if type(id) ~= "number" or id == 0 then return false end
    for _, move in ipairs(data) do
      if move.toArea == Card.DiscardPile then
        for _, info in ipairs(move.moveInfo) do
          if info.cardId == id and player.room:getCardArea(id) == Card.DiscardPile then
            event:setCostData(self, {card_id = id})
            return true
          end
        end
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local id = event:getCostData(self).card_id
    if room:askToSkillInvoke(player, {
      skill_name = yisuan.name,
      prompt = "#wzzz_v__xh__yisuan-invoke:::" .. Fk:getCardById(id):toLogString(),
    }) then
      local choice = room:askToChoice(player, {
        choices = { "loseHp", "loseMaxHp" },
        skill_name = yisuan.name,
        prompt = "#wzzz_v__xh__yisuan-choice",
      })
      event:setCostData(self, { choice = choice, card_id = id })
      return true
    end
  end,

  on_use = function(self, event, target, player, data)
    local room = player.room
    local cost = event:getCostData(self) or {}
    local choice = cost.choice
    local cid = cost.card_id
    if not cid then return end
    room:setPlayerMark(player, "wzzz_v__xh__yisuan_pending-phase", 0)

    if choice == "loseMaxHp" then
      room:changeMaxHp(player, -1)
    else
      room:loseHp(player, 1, yisuan.name)
    end
    if player.dead then return end

    if room:getCardArea(cid) == Card.DiscardPile then
      room:obtainCard(player, cid, true, fk.ReasonJustMove, player, yisuan.name)
    end
  end,
})

return yisuan
