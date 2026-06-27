local zhenweiActive = fk.CreateSkill {
  name = "wzzz_v__zhenwei_active",
}

Fk:loadTranslationTable {
  ["wzzz_v__zhenwei_active"] = "镇卫",
}

zhenweiActive:addEffect("active", {
  card_num = 1,
  target_num = 0,
  interaction = function(self, player)
    local choices = { "wzzz_v__zhenwei_transfer" }
    if (self.extra_data or {}).can_recycle then
      table.insert(choices, "wzzz_v__zhenwei_recycle")
    end
    return UI.ComboBox {
      choices = choices,
      all_choices = { "wzzz_v__zhenwei_transfer", "wzzz_v__zhenwei_recycle" },
    }
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and not player:prohibitDiscard(to_select)
  end,
  feasible = function(self, player, selected, selected_cards)
    return #selected == 0 and #selected_cards == 1 and self.interaction.data ~= nil
  end,
})

return zhenweiActive
