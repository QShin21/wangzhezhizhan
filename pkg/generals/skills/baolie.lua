local baolie = fk.CreateSkill {
  name = "wzzz__baolie",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable {
  ["wzzz__baolie"] = "豹烈",
  [":wzzz__baolie"] = "限定技，准备阶段，你可以对自己造成2点伤害。",
}

baolie:addEffect(fk.EventPhaseStart, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(baolie.name) and player.phase == Player.Start and
      player:usedSkillTimes(baolie.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, { skill_name = baolie.name })
  end,
  on_use = function(self, event, target, player, data)
    player.room:damage { from = player, to = player, damage = 2, skillName = baolie.name }
  end,
})

return baolie
