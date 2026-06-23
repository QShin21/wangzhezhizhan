local wanrong = fk.CreateSkill {
  name = "wzzz__wanrong",
}

Fk:loadTranslationTable{
  ["wzzz__wanrong"] = "婉容",
  [":wzzz__wanrong"] = "当你成为【杀】的目标后，你可以摸一张牌。",

  ["$wzzz__wanrong1"] = "呵哼哼~",
  ["$wzzz__wanrong2"] = "看这里，看这里哦~",
}

wanrong:addEffect(fk.TargetConfirmed, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wanrong.name) and data.card.trueName == "slash"
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, wanrong.name)
  end,
})

return wanrong
