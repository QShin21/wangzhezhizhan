local weijing = fk.CreateSkill{
  name = "wzzz_v__weijing",
}

Fk:loadTranslationTable{
  ["wzzz_v__weijing"] = "卫境",
  [":wzzz_v__weijing"] = "每轮限一次，当你需要使用【杀】或【闪】时，你可以视为使用之。",

  ["#wzzz_v__weijing"] = "卫境：你可以视为使用【杀】或【闪】",

  ["$wzzz_v__weijing1"] = "战事兴起，最苦的，仍是百姓。",
  ["$wzzz_v__weijing2"] = "国乃大家，保大家才有小家。",
}

weijing:addEffect("viewas", {
  pattern = "slash,jink",
  prompt = "#wzzz_v__weijing",
  interaction = function(self, player)
    local names = player:getViewAsCardNames(weijing.name, {"slash", "jink"})
    return UI.CardNameBox {choices = names, all_choices = {"slash", "jink"}}
  end,
  filter_pattern = {
    min_num = 0,
    max_num = 0,
    pattern = "",
    subcards = {}
  },
  card_filter = Util.FalseFunc,
  view_as = function(self)
    if not self.interaction.data then return end
    local card = Fk:cloneCard(self.interaction.data)
    card.skillName = weijing.name
    return card
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(weijing.name, Player.HistoryRound) == 0 and
      #player:getViewAsCardNames(weijing.name, {"slash"}) > 0
  end,
  enabled_at_response = function(self, player, response)
    return not response and player:usedSkillTimes(weijing.name, Player.HistoryRound) == 0 and
      #player:getViewAsCardNames(weijing.name, {"slash", "jink"}) > 0
  end,
})

return weijing
