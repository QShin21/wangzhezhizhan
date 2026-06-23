local osZhuitingOther = fk.CreateSkill {
  name = "wzzz_v__os__zhuiting_other&"
}

Fk:loadTranslationTable{
  ["wzzz_v__os__zhuiting_other&"] = "坠廷",
  [":wzzz_v__os__zhuiting_other&"] = "当一张锦囊牌对刘协生效前，你可以将一张与之颜色相同的手牌当【无懈可击】使用。",
}

osZhuitingOther:addEffect("viewas", {
  anim_type = "control",
  pattern = "nullification",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    return
      #selected == 0 and
      table.contains(player:getHandlyIds(), to_select) and
      Fk:getCardById(to_select).color == player:getMark("wzzz_v__os__zhuiting_activated") and
      player:getMark("wzzz_v__os__zhuiting_activated") ~= Card.NoColor
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local card = Fk:cloneCard("nullification")
    card.skillName = "wzzz_v__os__zhuiting"
    card:addSubcard(cards[1])
    return card
  end,
  enabled_at_response = function(self, player, response)
    return
      not response and
      (response == nil or player:getMark("wzzz_v__os__zhuiting_activated") ~= 0) and
      not player:isKongcheng()
  end,
})

osZhuitingOther:addEffect(fk.HandleAskForPlayCard, {
  can_refresh = function(self, event, target, player, data)
    if data.afterRequest and (data.extra_data or {}).os__zhuiting_effected then
      return player:getMark("wzzz_v__os__zhuiting_activated") ~= 0
    end

    return
      player:hasSkill(osZhuitingOther.name) and
      data.eventData and
      data.eventData.to and
      data.eventData.to:hasSkill("wzzz_v__os__zhuiting") and
      Exppattern:Parse(data.pattern):match(Fk:cloneCard("nullification"))
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    if data.afterRequest then
      room:setPlayerMark(player, "wzzz_v__os__zhuiting_activated", 0)
    else
      room:setPlayerMark(player, "wzzz_v__os__zhuiting_activated", data.eventData.card.color)
      data.extra_data = data.extra_data or {}
      data.extra_data.os__zhuiting_effected = true
    end
  end,
})

return osZhuitingOther
