local skill_6025_6551 = fk.CreateSkill {
  name = "wzzz_s__6025_6551"
}

Fk:loadTranslationTable {
  ["wzzz_s__6025_6551"] = "急救",
  [":" .. "wzzz_s__6025_6551"] = "你于回合外可以将一张红色牌当【桃】使用。",
  ["#wzzz_s__6025_6551"] = "急救：你可以将一张红色牌当【桃】使用",
}

skill_6025_6551:addEffect("viewas", {
  pattern = "peach",
  prompt = "#wzzz_s__6025_6551",
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).color == Card.Red
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local peach = Fk:cloneCard("peach")
    peach.skillName = skill_6025_6551.name
    peach:addSubcard(cards[1])
    return peach
  end,
  enabled_at_play = function(self, player)
    return false
  end,
  enabled_at_response = function(self, player, response)
    return not response and Fk:currentRoom().current ~= player
  end,
})

return skill_6025_6551
