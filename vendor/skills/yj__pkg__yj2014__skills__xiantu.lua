local xiantu = fk.CreateSkill {
  name = "wzzz_v__xiantu",
}

Fk:loadTranslationTable{
  ["wzzz_v__xiantu"] = "献图",
  [":wzzz_v__xiantu"] = "其他角色的出牌阶段开始时，你可以摸两张牌，然后交给其两张牌，然后此阶段结束时，若其于此阶段内未杀死过角色，则你失去1点体力。",

  ["#wzzz_v__xiantu-invoke"] = "献图：你可以摸两张牌并交给 %dest 两张牌",
  ["#wzzz_v__xiantu-give"] = "献图：交给 %dest 两张牌",

  ["$wzzz_v__xiantu1"] = "将军莫虑，且看此图。",
  ["$wzzz_v__xiantu2"] = "我已诚心相献，君何踌躇不前？",
}

Fk:loadTranslationTable{
  ["wzzz_v__xiantu"] = "献图",
  [":wzzz_v__xiantu"] = "其他角色的出牌阶段开始时，你可以摸三张牌，然后交给其两张牌。此阶段结束时，若其此阶段未杀死过角色，你失去1点体力。",
  ["#wzzz_v__xiantu-invoke"] = "献图：你可以摸三张牌并交给 %dest 两张牌",
  ["#wzzz_v__xiantu-give"] = "献图：交给 %dest 两张牌",
}

xiantu:addEffect(fk.EventPhaseStart, {
  mute = true,
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(xiantu.name) and target.phase == Player.Play and
      not target.dead
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = xiantu.name,
      prompt = "#wzzz_v__xiantu-invoke::"..target.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke(xiantu.name, 1)
    room:notifySkillInvoked(player, xiantu.name, "support", {target})
    room:setPlayerMark(player, "wzzz_v__xiantu_record-phase", 1)

    player:drawCards(3, xiantu.name)
    if #player:getCardIds("he") < 2 or target == player then return end
    local cards = room:askToCards(player, {
      skill_name = xiantu.name,
      include_equip = true,
      min_num = 2,
      max_num = 2,
      prompt = "#wzzz_v__xiantu-give::"..target.id,
      cancelable = false,
    })
    room:moveCardTo(cards, Player.Hand, target, fk.ReasonGive, xiantu.name, nil, false, player)
  end,
})

xiantu:addEffect(fk.EventPhaseEnd, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return
      player:getMark("wzzz_v__xiantu_record-phase") > 0 and
      player:isAlive() and
      #player.room.logic:getEventsOfScope(GameEvent.Death, 1, function(e)
        return e.data.killer == target
      end, Player.HistoryPhase) == 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke("wzzz_v__xiantu", 2)
    room:notifySkillInvoked(player, "wzzz_v__xiantu", "negative")
    room:loseHp(player, 1, xiantu.name)
  end,
})

return xiantu
