local wzzz_v__huaizi = fk.CreateSkill {
  name = "wzzz_v__huaizi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__huaizi"] = "怀子",
  [":wzzz_v__huaizi"] = "锁定技，你的手牌上限等于体力上限。",
}

wzzz_v__huaizi:addEffect("maxcards", {
  fixed_func = function(self, player)
    if player:hasSkill(wzzz_v__huaizi.name) then
      return player.maxHp
    end
  end,
})

return wzzz_v__huaizi
