
Fk:loadTranslationTable{
  ["wzzz_v__ex__luoyi"] = "裸衣",
  [":wzzz_v__ex__luoyi"] = "摸牌阶段开始前，你可以亮出牌堆顶的三张牌，然后你可以跳过摸牌阶段并获得其中所有基本牌、武器牌和【决斗】，"..
    "且直到你的下回合开始，你为伤害来源的【杀】和【决斗】造成的伤害+1，且当你使用的【杀】被【闪】抵消后，你可以摸一张牌。",

  ["@@wzzz_v__ex__luoyi"] = "裸衣",
  ["#wzzz_v__ex__luoyi-ask"] = "裸衣：是否跳过摸牌，获得其中的基本牌、武器和【决斗】，造成伤害+1？",

  ["$wzzz_v__ex__luoyi1"] = "过来打一架，对，就是你！",
  ["$wzzz_v__ex__luoyi2"] = "废话少说，放马过来吧！",
}

local luoyi = fk.CreateSkill{
  name = "wzzz_v__ex__luoyi",
}

luoyi:addEffect(fk.EventPhaseChanging, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(luoyi.name) and data.phase == Player.Draw and not data.skipped
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cids = room:getNCards(3)
    room:turnOverCardsFromDrawPile(player, cids, luoyi.name)
    local cards = table.filter(cids, function(id)
      local card = Fk:getCardById(id)
      return card.type == Card.TypeBasic or card.sub_type == Card.SubtypeWeapon or card.name == "duel"
    end)
    if room:askToSkillInvoke(player, {
        skill_name = luoyi.name,
        prompt = "#wzzz_v__ex__luoyi-ask",
      }) then
      room:obtainCard(player, cards, true, fk.ReasonJustMove, player)
      if not player.dead then
        room:addPlayerMark(player, "@@wzzz_v__ex__luoyi")
      end
      data.skipped = true
    end
    room:cleanProcessingArea(cids)
  end,
})

luoyi:addEffect(fk.TurnStart, {
  can_refresh = function(self, event, target, player, data)
    return target == player
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@wzzz_v__ex__luoyi", 0)
  end,
})

luoyi:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  is_delay_effect = true,
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("@@wzzz_v__ex__luoyi") > 0 and
      data.card and (data.card.trueName == "slash" or data.card.name == "duel") and
      player.room.logic:damageByCardEffect(false)
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

luoyi:addEffect(fk.CardEffectCancelledOut, {
  anim_type = "drawcard",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("@@wzzz_v__ex__luoyi") > 0 and
      data.card and data.card.trueName == "slash"
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, luoyi.name)
  end,
})

luoyi:addTest(function(room, me)
  local comp2, comp3, comp4 = room.players[2], room.players[3], room.players[4]
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, luoyi.name)
  end)
  local slash = Fk:getCardById(1)
  FkTest.setNextReplies(me, { "1", "1", FkTest.ReplyCard(slash, { comp2 }) })
  FkTest.setNextReplies(comp2, { "__cancel" })

  local origin_hp = comp2.hp
  FkTest.runInRoom(function()
    room:obtainCard(me, 1)
    GameEvent.Turn:create(TurnData:new(me, "game_rule")):exec()
  end)
  lu.assertEquals(me:getMark("@@wzzz_v__ex__luoyi"), 1)
  lu.assertEquals(comp2.hp, origin_hp - 2)

  -- 增伤持续到下回合开始，而不是在当前回合结束时清除。
  FkTest.setNextReplies(comp3, { "__cancel" })
  FkTest.runInRoom(function()
    room:useCard{
      from = me,
      tos = { comp3 },
      card = Fk:cloneCard("slash"),
    }
  end)
  lu.assertEquals(comp3.hp, comp3.maxHp - 2)

  -- 下回合开始时清除标记，之后不再增伤。
  FkTest.setNextReplies(comp4, { "__cancel" })
  FkTest.runInRoom(function()
    GameEvent.Turn:create(TurnData:new(me, "game_rule", {})):exec()
    room:useCard{
      from = me,
      tos = { comp4 },
      card = Fk:cloneCard("slash"),
    }
  end)
  lu.assertEquals(me:getMark("@@wzzz_v__ex__luoyi"), 0)
  lu.assertEquals(comp4.hp, comp4.maxHp - 1)
end)

return luoyi
