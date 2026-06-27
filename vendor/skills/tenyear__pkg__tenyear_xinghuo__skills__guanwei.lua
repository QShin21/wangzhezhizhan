local wzzz_v__guanwei = fk.CreateSkill {
  name = "wzzz_v__guanwei",
}

Fk:loadTranslationTable{
  ["wzzz_v__guanwei"] = "观微",
  [":wzzz_v__guanwei"] = "每回合限一次，一名角色的出牌阶段结束后，若其本回合使用过至少两张非虚拟牌，且这些牌花色均相同或均为无色牌，你可以弃置一张牌，"..
  "令其摸两张牌并执行一个额外的出牌阶段。",

  ["#wzzz_v__guanwei-invoke"] = "观微：你可以弃一张牌，令 %dest 摸两张牌并执行一个额外出牌阶段",

  ["$wzzz_v__guanwei1"] = "今日宴请诸位，有要事相商。",
  ["$wzzz_v__guanwei2"] = "天下未定，请主公以大局为重。",
}

wzzz_v__guanwei:addEffect(fk.EventPhaseEnd, {
  times = function (_, player)
    return 1 - player:usedSkillTimes(wzzz_v__guanwei.name, Player.HistoryTurn)
  end,
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(wzzz_v__guanwei.name) and target.phase == Player.Play and
      player:usedSkillTimes(wzzz_v__guanwei.name, Player.HistoryTurn) == 0 and not player:isNude() and not target.dead then
      local x = 0
      local suit = nil
      player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        if use.from == target and not use.card:isVirtual() then
          if suit == nil then
            suit = use.card.suit
          elseif suit ~= use.card.suit then
            x = 0
            return true
          end
          x = x + 1
        end
      end, Player.HistoryTurn)
      return x > 1
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local cards = room:askToDiscard(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = wzzz_v__guanwei.name,
      cancelable = true,
      prompt = "#wzzz_v__guanwei-invoke::"..target.id,
      skip = true,
    })
    if #cards > 0 then
      event:setCostData(self, {tos = {target}, cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:throwCard(event:getCostData(self).cards, wzzz_v__guanwei.name, player, player)
    if not target.dead then
      target:drawCards(2, wzzz_v__guanwei.name)
      if not target.dead then
        target:gainAnExtraPhase(Player.Play, wzzz_v__guanwei.name)
      end
    end
  end,
})

return wzzz_v__guanwei
