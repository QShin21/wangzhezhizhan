local wenji = fk.CreateSkill{
  name = "wzzz_v__wenji",
}

Fk:loadTranslationTable{
  ["wzzz_v__wenji"] = "问计",
  [":wzzz_v__wenji"] = "出牌阶段开始时，你可以令一名其他角色交给你一张牌并展示之，此阶段你使用与此牌类型相同的牌不能被其他角色响应。",

  ["#wzzz_v__wenji-choose"] = "问计：你可以令一名其他角色交给你一张牌",
  ["#wzzz_v__wenji-give"] = "问计：你需交给 %src 一张牌",
  ["@wzzz_v__wenji-turn"] = "问计",

  ["$wzzz_v__wenji1"] = "言出子口，入于吾耳，可以言未？",
  ["$wzzz_v__wenji2"] = "还望先生救我！",
}

wenji:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wenji.name) and player.phase == Player.Play and
      table.find(player.room:getOtherPlayers(player, false), function(p)
        return not p:isNude()
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      return not p:isNude()
    end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = wenji.name,
      prompt = "#wzzz_v__wenji-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local cards = room:askToCards(to, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = wenji.name,
      prompt = "#wzzz_v__wenji-give:"..player.id,
      cancelable = false,
    })
    to:showCards(cards)
    room:addTableMarkIfNeed(player, "@wzzz_v__wenji-turn", Fk:getCardById(cards[1]).type)
    room:obtainCard(player, cards, false, fk.ReasonGive, to, wenji.name)
  end,
})
wenji:addEffect(fk.CardUsing, {
  anim_type = "offensive",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and table.contains(player:getTableMark("@wzzz_v__wenji-turn"), data.card.type)
  end,
  on_use = function(self, event, target, player, data)
    data.disresponsiveList = data.disresponsiveList or {}
    for _, p in ipairs(player.room:getOtherPlayers(player, false)) do
      table.insertIfNeed(data.disresponsiveList, p)
    end
  end,
})

return wenji
