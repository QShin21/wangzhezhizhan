Fk:loadTranslationTable{
  ["wzzz_v__yajiao"] = "涯角",
  [":wzzz_v__yajiao"] = "当你于回合外使用或打出手牌时，你可以展示牌堆顶的一张牌并交给一名角色。若此牌与你使用或打出的牌类型不同，你弃置一张牌。",

  ["#wzzz_v__yajiao-card"] = "涯角：将%arg交给一名角色",

  ["$wzzz_v__yajiao1"] = "遍寻天下，但求一败！",
  ["$wzzz_v__yajiao2"] = "策马驱前，斩敌当先！",
}

local yajiao = fk.CreateSkill{
  name = "wzzz_v__yajiao",
}

local function usedHandCard(player, card)
  local ids = card:isVirtual() and card.subcards or { card.id }
  return #ids > 0 and table.every(ids, function(id)
    return table.contains(player:getCardIds("h"), id) or player.room:getCardArea(id) == Card.Processing
  end)
end

local spec = {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yajiao.name) and player.room.current ~= player and
      usedHandCard(player, data.card)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = room:getNCards(1)
    room:turnOverCardsFromDrawPile(player, cards, yajiao.name)
    local to = room:askToChoosePlayers(player, {
      targets = room.alive_players,
      max_num = 1,
      min_num = 1,
      prompt = "#wzzz_v__yajiao-card:::"..Fk:getCardById(cards[1]):toLogString(),
      skill_name = yajiao.name,
      cancelable = false,
    })[1]
      room:obtainCard(to, cards, true, fk.ReasonGive, player, yajiao.name)
    if data.card.type ~= Fk:getCardById(cards[1]).type and not player.dead then
      room:askToDiscard(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = yajiao.name,
        cancelable = false,
      })
    end
  end,
}

yajiao:addEffect(fk.CardUsing, spec)
yajiao:addEffect(fk.CardResponding, spec)

return yajiao
