local zongxuan = fk.CreateSkill {
  name = "wzzz_v__m_ex__zongxuan",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__zongxuan"] = "纵玄",
  [":wzzz_v__m_ex__zongxuan"] = "当你的牌因弃置而置入弃牌堆后，或你上家的牌于每回合首次因弃置而置入弃牌堆后，你可以将其中一张锦囊牌交给一名其他角色，且可以将其余任意张牌置于牌堆顶。出牌阶段限一次，你可以摸一张牌并将一张牌置于牌堆顶。",

  ["#wzzz_v__m_ex__zongxuan-active"] = "纵玄：你可以摸一张牌，然后将一张牌置于牌堆顶",
  ["#wzzz_v__m_ex__zongxuan-put"] = "纵玄：将一张牌置于牌堆顶",
  ["#wzzz_v__m_ex__zongxuan-invoke"] = "纵玄：将任意数量的弃牌置于牌堆顶",
  ["#wzzz_v__m_ex__zongxuan-give"] = "纵玄：你可以将其中一张锦囊牌交给一名其他角色",
  ["#PutKnownCardtoDrawPile"] = "%from 将 %card 置于牌堆顶",

  ["$wzzz_v__m_ex__zongxuan1"] = "近日之事，吾心已有谱。",
  ["$wzzz_v__m_ex__zongxuan2"] = "我来为将军算上一卦。",
}

zongxuan:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#wzzz_v__m_ex__zongxuan-active",
  max_phase_use_time = 1,
  card_num = 0,
  target_num = 0,
  card_filter = Util.FalseFunc,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, use)
    local player = use.from
    player:drawCards(1, zongxuan.name)
    if player:isNude() then return end
    local card = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = zongxuan.name,
      cancelable = false,
      prompt = "#wzzz_v__m_ex__zongxuan-put",
    })
    room:moveCardTo(card, Card.DrawPile, nil, fk.ReasonPut, zongxuan.name, nil, false, player)
  end,
})

zongxuan:addEffect(fk.AfterCardsMove, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(zongxuan.name) then
      local room = player.room
      local cards = {}
      local upper = false
      for _, move in ipairs(data) do
        local from = move.from
        local isSelf = from == player
        local isUpper = from and from ~= player and from:getNextAlive() == player and
          player:getMark("wzzz_v__m_ex__zongxuan_upper-turn") == 0
        if (isSelf or isUpper) and move.toArea == Card.DiscardPile and move.moveReason == fk.ReasonDiscard then
          for _, info in ipairs(move.moveInfo) do
            if info.fromArea == Card.PlayerHand or info.fromArea == Card.PlayerEquip then
              if room:getCardArea(info.cardId) == Card.DiscardPile then
                table.insertIfNeed(cards, info.cardId)
                if isUpper then upper = true end
              end
            end
          end
        end
      end
      cards = room.logic:moveCardsHoldingAreaCheck(cards)
      if #cards > 0 then
        event:setCostData(self, {cards = cards, upper = upper})
        return true
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = zongxuan.name,
      prompt = "#wzzz_v__m_ex__zongxuan-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cost = event:getCostData(self)
    if cost.upper then
      room:setPlayerMark(player, "wzzz_v__m_ex__zongxuan_upper-turn", 1)
    end
    local cards = table.simpleClone(cost.cards)
    local tricks = table.filter(cards, function(id)
      return Fk:getCardById(id).type == Card.TypeTrick
    end)
    if #tricks > 0 and #room:getOtherPlayers(player, false) > 0 then
      local tos, give = room:askToChooseCardsAndPlayers(player, {
        targets = room:getOtherPlayers(player, false),
        min_num = 1,
        max_num = 1,
        min_card_num = 1,
        max_card_num = 1,
        pattern = tostring(Exppattern{ id = tricks }),
        expand_pile = tricks,
        skill_name = zongxuan.name,
        prompt = "#wzzz_v__m_ex__zongxuan-give",
        cancelable = true,
      })
      if #tos > 0 and #give > 0 then
        table.removeOne(cards, give[1])
        room:moveCardTo(give, Card.PlayerHand, tos[1], fk.ReasonJustMove, zongxuan.name, nil, false, player)
      end
    end
    cards = room.logic:moveCardsHoldingAreaCheck(cards)
    if #cards == 0 then return end
    local top = room:askToArrangeCards(player, {
      skill_name = zongxuan.name,
      card_map = {cards, "pile_discard","Top"},
      prompt = "#wzzz_v__m_ex__zongxuan-invoke",
      free_arrange = true,
      box_size = 7,
      min_limit = {0, 0},
    })[2]
    if #top == 0 then return end
    room:sendLog{
      type = "#PutKnownCardtoDrawPile",
      from = player.id,
      card = top
    }
    room:moveCardTo(table.reverse(top), Card.DrawPile, nil, fk.ReasonPut, zongxuan.name, nil, true, player)
  end,
})

return zongxuan
