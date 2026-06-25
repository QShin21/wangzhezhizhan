local huoji = fk.CreateSkill {
  name = "wzzz_v__pangtong__huoji",
}

Fk:loadTranslationTable {
  ["wzzz_v__pangtong__huoji"] = "火计",
  [":wzzz_v__pangtong__huoji"] = "你可以将一张红色牌当【火攻】使用。你的【火攻】改为你展示目标一张手牌，你弃置与其展示牌颜色相同的手牌以造成伤害。",

  ["#wzzz_v__pangtong__huoji"] = "火计：你可以将一张红色牌当【火攻】使用",
}

huoji:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "fire_attack",
  prompt = "#wzzz_v__pangtong__huoji",
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|red",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local card = Fk:cloneCard("fire_attack")
    card.skillName = huoji.name
    card:addSubcard(cards[1])
    return card
  end,
})

huoji:addEffect(fk.PreCardEffect, {
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(huoji.name) and data.from == player and data.card.trueName == "fire_attack"
  end,
  on_refresh = function(self, event, target, player, data)
    data:changeCardSkill("wzzz_v__pangtong__huoji_fire_attack_skill")
  end,
})

return huoji
