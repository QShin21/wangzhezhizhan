local zhiheng = fk.CreateSkill {
  name = "wzzz_v__tycl__zhiheng",
}

Fk:loadTranslationTable{
  ["wzzz_v__tycl__zhiheng"] = "制衡",
  [":wzzz_v__tycl__zhiheng"] = "出牌阶段限一次，你可以弃置任意张牌，然后摸等量的牌。若你以此法弃置了所有的手牌，则额外摸一张牌。",

  ["#wzzz_v__tycl__zhiheng"] = "制衡：弃置任意张牌，摸等量的牌，若弃置了所有手牌额外摸一张",

  ["$wzzz_v__tycl__zhiheng"] = "容我三思。",
}

zhiheng:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#wzzz_v__tycl__zhiheng",
  max_phase_use_time = 1,
  min_card_num = 1,
  target_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(zhiheng.name, Player.HistoryPhase) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    return not player:prohibitDiscard(to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local hand = player:getCardIds("h")
    local more = #hand > 0
    for _, id in ipairs(hand) do
      if not table.contains(effect.cards, id) then
        more = false
        break
      end
    end
    room:throwCard(effect.cards, zhiheng.name, player, player)
    if player.dead then return end
    room:drawCards(player, #effect.cards + (more and 1 or 0), zhiheng.name)
  end,
})

return zhiheng
