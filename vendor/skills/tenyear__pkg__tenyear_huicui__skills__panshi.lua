local wzzz_v__panshi = fk.CreateSkill {
  name = "wzzz_v__panshi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__panshi"] = "叛弑",
  [":wzzz_v__panshi"] = "锁定技，准备阶段，你交给有〖慈孝〗的角色一张手牌。"..
    "你于出牌阶段使用的【杀】对其造成的伤害+1且使用【杀】对其造成伤害后结束出牌阶段。",

  ["#wzzz_v__panshi-give-to"] = "叛弑：你需将一张手牌交给%src",
  ["#wzzz_v__panshi-give"] = "叛弑：你需将一张手牌交给拥有〖慈孝〗的角色",
}

wzzz_v__panshi:addEffect(fk.EventPhaseStart, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Start and
      player:hasSkill(wzzz_v__panshi.name) and not player:isKongcheng() and
      table.find(player.room.alive_players, function(p)
        return p ~= player and p:hasSkill("wzzz_v__cixiao", true)
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local fathers = table.filter(player.room.alive_players, function(p)
      return p ~= player and p:hasSkill("wzzz_v__cixiao", true)
    end)
    event:setCostData(self, { tos = fathers })
    return true
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player.dead or player:isKongcheng() then return end
    local fathers = table.filter(event:getCostData(self).tos, function(p)
      return not p.dead
    end)
    if #fathers == 1 then
      local card = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = false,
        prompt = "#wzzz_v__panshi-give-to:"..fathers[1].id,
        skill_name = wzzz_v__panshi.name,
        cancelable = false,
      })
      room:obtainCard(fathers[1], card, false, fk.ReasonGive, player, wzzz_v__panshi.name)
    elseif #fathers > 1 then
      local to, card = room:askToChooseCardsAndPlayers(player, {
        min_card_num = 1,
        max_card_num = 1,
        min_num = 1,
        max_num = 1,
        targets = fathers,
        pattern = ".|.|.|hand",
        skill_name = wzzz_v__panshi.name,
        prompt = "#wzzz_v__panshi-give",
        cancelable = false,
      })
      room:obtainCard(to[1], card, false, fk.ReasonGive, player, wzzz_v__panshi.name)
    end
  end,
})

wzzz_v__panshi:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__panshi.name) and player.phase == Player.Play and
      data.card and data.card.trueName == "slash" and data.to:hasSkill("wzzz_v__cixiao", true) and
      player.room.logic:damageByCardEffect()
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

wzzz_v__panshi:addEffect(fk.Damage, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__panshi.name) and player.phase == Player.Play and
      data.card and data.card.trueName == "slash" and data.to:hasSkill("wzzz_v__cixiao", true) and
      player.room.logic:damageByCardEffect()
  end,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "wzzz_v__panshi_end_play-turn", 1)
  end,
})

wzzz_v__panshi:addEffect(fk.CardUseFinished, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("wzzz_v__panshi_end_play-turn") > 0 and
      data.card and data.card.trueName == "slash" and player.phase == Player.Play
  end,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "wzzz_v__panshi_end_play-turn", 0)
    player:endPlayPhase()
  end,
})

wzzz_v__panshi:addAcquireEffect(function(self, player)
  player.room:setPlayerMark(player, "@@wzzz_v__panshi_son", 1)
end)

wzzz_v__panshi:addLoseEffect(function(self, player)
  player.room:setPlayerMark(player, "@@wzzz_v__panshi_son", 0)
end)

return wzzz_v__panshi
