local huoji = fk.CreateSkill{
  name = "wzzz_v__ol_ex__huoji",
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__huoji"] = "火计",
  [":wzzz_v__ol_ex__huoji"] = "你可以将一张红色手牌当【火攻】使用；你使用的【火攻】对目标角色生效时，你可以观看牌堆顶的四张牌，并可以选择其中一张代替该【火攻】需弃置的牌，然后将其余的牌置于牌堆顶（每回合你每次因【火攻】对目标角色造成伤害后，本回合此技能观看牌堆顶的牌数-1）。",

  ["#wzzz_v__ol_ex__huoji"] = "火计：你可以将一张红色手牌当【火攻】使用",
  ["#wzzz_v__ol_ex__huoji-discard"] = "你可弃置一张 %arg 手牌，对 %src 造成1点火属性伤害",

  ["$wzzz_v__ol_ex__huoji1"] = "赤壁借东风，燃火灭魏军。",
  ["$wzzz_v__ol_ex__huoji2"] = "东风，让这火烧得再猛烈些吧！",
}

huoji:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "fire_attack",
  prompt = "#wzzz_v__ol_ex__huoji",
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|red|hand",
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
    data:changeCardSkill("wzzz_v__ol_ex__huoji_fire_attack_skill")
  end,
})

huoji:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and data.card and data.card.trueName == "fire_attack" and
      table.contains(data.card.skillNames, huoji.name)
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addPlayerMark(player, "wzzz_v__ol_ex__huoji_damage-turn")
  end,
})

return huoji
