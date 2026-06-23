local duanfa = fk.CreateSkill {
  name = "wzzz_v__duanfa",
}

Fk:loadTranslationTable{
  ["wzzz_v__duanfa"] = "断发",
  [":wzzz_v__duanfa"] = "出牌阶段，你可以弃置任意张黑色牌，然后摸等量的牌（你每阶段以此法弃置的牌数总和不能大于体力上限）。",

  ["#wzzz_v__duanfa"] = "断发：弃置任意张黑色牌，摸等量的牌（还可以弃%arg张）",

  ["$wzzz_v__duanfa1"] = "身体发肤，受之父母。",
  ["$wzzz_v__duanfa2"] = "今断发以明志，尚不可证吾之心意？",
}

duanfa:addEffect("active", {
  anim_type = "drawcard",
  prompt = function (self, player, selected_cards, selected_targets)
    return "#wzzz_v__duanfa:::"..(player.maxHp - player:getMark("wzzz_v__duanfa-phase"))
  end,
  can_use = function(self, player)
    return player:getMark("wzzz_v__duanfa-phase") < player.maxHp
  end,
  target_num = 0,
  min_card_num = 1,
  max_card_num = function(self, player)
    return player.maxHp - player:getMark("wzzz_v__duanfa-phase")
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected < (player.maxHp - player:getMark("wzzz_v__duanfa-phase")) and Fk:getCardById(to_select).color == Card.Black
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    room:throwCard(effect.cards, duanfa.name, player, player)
    if player.dead then return end
    room:addPlayerMark(player, "wzzz_v__duanfa-phase", #effect.cards)
    player:drawCards(#effect.cards, duanfa.name)
  end
})

return duanfa
