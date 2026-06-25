local ziyuan = fk.CreateSkill{
  name = "wzzz_v__ziyuan",
}

Fk:loadTranslationTable{
  ["wzzz_v__ziyuan"] = "资援",
  [":wzzz_v__ziyuan"] = "出牌阶段限一次，你可以将任意张点数之和为13的手牌交给一名其他角色，然后该角色回复1点体力。",

  ["#wzzz_v__ziyuan"] = "资援：将点数之和为13的手牌交给一名其他角色，并令其回复1点体力",

  ["$wzzz_v__ziyuan1"] = "区区薄礼，万望使君笑纳。",
  ["$wzzz_v__ziyuan2"] = "雪中送炭，以解君愁。",
}

Fk:loadTranslationTable{
  ["wzzz_v__ziyuan"] = "资援",
  [":wzzz_v__ziyuan"] = "出牌阶段限一次，你可以交给一名其他角色任意张点数之和不大于13的牌并展示之，然后你摸一张牌，若点数之和等于13，你令该角色回复1点体力。",
  ["#wzzz_v__ziyuan"] = "资援：交给一名其他角色任意张点数之和不大于13的手牌",
}

ziyuan:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__ziyuan",
  min_card_num = 1,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(ziyuan.name, Player.HistoryPhase) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    if not table.contains(player:getCardIds("h"), to_select) then return end
    local num = 0
    for _, id in ipairs(selected) do
      num = num + Fk:getCardById(id).number
    end
    return num + Fk:getCardById(to_select).number <= 13
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    local num = 0
    for _, id in ipairs(selected_cards) do
      num = num + Fk:getCardById(id).number
    end
    return num > 0 and num <= 13 and #selected == 0 and to_select ~= player
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local num = 0
    for _, id in ipairs(effect.cards) do
      num = num + Fk:getCardById(id).number
    end
    player:showCards(effect.cards)
    room:moveCardTo(effect.cards, Card.PlayerHand, target, fk.ReasonGive, ziyuan.name, nil, false, player)
    if player:isAlive() then
      player:drawCards(1, ziyuan.name)
    end
    if num == 13 and target:isWounded() and not target.dead then
      room:recover{
        who = target,
        num = 1,
        recoverBy = player,
        skillName = ziyuan.name,
      }
    end
  end,
})

return ziyuan
