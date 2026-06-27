local jinzi = fk.CreateSkill { name = "wzzz__jinzi" }

Fk:loadTranslationTable {
  ["wzzz__jinzi"] = "锦姿",
  [":wzzz__jinzi"] = "若你的装备区里没有防具牌，你视为装备着【白银狮子】。每轮限一次，你可以将一张武器牌或防具牌当【杀】使用，然后你可以令此【杀】无次数限制并失去“锦姿”。",
  ["#wzzz__jinzi-extra-use"] = "是否发动锦姿，使此【杀】不计入次数限制且失去“锦姿”？",
}

jinzi:addEffect("viewas", {
  pattern = "slash",
  card_filter = function(self, player, to_select, selected)
    if #selected > 0 then return false end
    local card = Fk:getCardById(to_select)
    return card.sub_type == Card.SubtypeWeapon or card.sub_type == Card.SubtypeArmor
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local slash = Fk:cloneCard("slash")
    slash.skillName = jinzi.name
    slash:addSubcard(cards[1])
    return slash
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(jinzi.name, Player.HistoryRound) == 0
  end,
})

jinzi:addEffect(fk.DamageInflicted, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jinzi.name) and #player:getEquipments(Card.SubtypeArmor) == 0 and data.damage > 1
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data) data:changeDamage(1 - data.damage) end,
})

jinzi:addEffect(fk.PreCardUse, {
  can_trigger = function(self, event, target, player, data)
    return target == player and table.contains(data.card.skillNames, jinzi.name)
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = jinzi.name,
      prompt = "#wzzz__jinzi-extra-use",
    })
  end,
  on_use = function(self, event, target, player, data)
    data.extraUse = true
    player.room:handleAddLoseSkills(player, "-" .. jinzi.name, nil, false, true)
  end,
})

return jinzi
