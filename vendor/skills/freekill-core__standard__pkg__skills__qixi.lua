local qixi = fk.CreateSkill {
  name = "wzzz_v__qixi",
}

qixi:addEffect("viewas", {
  anim_type = "control",
  pattern = "dismantlement",
  prompt = "#wzzz_v__qixi",
  -- mute_card = true,
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|black",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local c = Fk:cloneCard("dismantlement")
    c.skillName = qixi.name
    c:addSubcard(cards[1])
    return c
  end,
  enabled_at_response = function (self, player, response)
    return not response
  end
})

qixi:addEffect(fk.CardUseFinished, {
  mute = true,
  can_refresh = function(self, event, target, player, data)
    return target == player and data.card and table.contains(data.card.skillNames or {}, qixi.name) and
      player:usedSkillTimes("wzzz_v__fenwei", Player.HistoryGame) > 0
  end,
  on_refresh = function(self, event, target, player, data)
    local subcards = data.card.subcards or {}
    if #subcards == 0 then return end
    local suit = Fk:getCardById(subcards[1]).suit
    local matched = false
    local use_event = player.room.logic:getCurrentEvent()
    if use_event then
      use_event:searchEvents(GameEvent.MoveCards, 999, function(e)
        for _, move in ipairs(e.data) do
          if move.toArea == Card.DiscardPile and move.moveReason == fk.ReasonDiscard then
            for _, info in ipairs(move.moveInfo) do
              if not table.contains(subcards, info.cardId) and Fk:getCardById(info.cardId).suit == suit then
                matched = true
                return true
              end
            end
          end
        end
      end)
    end
    if matched then
      player:setSkillUseHistory("wzzz_v__fenwei", 0, Player.HistoryGame)
    end
  end,
})

qixi:addAI(nil, "vs_skill")

return qixi
