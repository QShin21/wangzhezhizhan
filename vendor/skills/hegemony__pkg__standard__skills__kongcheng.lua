local kongcheng = fk.CreateSkill{
  name = "wzzz_v__hs__kongcheng",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__hs__kongcheng"] = "空城",
  [":wzzz_v__hs__kongcheng"] = "锁定技，若你没有手牌，你不能成为【杀】或【决斗】的目标。",
  ["$wzzz_v__hs__kongcheng1"] = "（抚琴声）",
  ["$wzzz_v__hs__kongcheng2"] = "（抚琴声）",
}

kongcheng:addEffect(fk.TargetConfirming, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(kongcheng.name) and player:isKongcheng() and
      (data.card.trueName == "slash" or data.card.name == "duel")
  end,
  on_use = function(self, event, target, player, data)
    data:cancelTarget(player)
  end
})

return kongcheng
