local weizhong = fk.CreateSkill {
  name = "wzzz_v__weizhong",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__weizhong"] = "威重",
  [":wzzz_v__weizhong"] = "锁定技，当你的体力上限增加或减少时，你摸一张牌。",

  ["$wzzz_v__weizhong"] = "定当夷司马氏三族！",
}

weizhong:addEffect(fk.MaxHpChanged, {
  anim_type = "drawcard",
  on_use = function(self, event, target, player, data)
    player:drawCards(1, weizhong.name)
  end,
})

return weizhong
