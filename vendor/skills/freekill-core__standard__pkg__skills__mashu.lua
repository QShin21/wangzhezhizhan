local mashu = fk.CreateSkill{
  name = "wzzz_v__mashu",
  tags = { Skill.Compulsory },
}

mashu:addEffect("distance", {
  correct_func = function(self, from, to)
    if from:hasSkill(mashu.name) then
      return -1
    end
  end,
})

return mashu
