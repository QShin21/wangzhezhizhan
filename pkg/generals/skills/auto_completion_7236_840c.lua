local skill_7236_840c = fk.CreateSkill {
  name = "wzzz_s__7236_840c",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_s__7236_840c"] = "父萌",
  [":" .. "wzzz_s__7236_840c"] = "锁定技，每回合你第一次成为【杀】或【决斗】的目标后，若使用者的手牌数不小于你，此牌对你无效。",
}

skill_7236_840c:addEffect(fk.TargetConfirming, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill_7236_840c.name) and data.from and
      (data.card.trueName == "slash" or data.card.name == "duel") and
      player:usedSkillTimes(skill_7236_840c.name, Player.HistoryTurn) == 0 and
      data.from:getHandcardNum() >= player:getHandcardNum()
  end,
  on_use = function(self, event, target, player, data)
    data:cancelCurrentTarget()
  end,
})

return skill_7236_840c
