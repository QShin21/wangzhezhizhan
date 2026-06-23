local shixin = fk.CreateSkill {
  name = "wzzz_v__shixin",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__shixin"] = "释衅",
  [":wzzz_v__shixin"] = "锁定技，防止你受到的火属性伤害。",

  ["$wzzz_v__shixin1"] = "释怀之戾气，化君之不悦。",
  ["$wzzz_v__shixin2"] = "星星之火，安能伤我？",
}

shixin:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(shixin.name) and data.damageType == fk.FireDamage
  end,
  on_use = function (self, event, target, player, data)
    data:preventDamage()
  end,
})

return shixin
