local wusheng = fk.CreateSkill {
  name = "wzzz_v__wusheng",
}

Fk:loadTranslationTable {
  ["wzzz_v__wusheng"] = "武圣",
  [":wzzz_v__wusheng"] = "你可以将一张红色牌当【杀】使用或打出；你使用的方块【杀】无距离限制。",
  ["#wzzz_v__wusheng"] = "武圣：你可以将一张红色牌当【杀】使用或打出",
}

local function isDiamondSlash(card)
  if not card or card.trueName ~= "slash" then return false end
  if card.suit == Card.Diamond then return true end
  local subcards = card:isVirtual() and card.subcards or { card.id }
  return #subcards > 0 and table.every(subcards, function(id)
    return Fk:getCardById(id).suit == Card.Diamond
  end)
end

wusheng:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "slash",
  prompt = "#wzzz_v__wusheng",
  -- mute_card = true,
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|red",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local c = Fk:cloneCard("slash")
    c.skillName = wusheng.name
    c:addSubcard(cards[1])
    return c
  end,
})

wusheng:addEffect("targetmod", {
  bypass_distances = function(self, player, skill, card)
    return player:hasSkill(wusheng.name) and skill.trueName == "slash_skill" and isDiamondSlash(card)
  end,
})

wusheng:addAI(nil, "vs_skill")

return wusheng
