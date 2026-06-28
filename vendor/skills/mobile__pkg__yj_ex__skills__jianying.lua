local jianying = fk.CreateSkill {
  name = "wzzz_v__m_ex__jianying",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__jianying"] = "渐营",
  ["#wzzz_v__m_ex__jianying_trigger"] = "渐营",
  [":wzzz_v__m_ex__jianying"] = "当你于出牌阶段内使用牌时，若此牌与你于此阶段内使用的上一张牌点数或花色相同，你可以摸一张牌。"..
    "出牌阶段限一次，你可以指定一种花色，此阶段你使用下一张基本牌或普通锦囊牌视为此花色。",

  ["#wzzz_v__m_ex__jianying-active"] = "渐营：指定一种花色，本阶段你使用的下一张基本牌或普通锦囊牌视为此花色",
  ["@wzzz_v__m_ex__jianying_record-phase"] = "渐营",
  ["@wzzz_v__m_ex__jianying_next-phase"] = "渐营",

  ["$wzzz_v__m_ex__jianying1"] = "良谋百出，渐定决战胜势！",
  ["$wzzz_v__m_ex__jianying2"] = "佳策数成，破敌垂手可得！",
}

jianying:addEffect("active", {
  prompt = "#wzzz_v__m_ex__jianying-active",
  interaction = UI.ComboBox { choices = { "log_spade", "log_club", "log_heart", "log_diamond" } },
  card_num = 0,
  target_num = 0,
  can_use = function(self, player)
    return player.phase == Player.Play and player:getMark("wzzz_v__m_ex__jianying_active_used-phase") == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    room:setPlayerMark(effect.from, "wzzz_v__m_ex__jianying_active_used-phase", 1)
    room:setPlayerMark(effect.from, "wzzz_v__m_ex__jianying_next_suit-phase", self.interaction.data)
    room:setPlayerMark(effect.from, "@wzzz_v__m_ex__jianying_next-phase", self.interaction.data)
  end,
})

jianying:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return data.from == player and player.phase == Player.Play and
      (data.extra_data or {}).m_ex__jianying_triggerable and player:hasSkill(jianying.name)
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, jianying.name)
  end,
})

jianying:addEffect(fk.CardUsing, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(jianying.name, true) and player.phase == Player.Play
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local next_suit = player:getMark("wzzz_v__m_ex__jianying_next_suit-phase")
    if type(next_suit) == "string" and (data.card.type == Card.TypeBasic or data.card:isCommonTrick()) then
      local suit_map = {
        log_spade = { suit = Card.Spade, color = Card.Black, record = "spade" },
        log_club = { suit = Card.Club, color = Card.Black, record = "club" },
        log_heart = { suit = Card.Heart, color = Card.Red, record = "heart" },
        log_diamond = { suit = Card.Diamond, color = Card.Red, record = "diamond" },
      }
      local suit = suit_map[next_suit]
      if suit then
        data.extra_data = data.extra_data or {}
        data.extra_data.m_ex__jianying_origin_suit = data.card.suit
        data.extra_data.m_ex__jianying_origin_color = data.card.color
        data.card.suit = suit.suit
        data.card.color = suit.color
      end
      room:setPlayerMark(player, "wzzz_v__m_ex__jianying_next_suit-phase", 0)
      room:setPlayerMark(player, "@wzzz_v__m_ex__jianying_next-phase", 0)
    end
    if data.card:getSuitString() == player:getMark("wzzz_v__m_ex__jianying_suit-phase") or
        (data.card.number == player:getMark("wzzz_v__m_ex__jianying_number-phase") and data.card.number ~= 0) then
      data.extra_data = data.extra_data or {}
      data.extra_data.m_ex__jianying_triggerable = true
    end
    if data.card.suit == Card.NoSuit then
      room:setPlayerMark(player, "wzzz_v__m_ex__jianying_suit-phase", 0)
    else
      room:setPlayerMark(player, "wzzz_v__m_ex__jianying_suit-phase", data.card:getSuitString())
    end
    room:setPlayerMark(player, "wzzz_v__m_ex__jianying_number-phase", data.card.number)
    room:setPlayerMark(player, "@wzzz_v__m_ex__jianying_record-phase", {data.card:getSuitString(true), data.card:getNumberStr()})
  end,
})

jianying:addEffect(fk.CardUseFinished, {
  mute = true,
  can_refresh = function(self, event, target, player, data)
    return target == player and data.extra_data and data.extra_data.m_ex__jianying_origin_suit ~= nil
  end,
  on_refresh = function(self, event, target, player, data)
    data.card.suit = data.extra_data.m_ex__jianying_origin_suit
    data.card.color = data.extra_data.m_ex__jianying_origin_color
  end,
})

jianying:addLoseEffect(function(self, player)
  local room = player.room
  room:setPlayerMark(player, "wzzz_v__m_ex__jianying_suit-phase", 0)
  room:setPlayerMark(player, "wzzz_v__m_ex__jianying_active_used-phase", 0)
  room:setPlayerMark(player, "wzzz_v__m_ex__jianying_next_suit-phase", 0)
  room:setPlayerMark(player, "wzzz_v__m_ex__jianying_number-phase", 0)
  room:setPlayerMark(player, "@wzzz_v__m_ex__jianying_record-phase", 0)
  room:setPlayerMark(player, "@wzzz_v__m_ex__jianying_next-phase", 0)
end)

return jianying
