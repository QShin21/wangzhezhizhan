local wzzz_v__gongqing = fk.CreateSkill {
  name = "wzzz_v__gongqing",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__gongqing"] = "公清",
  [":wzzz_v__gongqing"] = "锁定技，当你受到伤害时，若伤害来源的攻击范围小于3，将伤害值改为1；当你受到伤害时，若伤害来源的攻击范围大于3，你此伤害值+1。",

  ["$wzzz_v__gongqing1"] = "尔辈何故与降虏交善。",
  ["$wzzz_v__gongqing2"] = "豪将在外，增兵必成祸患啊！",
}

wzzz_v__gongqing:addEffect(fk.DamageInflicted, {
  anim_type = "negative",
  audio_index = 2,
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(wzzz_v__gongqing.name) and
      data.from and
      data.from:getAttackRange() > 3
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

wzzz_v__gongqing:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  audio_index = 1,
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(wzzz_v__gongqing.name) and
      data.from and
      data.from:getAttackRange() < 3 and
      data.damage > 1
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1 - data.damage)
  end,
})

return wzzz_v__gongqing
