local bingzhengActive = fk.CreateSkill {
  name = "wzzz_v__bingzheng_active",
}

Fk:loadTranslationTable {
  ["wzzz_v__bingzheng_active"] = "秉正",
  ["wzzz_v__bingzheng_draw"] = "令其摸一张牌",
  ["wzzz_v__bingzheng_discard"] = "令其弃置一张手牌",
}

bingzhengActive:addEffect("active", {
  anim_type = "control",
  card_num = 0,
  target_num = 1,
  interaction = UI.ComboBox {
    choices = { "wzzz_v__bingzheng_draw", "wzzz_v__bingzheng_discard" },
  },
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select:getHandcardNum() ~= to_select.hp and
      (self.interaction.data ~= "wzzz_v__bingzheng_discard" or not to_select:isKongcheng())
  end,
})

return bingzhengActive
