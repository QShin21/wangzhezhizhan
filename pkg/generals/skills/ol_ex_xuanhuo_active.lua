local xuanhuoActive = fk.CreateSkill {
  name = "wzzz_v__ol_ex__xuanhuo_active",
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__xuanhuo_active"] = "眩惑",
}

xuanhuoActive:addEffect("active", {
  card_num = 2,
  target_num = 2,
  card_filter = function(self, player, to_select, selected)
    return #selected < 2 and table.contains(player:getCardIds("he"), to_select)
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    if #selected == 0 then
      return to_select ~= player
    end
    return #selected == 1 and to_select ~= selected[1]
  end,
})

return xuanhuoActive
