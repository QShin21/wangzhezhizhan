Fk:loadTranslationTable{
  ["wzzz_v__ex__tishen"] = "替身",
  [":wzzz_v__ex__tishen"] = "限定技，准备阶段，你可以将体力回复至体力上限并摸X张牌（X为你回复的体力值），然后修改“咆哮”。",

  ["#tishen-invoke"] = "替身：你可以回复%arg点体力并摸%arg张牌",

  ["$wzzz_v__ex__tishen1"] = "欺我无谋，定要尔等血偿！",
  ["$wzzz_v__ex__tishen2"] = "谁，还敢过来一战！？",
}

local tishen = fk.CreateSkill{
  name = "wzzz_v__ex__tishen",
  tags = { Skill.Limited },
}

tishen:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(tishen.name) and player.phase == Player.Start and
      player:isWounded() and player:usedSkillTimes(tishen.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    local maxHp = player.maxHp - player.hp
    return player.room:askToSkillInvoke(player, {
      skill_name = tishen.name,
      prompt = "#tishen-invoke:::"..maxHp,
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local n = player.maxHp - player.hp
    room:recover{
      who = player,
      num = n,
      recoverBy = player,
      skillName = tishen.name,
    }
    if not player.dead then
      player:drawCards(n, tishen.name)
      room:setPlayerMark(player, "wzzz_v__ex__tishen_modified", 1)
    end
  end,
})

tishen:addTest(function(room, me)
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, "wzzz_v__ex__tishen")
  end)
  FkTest.setNextReplies(me, { "1" })
  local add = math.random(1, 10)
  FkTest.runInRoom(function()
    room:changeMaxHp(me, add)
    GameEvent.Turn:create(TurnData:new(me, "game_rule", { Player.Start })):exec()
  end)
  lu.assertEquals(me.hp, me.maxHp)
  lu.assertEquals(#me:getCardIds("h"), add)
end)

return tishen
