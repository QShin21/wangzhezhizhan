local tongxin = fk.CreateSkill {
  name = "wzzz_v__ty_ex__tongxin",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__tongxin"] = "同心",
  [":wzzz_v__ty_ex__tongxin"] = "锁定技，你的攻击范围+2。",
}

tongxin:addEffect("atkrange", {
  correct_func = function(self, from, to)
    if from:hasSkill(tongxin.name) then
      return 2
    end
  end,
})

return tongxin
