local duanliang = fk.CreateSkill{
  name = "wzzz_v__m_ex__duanliang",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__duanliang"] = "断粮",
  [":wzzz_v__m_ex__duanliang"] = "你可以将一张黑色非锦囊牌当【兵粮寸断】使用；若你本回合未造成过伤害，你使用【兵粮寸断】无距离限制。",

  ["#wzzz_v__m_ex__duanliang"] = "断粮：你可以将一张黑色非锦囊牌当【兵粮寸断】使用",

  ["$wzzz_v__m_ex__duanliang1"] = "粮不三载，敌军已犯行军大忌。",
  ["$wzzz_v__m_ex__duanliang2"] = "断敌粮秣，此战可胜。",
}

duanliang:addEffect("viewas", {
  anim_type = "control",
  pattern = "supply_shortage",
  prompt = "#wzzz_v__m_ex__duanliang",
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|black|.|.|basic,equip",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local c = Fk:cloneCard("supply_shortage")
    c.skillName = self.name
    c:addSubcard(cards[1])
    return c
  end,
})
duanliang:addEffect("targetmod", {
  bypass_distances =  function(self, player, skill, card, to)
    return player:hasSkill(duanliang.name) and skill.name == "supply_shortage_skill" and
      #player.room.logic:getActualDamageEvents(1, function(e)
        return e.data.from == player
      end, Player.HistoryTurn) == 0
  end,
})

return duanliang
