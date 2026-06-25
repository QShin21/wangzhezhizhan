local wzzz_v__tushe = fk.CreateSkill {
  name = "wzzz_v__tushe",
}

Fk:loadTranslationTable{
  ["wzzz_v__tushe"] = "图射",
  [":wzzz_v__tushe"] = "当你使用非装备牌指定目标后，若你没有基本牌，则你可以摸X张牌（X为此牌指定的目标数）。",

  ["$wzzz_v__tushe1"] = "据险以图进，备策而施为！",
  ["$wzzz_v__tushe2"] = "夫战者，可时以奇险之策而图常谋！",
}

wzzz_v__tushe:addEffect(fk.TargetSpecified, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__tushe.name) and
      data.card.type ~= Card.TypeEquip and data.firstTarget and
      not table.find(player:getCardIds("h"), function(id)
        return Fk:getCardById(id).type == Card.TypeBasic
      end) and
      #data.use.tos > 0
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(#data.use.tos, wzzz_v__tushe.name)
  end,
})

return wzzz_v__tushe
