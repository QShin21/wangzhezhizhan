local xiemu_active = fk.CreateSkill {
  name = "wzzz_v__sxfy__xiemu&",
}

Fk:loadTranslationTable{
  ["wzzz_v__sxfy__xiemu&"] = "协穆",
  [":wzzz_v__sxfy__xiemu&"] = "出牌阶段限一次，你可以展示并交给马良一张基本牌，然后本回合你攻击范围+1。",

  ["#wzzz_v__sxfy__xiemu&"] = "协穆：交给马良一张基本牌，本回合你攻击范围+1",
  ["#wzzz_v__sxfy__xiemu-range"] = "协穆：是否令 %src 本回合攻击范围+1？",
}

xiemu_active:addEffect("active", {
  mute = true,
  card_num = 1,
  target_num = 1,
  prompt = "#wzzz_v__sxfy__xiemu&",
  can_use = function(self, player)
    return table.find(Fk:currentRoom().alive_players, function (p)
      return p ~= player and p:hasSkill("wzzz_v__sxfy__xiemu") and p:usedSkillTimes("wzzz_v__sxfy__xiemu", Player.HistoryPhase) == 0
    end)
  end,
  card_filter = function (self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).type == Card.TypeBasic
  end,
  target_filter = function (self, player, to_select, selected)
    return #selected == 0 and to_select:hasSkill("wzzz_v__sxfy__xiemu") and
      to_select:usedSkillTimes("wzzz_v__sxfy__xiemu", Player.HistoryPhase) == 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:notifySkillInvoked(target, "wzzz_v__sxfy__xiemu", "support")
    target:broadcastSkillInvoke("wzzz_v__sxfy__xiemu")
    target:addSkillUseHistory("wzzz_v__sxfy__xiemu", 1)
    player:showCards(effect.cards)
    if target.dead or not table.contains(player:getCardIds("h"), effect.cards[1]) then return end
    room:moveCardTo(effect.cards, Card.PlayerHand, target, fk.ReasonGive, "wzzz_v__sxfy__xiemu", nil, true, player)
    if not player.dead and not target.dead and room:askToSkillInvoke(target, {
      skill_name = "wzzz_v__sxfy__xiemu",
      prompt = "#wzzz_v__sxfy__xiemu-range:"..player.id,
    }) then
      room:setPlayerMark(player, "@@wzzz_v__sxfy__xiemu-turn", 1)
    end
  end,
})

return xiemu_active
