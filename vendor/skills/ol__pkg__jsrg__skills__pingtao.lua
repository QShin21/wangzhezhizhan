local pingtao = fk.CreateSkill {
  name = "wzzz_v__ol__pingtao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ol__pingtao"] = "平讨",
  [":wzzz_v__ol__pingtao"] = "锁定技，你使用【杀】对目标角色造成伤害时，若该角色没有手牌或拥有“破虏”，则此伤害+1。",

  ["$wzzz_v__ol__pingtao1"] = "二贼作乱日久，该以时进讨！",
  ["$wzzz_v__ol__pingtao2"] = "王师天兵已至，贼徒还不速降！",
}

pingtao:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pingtao.name) and data.card and
      data.card.trueName == "slash" and data.to and
      (data.to:isKongcheng() or data.to:hasSkill("wzzz_v__os_ex__polu", true))
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

return pingtao
