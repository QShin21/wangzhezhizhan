local niluan = fk.CreateSkill {
  name = "wzzz_v__ty__niluan",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__niluan"] = "逆乱",
  [":wzzz_v__ty__niluan"] = "出牌阶段，你可以将一张黑色牌当【杀】使用，若此【杀】未造成过伤害，则此【杀】无次数限制。",

  ["#wzzz_v__ty__niluan"] = "逆乱：将一张黑色牌当【杀】使用，若未造成伤害则此【杀】无次数限制",

  ["$wzzz_v__ty__niluan1"] = "如果不能功成名就，那就干脆为祸一方！",
  ["$wzzz_v__ty__niluan2"] = "哈哈哈哈哈，天下之事皆无常！",
}

niluan:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "slash",
  prompt = "#wzzz_v__ty__niluan",
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|black",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local card = Fk:cloneCard("slash")
    card.skillName = niluan.name
    card:addSubcard(cards[1])
    return card
  end,
  enabled_at_response = Util.FalseFunc,
})

niluan:addEffect(fk.CardUseFinished, {
  can_refresh = function(self, event, target, player, data)
    return target == player and table.contains(data.card.skillNames, niluan.name) and
      not data.damageDealt and not data.extraUse
  end,
  on_refresh = function(self, event, target, player, data)
    data.extraUse = true
    player:addCardUseHistory(data.card.trueName, -1)
  end,
})

return niluan
