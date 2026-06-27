local wzzz_v__shicai = fk.CreateSkill {
  name = "wzzz_v__shicai",
}

Fk:loadTranslationTable{
  ["wzzz_v__shicai"] = "恃才",
  [":wzzz_v__shicai"] = "你的回合内，当你使用一张牌结算结束后，若此牌与你本回合使用并结算结束的牌类型均不同（延时锦囊除外），你可以将此牌置于牌堆顶，然后摸一张牌。",

  ["#wzzz_v__shicai-invoke"] = "恃才：是否将%arg置于牌堆顶，然后摸一张牌？",
  ["@wzzz_v__shicai-turn"] = "恃才",

  ["$wzzz_v__shicai1"] = "吾才满腹，袁本初竟不从之。",
  ["$wzzz_v__shicai2"] = "阿瞒有我良计，取冀州便是易如反掌。",
}

wzzz_v__shicai:addEffect(fk.CardUseFinished, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if target ~= player or not player:hasSkill(wzzz_v__shicai.name) or player.room.current ~= player then return end
    local card_type = data.card.type
    if card_type == Card.TypeTrick and not data.card:isCommonTrick() then return end
    local room = player.room
    if card_type == Card.TypeEquip then
      if not table.contains(player:getCardIds("e"), data.card:getEffectiveId()) then return end
    else
      if room:getCardArea(data.card) ~= Card.Processing then return end
    end
    local logic = room.logic
    local use_event = logic:getCurrentEvent()
    local mark_name = "wzzz_v__shicai_" .. data.card:getTypeString() .. "-turn"
    local mark = player:getMark(mark_name)
    if mark == 0 then
      logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local last_use = e.data
        if last_use.from == player and last_use.card.type == card_type then
          mark = e.id
          room:setPlayerMark(player, mark_name, mark)
          return true
        end
      end, Player.HistoryTurn)
    end
    return mark == use_event.id
  end,
  on_cost = function (self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = wzzz_v__shicai.name,
      prompt = "#wzzz_v__shicai-invoke:::"..data.card:toLogString()
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local toPut = data.card:isVirtual() and data.card.subcards or { data.card.id }

    if #toPut > 1 then
      toPut = room:askToGuanxing(player, {
        cards = toPut,
        top_limit = { #toPut, #toPut },
        bottom_limit = { 0, 0 },
        skill_name = wzzz_v__shicai.name,
        skip = true,
      }).top
      toPut = table.reverse(toPut)
    end

    room:moveCardTo(toPut, Card.DrawPile, nil, fk.ReasonPut, wzzz_v__shicai.name, nil, true)
    player:drawCards(1, wzzz_v__shicai.name)
  end,
})
wzzz_v__shicai:addEffect(fk.AfterCardUseDeclared, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__shicai.name, true) and player.room.current == player and
      not (data.card.type == Card.TypeTrick and not data.card:isCommonTrick())
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addTableMarkIfNeed(player, "@wzzz_v__shicai-turn", data.card:getTypeString().."_char")
  end,
})

return wzzz_v__shicai
