local yongjue = fk.CreateSkill {
  name = "wzzz_v__ty__yongjue",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__yongjue"] = "勇决",
  [":wzzz_v__ty__yongjue"] = "当你于出牌阶段使用第一张【杀】时，你可以选择一项：1.此【杀】结算结束后，你获得之；2.令此【杀】无次数限制。",

  ["wzzz_v__ty__yongjue_time"] = "此【杀】不计次数",
  ["wzzz_v__ty__yongjue_prey"] = "获得%arg",

  ["$wzzz_v__ty__yongjue1"] = "能救一个是一个！",
  ["$wzzz_v__ty__yongjue2"] = "扶幼主，成霸业！",
}

yongjue:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(yongjue.name) and
      player.phase == Player.Play and data.card.trueName == "slash" and
      player:usedSkillTimes(yongjue.name, Player.HistoryPhase) == 0 then
      local use_events = player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
        local use = e.data
        return use.from == player and use.card.trueName == "slash"
      end, Player.HistoryPhase)
      if #use_events == 1 and use_events[1].data == data then
        return not data.extraUse or player.room:getCardArea(data.card) == Card.Processing
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local all_choices = { "wzzz_v__ty__yongjue_time", "wzzz_v__ty__yongjue_prey:::"..data.card:toLogString(), "Cancel" }
    local choices = table.simpleClone(all_choices)
    if room:getCardArea(data.card) ~= Card.Processing then
      table.remove(choices, 2)
    end
    if data.extraUse then
      table.remove(choices, 1)
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = yongjue.name,
      all_choices = all_choices,
    })
    if choice ~= "Cancel" then
      event:setCostData(self, {choice = choice})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choice = event:getCostData(self).choice
    if choice == "wzzz_v__ty__yongjue_time" then
      data.extraUse = true
      player:addCardUseHistory(data.card.trueName, -1)
    else
      data.extra_data = data.extra_data or {}
      data.extra_data.wzzz_v__ty__yongjue_prey = player.id
    end
  end,
})

yongjue:addEffect(fk.CardUseFinished, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return (data.extra_data or {}).wzzz_v__ty__yongjue_prey == player.id and
      player:hasSkill(yongjue.name, true) and player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player, data.card, true, fk.ReasonJustMove, player, yongjue.name)
  end,
})

return yongjue
