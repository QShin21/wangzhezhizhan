local zhouyuYingzi = fk.CreateSkill {
  name = "wzzz_v__zhouyu__yingzi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__zhouyu__yingzi"] = "英姿",
  [":wzzz_v__zhouyu__yingzi"] = "锁定技，摸牌阶段，你多摸一张牌；你的手牌上限+X（X为你的体力上限）。",
}

zhouyuYingzi:addEffect(fk.DrawNCards, {
  anim_type = "drawcard",
  on_use = function(self, event, target, player, data)
    data.n = data.n + 1
  end,
})

zhouyuYingzi:addEffect("maxcards", {
  correct_func = function(self, player)
    if player:hasSkill(zhouyuYingzi.name) then
      return player.maxHp
    end
  end,
})

return zhouyuYingzi
