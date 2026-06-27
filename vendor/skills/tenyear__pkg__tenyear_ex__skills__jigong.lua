local jigong = fk.CreateSkill {
  name = "wzzz_v__ty_ex__jigong",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__jigong"] = "急攻",
  [":wzzz_v__ty_ex__jigong"] = "出牌阶段开始时，你可以摸一至两张牌，然后你本回合的手牌上限改为X（X为你此阶段造成过的伤害数），弃牌阶段开始时，若X不小于你摸的牌数，你回复1点体力。",

  ["#wzzz_v__ty_ex__jigong-choice"] = "急攻：摸一至两张牌，本回合手牌上限改为本阶段造成伤害值",
  ["@wzzz_v__ty_ex__jigong-turn"] = "急攻",

  ["$wzzz_v__ty_ex__jigong1"] = "此时不战，更待何时！",
  ["$wzzz_v__ty_ex__jigong2"] = "箭在弦上，不得不发！",
}


jigong:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jigong.name) and player.phase == Player.Play
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local choice = room:askToChoice(player, {
      choices = {"1", "2", "Cancel"},
      skill_name = jigong.name,
      prompt = "#wzzz_v__ty_ex__jigong-choice",
    })
    if choice ~= "Cancel" then
      event:setCostData(self, {choice = tonumber(choice)})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local n = event:getCostData(self).choice
    room:addPlayerMark(player, "wzzz_v__ty_ex__jigong_draw-turn", n)
    room:setPlayerMark(player, "@wzzz_v__ty_ex__jigong-turn",
      string.format("%d/%d", player:getMark("wzzz_v__ty_ex__jigong_draw-turn"), player:getMark("wzzz_v__ty_ex__jigong_damage-turn")))
    player:drawCards(n, jigong.name)
  end,
})

jigong:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Discard and
      player:usedSkillTimes(jigong.name, Player.HistoryTurn) > 0 and
      player:getMark("wzzz_v__ty_ex__jigong_damage-turn") >= player:getMark("wzzz_v__ty_ex__jigong_draw-turn") and
      player:isWounded()
  end,
  on_use = function(self, event, target, player, data)
    player.room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = jigong.name,
    }
  end,
})

jigong:addEffect(fk.Damage, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:usedSkillTimes(jigong.name, Player.HistoryPhase) > 0 and not player.dead
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "wzzz_v__ty_ex__jigong_damage-turn", data.damage)
    room:setPlayerMark(player, "@wzzz_v__ty_ex__jigong-turn",
      string.format("%d/%d", player:getMark("wzzz_v__ty_ex__jigong_draw-turn"), player:getMark("wzzz_v__ty_ex__jigong_damage-turn")))
  end,
})

jigong:addEffect("maxcards", {
  fixed_func = function (self, player)
    if player:usedSkillTimes(jigong.name, Player.HistoryTurn) > 0 then
      return player:getMark("wzzz_v__ty_ex__jigong_damage-turn")
    end
  end,
})

return jigong
