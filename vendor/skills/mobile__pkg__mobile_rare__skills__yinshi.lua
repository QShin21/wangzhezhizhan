local yinshi = fk.CreateSkill {
  name = "wzzz_v__yinship",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__yinship"] = "隐世",
  [":wzzz_v__yinship"] = "锁定技，你跳过判定阶段。",
}

yinshi:addEffect(fk.EventPhaseChanging, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yinshi.name) and
      data.phase == Player.Judge and not data.skipped
  end,
  on_use = function (self, event, target, player, data)
    data.skipped = true
  end,
})

return yinshi
