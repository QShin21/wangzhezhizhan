local weizhong = fk.CreateSkill {
  name = "wzzz_v__weizhong",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__weizhong"] = "威重",
  [":wzzz_v__weizhong"] = "锁定技，当你的体力上限减少时，你摸一张牌；本局进入鏖战阶段后，你须执行的鏖战效果修改为：失去1点体力。",

  ["$wzzz_v__weizhong"] = "定当夷司马氏三族！",
}

weizhong:addEffect(fk.MaxHpChanged, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(weizhong.name) and data.num < 0
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, weizhong.name)
  end,
})

return weizhong
