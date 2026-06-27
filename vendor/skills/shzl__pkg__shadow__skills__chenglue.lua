local wzzz_v__chenglue = fk.CreateSkill {
  name = "wzzz_v__chenglue",
}

Fk:loadTranslationTable{
  ["wzzz_v__chenglue"] = "成略",
  [":wzzz_v__chenglue"] = "出牌阶段限一次，你可以摸一张牌，然后弃置一张手牌，若如此做，直到回合结束，你使用与弃置牌花色相同的牌无距离次数限制。",

  ["#wzzz_v__chenglue-active"] = "成略：摸一张牌，然后弃置一张手牌，本回合使用同花色牌无距离次数限制",
  ["#wzzz_v__chenglue-discard"] = "成略：弃置一张手牌，本回合使用此花色牌无距离和次数限制",
  ["@wzzz_v__chenglue-turn"] = "成略",

  ["$wzzz_v__chenglue1"] = "成略在胸，良计速出。",
  ["$wzzz_v__chenglue2"] = "吾有良略在怀，必为阿瞒所需。",
}

wzzz_v__chenglue:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#wzzz_v__chenglue-active",
  can_use = function(self, player)
    return player:usedSkillTimes(wzzz_v__chenglue.name, Player.HistoryPhase) < 1
  end,
  card_filter = Util.FalseFunc,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    player:drawCards(1, wzzz_v__chenglue.name)
    if player.dead then return end

    local toDiscard = room:askToDiscard(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = wzzz_v__chenglue.name,
      cancelable = false,
      prompt = "#wzzz_v__chenglue-discard",
      skip = true,
    })
    if #toDiscard == 0 then return end

    for _, id in ipairs(toDiscard) do
      local suit = Fk:getCardById(id):getSuitString(true)
      if suit ~= "log_nosuit" then
        room:addTableMarkIfNeed(player, "@wzzz_v__chenglue-turn", suit)
      end
    end
    room:throwCard(toDiscard, wzzz_v__chenglue.name, player, player)
  end,
})
wzzz_v__chenglue:addEffect(fk.PreCardUse, {
  can_refresh = function(self, event, target, player, data)
    return target == player and table.contains(player:getTableMark("@wzzz_v__chenglue-turn"), data.card:getSuitString(true))
  end,
  on_refresh = function(self, event, target, player, data)
    data.extraUse = true
  end,
})
wzzz_v__chenglue:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card)
    local mark = player:getTableMark("@wzzz_v__chenglue-turn")
    if #mark > 0 then
      return card and card:matchVSPattern(".|.|" ..
        table.concat(table.map(mark, function(suit) return string.sub(suit, 5) end), ","))
    end
  end,
  bypass_distances = function(self, player, skill, card)
    local mark = player:getTableMark("@wzzz_v__chenglue-turn")
    if #mark > 0 then
      return card and card:matchVSPattern(".|.|" ..
        table.concat(table.map(mark, function(suit) return string.sub(suit, 5) end), ","))
    end
  end,
})

return wzzz_v__chenglue
