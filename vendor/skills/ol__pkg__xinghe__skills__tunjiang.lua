local tunjiang = fk.CreateSkill{
  name = "wzzz_v__tunjiang",
}

Fk:loadTranslationTable{
  ["wzzz_v__tunjiang"] = "屯江",
  [":wzzz_v__tunjiang"] = "结束阶段，若你未执行出牌阶段或于出牌阶段内未对其他角色使用过牌，你可以摸X张牌（X为全场势力数）。",

  ["$wzzz_v__tunjiang1"] = "皇叔勿惊，吾与关将军已到。",
  ["$wzzz_v__tunjiang2"] = "江夏冲要之地，孩儿愿往守之。",
}

tunjiang:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(tunjiang.name) and player.phase == Player.Finish then
      local turnEvent = player.room.logic:getCurrentEvent():findParent(GameEvent.Turn)
      if not turnEvent then return false end
      if table.find(turnEvent.data.phase_table, function(phase)
        return phase.who == player and phase.phase == Player.Play and phase.skipped
      end) then
        return true
      end

      local phase_events = player.room.logic:getEventsOfScope(GameEvent.Phase, 999, function (e)
        return e.data.phase == Player.Play
      end, Player.HistoryTurn)
      return #player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        return use.from and table.find(use.tos, function (p)
          return p ~= player
        end) and
        table.find(phase_events, function (phase)
          return phase.id < e.id and phase.end_id > e.id
        end) ~= nil
      end, Player.HistoryTurn) == 0
    end
  end,
  on_use = function(self, event, target, player, data)
    local kingdoms = {}
    for _, p in ipairs(player.room.alive_players) do
      table.insertIfNeed(kingdoms, p.kingdom)
    end
    player:drawCards(#kingdoms, tunjiang.name)
  end,
})

return tunjiang
