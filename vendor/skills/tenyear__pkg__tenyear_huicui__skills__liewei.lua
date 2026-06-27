local liewei = fk.CreateSkill {
  name = "wzzz_v__ty__liewei",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__liewei"] = "裂围",
  [":wzzz_v__ty__liewei"] = "当一名角色进入濒死状态时，你可以摸一张牌（每回合限一次）。当你杀死一名角色后，你可以复原“挫锐”或摸两张牌。",
  ["wzzz_v__ty__liewei_reset_cuorui"] = "复原“挫锐”",
  ["wzzz_v__ty__liewei_draw2"] = "摸两张牌",

  ["$wzzz_v__ty__liewei1"] = "都给我交出来！",
  ["$wzzz_v__ty__liewei2"] = "还有点用，暂且饶你一命！",
}

liewei:addEffect(fk.EnterDying, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(liewei.name) and player:usedSkillTimes(liewei.name, Player.HistoryTurn) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = liewei.name,
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, liewei.name)
  end,
})

liewei:addEffect(fk.Deathed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(liewei.name) and data.killer == player
  end,
  on_cost = function(self, event, target, player, data)
    local choices = {"wzzz_v__ty__liewei_draw2", "Cancel"}
    if player:usedSkillTimes("wzzz_v__ol__cuorui", Player.HistoryGame) > 0 then
      table.insert(choices, 1, "wzzz_v__ty__liewei_reset_cuorui")
    end
    local choice = player.room:askToChoice(player, {
      choices = choices,
      skill_name = liewei.name,
    })
    if choice == "Cancel" then
      return false
    end
    event:setCostData(self, choice)
    return true
  end,
  on_use = function(self, event, target, player, data)
    if event:getCostData(self) == "wzzz_v__ty__liewei_reset_cuorui" then
      player:setSkillUseHistory("wzzz_v__ol__cuorui", 0, Player.HistoryGame)
    else
      player:drawCards(2, liewei.name)
    end
  end,
})

return liewei
