Fk:loadTranslationTable{
  ["wzzz_v__ex__biyue"] = "闭月",
  [":wzzz_v__ex__biyue"] = "结束阶段，若你的手牌数小于你的体力值，你可以摸两张牌，否则摸一张牌。",

  ["$wzzz_v__ex__biyue1"] = "梦蝶幻月，如沫虚妄。",
  ["$wzzz_v__ex__biyue2"] = "水映月明，芙蓉照倩影。",
}

local biyue = fk.CreateSkill{
  name = "wzzz_v__ex__biyue",
}

biyue:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(biyue.name) and player.phase == Player.Finish
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = biyue.name,
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(player:getHandcardNum() < player.hp and 2 or 1, biyue.name)
  end,
})

biyue:addTest(function(room, me)
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, biyue.name)
  end)

  FkTest.setNextReplies(me, { "1", "1" })
  FkTest.runInRoom(function()
    GameEvent.Turn:create(TurnData:new(me, "game_rule", { Player.Finish })):exec()
  end)

  lu.assertEquals(#me:getCardIds("h"), 2)
  FkTest.runInRoom(function()
    GameEvent.Turn:create(TurnData:new(me, "game_rule", { Player.Finish })):exec()
  end)

  lu.assertEquals(#me:getCardIds("h"), 3)
end)

return biyue
