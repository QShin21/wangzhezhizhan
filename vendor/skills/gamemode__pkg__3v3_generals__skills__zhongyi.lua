local zhongyi = fk.CreateSkill {
  name = "wzzz_v__zhongyi",
  tags = { Skill.Limited },
  derived_piles = "wzzz_v__zhongyi",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhongyi"] = "忠义",
  [":wzzz_v__zhongyi"] = "限定技，出牌阶段，你可以将一张红色牌置于你的武将牌上，若你有“忠义”牌，己方角色使用【杀】造成的伤害+1，你的下个准备阶段移去“忠义”牌。当己方角色杀死一名角色后，你复原并修改此技能。（修改“忠义”效果为“己方其他角色使用【杀】造成的伤害+1”）",

  ["#wzzz_v__zhongyi"] = "忠义：将一张红色牌置于武将牌上，己方角色使用【杀】造成的伤害+1",
  ["@@wzzz_v__zhongyi_modified"] = "忠义改",
}

zhongyi:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__zhongyi",
  target_num = 0,
  min_card_num = 1,
  max_card_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(zhongyi.name, Player.HistoryGame) == 0 and #player:getPile(zhongyi.name) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).color == Card.Red
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    player:addToPile(zhongyi.name, effect.cards, true, zhongyi.name, player)
  end,
})

zhongyi:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target and player:hasSkill(zhongyi.name, true) and #player:getPile(zhongyi.name) > 0 and
      data.card and data.card.trueName == "slash" and target:isFriend(player) and
      (player:getMark("@@wzzz_v__zhongyi_modified") == 0 or target ~= player)
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

zhongyi:addEffect(fk.EventPhaseStart, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Start and #player:getPile(zhongyi.name) > 0
  end,
  on_use = function(self, event, target, player, data)
    player.room:moveCardTo(player:getPile(zhongyi.name), Card.DiscardPile, nil, fk.ReasonPutIntoDiscardPile, zhongyi.name)
  end,
})

zhongyi:addEffect(fk.Deathed, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(zhongyi.name, true) and data.killer and data.killer:isFriend(player)
  end,
  on_use = function(self, event, target, player, data)
    player:setSkillUseHistory(zhongyi.name, 0, Player.HistoryGame)
    player.room:setPlayerMark(player, "@@wzzz_v__zhongyi_modified", 1)
  end,
})

return zhongyi
