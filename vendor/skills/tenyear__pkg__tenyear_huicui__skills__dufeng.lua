local dufeng = fk.CreateSkill {
  name = "wzzz_v__dufeng",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable {
  ["wzzz_v__dufeng"] = "独锋",
  [":wzzz_v__dufeng"] = "限定技，出牌阶段开始时，你可以失去1点体力，令你本回合使用【杀】的次数+Y（Y为你已损失体力值-1）。",
  ["#wzzz_v__dufeng-invoke"] = "独锋：是否失去1点体力，令本回合使用【杀】次数增加？",

  ["$wzzz_v__dufeng1"] = "不畏死者，都随我来！",
  ["$wzzz_v__dufeng2"] = "大功当前，小损又何妨！",
}

dufeng:addEffect(fk.EventPhaseStart, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and target:hasSkill(dufeng.name) and player.phase == Player.Play and
      player:usedSkillTimes(dufeng.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = dufeng.name,
      prompt = "#wzzz_v__dufeng-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:loseHp(player, 1, dufeng.name)
    if player.dead then return end
    local y = math.max(0, player:getLostHp() - 1)
    if y > 0 then
      room:setPlayerMark(player, "wzzz_v__dufeng-turn", y)
    end
  end,
})

dufeng:addEffect("targetmod", {
  residue_func = function(self, player, skill, scope)
    if skill.trueName == "slash_skill" and scope == Player.HistoryPhase then
      return player:getMark("wzzz_v__dufeng-turn")
    end
  end,
})

return dufeng
