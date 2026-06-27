local wzzz_v__tushe = fk.CreateSkill {
  name = "wzzz_v__tushe",
}

Fk:loadTranslationTable{
  ["wzzz_v__tushe"] = "图射",
  [":wzzz_v__tushe"] = "当你使用非装备牌指定目标后，你可以展示所有手牌，若其中没有基本牌，你可以摸两张牌（若你的判定区里有牌，则改为摸一张牌）。",

  ["$wzzz_v__tushe1"] = "据险以图进，备策而施为！",
  ["$wzzz_v__tushe2"] = "夫战者，可时以奇险之策而图常谋！",
}

wzzz_v__tushe:addEffect(fk.TargetSpecified, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__tushe.name) and
      data.card.type ~= Card.TypeEquip and data.firstTarget and
      #data.use.tos > 0
  end,
  on_use = function(self, event, target, player, data)
    local cards = player:getCardIds("h")
    if #cards > 0 then
      player:showCards(cards)
    end
    if not table.find(player:getCardIds("h"), function(id)
      return Fk:getCardById(id).type == Card.TypeBasic
    end) then
      player:drawCards(#player:getCardIds("j") > 0 and 1 or 2, wzzz_v__tushe.name)
    end
  end,
})

return wzzz_v__tushe
