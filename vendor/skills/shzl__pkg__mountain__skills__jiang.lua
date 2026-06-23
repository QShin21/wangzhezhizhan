local jiang = fk.CreateSkill {
  name = "wzzz_v__jiang",
}

Fk:loadTranslationTable{
  ["wzzz_v__jiang"] = "激昂",
  [":wzzz_v__jiang"] = "当你使用【决斗】或红色【杀】指定目标后，或成为【决斗】或红色【杀】的目标后，你可以摸一张牌。",

  ["$wzzz_v__jiang1"] = "吾乃江东小霸王孙伯符！",
  ["$wzzz_v__jiang2"] = "江东子弟，何惧于天下！",
}

jiang:addEffect(fk.TargetSpecified, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiang.name) and data.firstTarget and
      ((data.card.trueName == "slash" and data.card.color == Card.Red) or data.card.name == "duel")
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, jiang.name)
  end,
})

jiang:addEffect(fk.TargetConfirmed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiang.name) and
      ((data.card.trueName == "slash" and data.card.color == Card.Red) or data.card.name == "duel")
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, jiang.name)
  end,
})

local AI = Fk.Ltk.AI
jiang:addAI(AI.reuse("biyue", AI.InvokeStrategy))

return jiang
