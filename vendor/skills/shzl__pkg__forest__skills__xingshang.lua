local xingshang = fk.CreateSkill {
  name = "wzzz_v__xingshang",
}

Fk:loadTranslationTable{
  ["wzzz_v__xingshang"] = "行殇",
  [":wzzz_v__xingshang"] = "当其他角色死亡时，你可以获得其所有牌。",

  ["$wzzz_v__xingshang1"] = "我的是我的，你的还是我的。",
  ["$wzzz_v__xingshang2"] = "来，管杀还管埋！",
}

xingshang:addEffect(fk.Death, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(xingshang.name) and not target:isNude()
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player, target:getCardIds("he"), false, fk.ReasonPrey, player, xingshang.name)
  end,
})

xingshang:addAI(Fk.Ltk.AI.newInvokeStrategy{
  think = function(self, ai)
    local data = ai.room.logic:getCurrentEvent().data
    local player = ai.player
    return ai:getBenefitOfEvents(function(logic)
      logic:obtainCard(player, data.who:getCardIds("he"), false, fk.ReasonPrey, player, xingshang.name)
    end) >= 0
  end,
})

return xingshang
