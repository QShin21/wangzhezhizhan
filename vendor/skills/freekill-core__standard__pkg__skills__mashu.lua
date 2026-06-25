local mashu = fk.CreateSkill{
  name = "wzzz_v__mashu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__mashu"] = "马术",
  [":wzzz_v__mashu"] = "锁定技，你计算与其他角色的距离-1。当你使用坐骑牌或失去装备区里的坐骑牌时，你摸一张牌。",
}

local function isRide(card)
  return card and (card.sub_type == Card.SubtypeOffensiveRide or card.sub_type == Card.SubtypeDefensiveRide)
end

mashu:addEffect("distance", {
  correct_func = function(self, from, to)
    if from:hasSkill(mashu.name) then
      return -1
    end
  end,
})

mashu:addEffect(fk.CardUsing, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(mashu.name) and isRide(data.card)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, mashu.name)
  end,
})

mashu:addEffect(fk.AfterCardsMove, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(mashu.name) then return false end
    for _, move in ipairs(data) do
      if move.from == player then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerEquip and isRide(Fk:getCardById(info.cardId)) then
            return true
          end
        end
      end
    end
  end,
  trigger_times = function(self, event, target, player, data)
    local n = 0
    for _, move in ipairs(data) do
      if move.from == player then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerEquip and isRide(Fk:getCardById(info.cardId)) then
            n = n + 1
          end
        end
      end
    end
    return n
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, mashu.name)
  end,
})

return mashu
