local pojun = fk.CreateSkill {
  name = "wzzz_v__ty_ex__pojun",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__pojun"] = "破军",
  [":wzzz_v__ty_ex__pojun"] = "当你使用【杀】指定目标后，你可以将该角色的至多X张牌扣置于其武将牌上，本回合结束后，其获得这些牌（X为其体力值）；当你使用【杀】对目标角色造成伤害时，若其手牌区和装备区里的牌数均不大于你，此伤害+1。",

  ["#wzzz_v__ty_ex__pojun-invoke"] = "破军：你可以扣置 %dest 至多%arg张牌",
  ["$wzzz_v__ty_ex__pojun"] = "破军",

  ["$wzzz_v__ty_ex__pojun1"] = "奋身出命，为国建功！",
  ["$wzzz_v__ty_ex__pojun2"] = "披甲持戟，先登陷陈！",
}

pojun:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pojun.name) and data.card.trueName == "slash" and
      not data.to.dead and data.to.hp > 0 and not data.to:isNude()
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = pojun.name,
      prompt = "#wzzz_v__ty_ex__pojun-invoke::"..data.to.id..":"..data.to.hp,
    }) then
      event:setCostData(self, {tos = {data.to}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = room:askToChooseCards(player, {
      skill_name = pojun.name,
      target = data.to,
      flag = "he",
      min = 1,
      max = data.to.hp,
    })
    data.to:addToPile("$wzzz_v__ty_ex__pojun", cards, false, pojun.name, player)
  end,
})

pojun:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pojun.name) and data.card and data.card.trueName == "slash" and
      data.to:getHandcardNum() <= player:getHandcardNum() and
      #data.to:getCardIds("e") <= #player:getCardIds("e")
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

pojun:addEffect(fk.TurnEnd, {
  is_delay_effect = true,
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return not player.dead and #player:getPile("$wzzz_v__ty_ex__pojun") > 0
  end,
  on_use = function(self, event, target, player, data)
    player.room:moveCardTo(player:getPile("$wzzz_v__ty_ex__pojun"), Player.Hand, player, fk.ReasonJustMove, pojun.name)
  end,
})

return pojun
