
local qice = fk.CreateSkill {
  name = "wzzz_v__qice",
}

Fk:loadTranslationTable{
  ["wzzz_v__qice"] = "奇策",
  [":wzzz_v__qice"] = "出牌阶段限一次，你可以将所有的手牌当任意普通锦囊牌使用。",

  ["#wzzz_v__qice"] = "奇策：将所有手牌当任意普通锦囊牌使用",

  ["$wzzz_v__qice1"] = "倾力为国，算无遗策。",
  ["$wzzz_v__qice2"] = "奇策在此，谁与争锋？"
}

qice:addEffect("viewas", {
  prompt = "#wzzz_v__qice",
  mute_card = false,
  interaction = function(self, player)
    local all_names = Fk:getAllCardNames("t")
    return UI.CardNameBox {
      choices = player:getViewAsCardNames(qice.name, all_names, player:getCardIds("h")),
      all_choices = all_names,
    }
  end,
  filter_pattern = function (self, player, card_name)
    local cards = player:getCardIds("h")
    return {
      max_num = #cards,
      min_num = #cards,
      pattern = ".|.|.|hand",
      subcards = cards
    }
  end,
  card_filter = Util.FalseFunc,
  view_as = function(self, player, cards)
    if Fk.all_card_types[self.interaction.data] == nil then return end
    local card = Fk:cloneCard(self.interaction.data)
    card:addSubcards(player:getCardIds("h"))
    card.skillName = self.name
    return card
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(qice.name, Player.HistoryPhase) == 0 and not player:isKongcheng()
  end,
})

qice:addAI(nil, "vs_skill")

return qice
