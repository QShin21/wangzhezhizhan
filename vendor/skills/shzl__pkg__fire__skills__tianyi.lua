local tianyi = fk.CreateSkill({
  name = "wzzz_v__tianyi",
})

Fk:loadTranslationTable{
  ["wzzz_v__tianyi"] = "天义",
  [":wzzz_v__tianyi"] = "出牌阶段限一次，你可以与一名角色拼点：若你赢，在本回合结束之前，你可以多使用一张【杀】、使用【杀】无距离限制且可以多选择一个目标；"..
  "若你没赢，本回合你不能使用【杀】。",

  ["#wzzz_v__tianyi"] = "天义：与一名角色拼点，若赢，你使用【杀】获得增益，若没赢，本回合你不能使用【杀】",

  ["$wzzz_v__tianyi1"] = "请助我一臂之力！",
  ["$wzzz_v__tianyi2"] = "我当要替天行道！",
}

tianyi:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__tianyi",
  max_phase_use_time = 1,
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return not player:isKongcheng() and player:usedSkillTimes(tianyi.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and to_select ~= player and player:canPindian(to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local pindian = player:pindian({target}, tianyi.name)
    if player.dead then return end
    if pindian.results[target].winner == player then
      room:addPlayerMark(player, "wzzz_v__tianyi_win-turn", 1)
    else
      room:addPlayerMark(player, "wzzz_v__tianyi_lose-turn", 1)
    end
  end,
})
tianyi:addEffect("targetmod", {
  residue_func = function(self, player, skill, scope)
    if skill.trueName == "slash_skill" and player:getMark("wzzz_v__tianyi_win-turn") > 0 and scope == Player.HistoryPhase then
      return 1
    end
  end,
  bypass_distances =  function(self, player, skill)
    return skill.trueName == "slash_skill" and player:getMark("wzzz_v__tianyi_win-turn") > 0
  end,
  extra_target_func = function(self, player, skill)
    if skill.trueName == "slash_skill" and player:getMark("wzzz_v__tianyi_win-turn") > 0 then
      return 1
    end
  end,
})

tianyi:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    return player:getMark("wzzz_v__tianyi_lose-turn") > 0 and card.trueName == "slash"
  end,
})

tianyi:addTest(function(room, me)
  local comp2, comp3, comp4 = room.players[2], room.players[3], room.players[4]
  local slashK = room:printCard("slash", Card.Diamond, 13)
  local jinkA = room:printCard("jink", Card.Club, 1)
  local peachA = room:printCard("peach", Card.Spade, 1)
  local analepticK = room:printCard("analeptic", Card.Heart, 13)
  local slash = Fk:getCardById(1)
  local slash2 = Fk:getCardById(2)

  -- test1: 第一个出牌阶段内：对comp2发动天义，用A拼K，暂停发现不能出杀
  FkTest.setNextReplies(me, {
    FkTest.ReplyUseSkill(tianyi.name, { comp2 }),
    FkTest.ReplyChooseCards({ jinkA.id }),
  })
  FkTest.setNextReplies(comp2, {
    FkTest.ReplyChooseCards({ analepticK.id }),
  })
  -- 用了点辣鸡手段 让他在第二次询问PlayCard时切出
  local function createTwiceClosure()
    local i = 0
    return function()
      i = i + 1
      return i == 2
    end
  end
  FkTest.setRoomBreakpoint(me, "PlayCard", createTwiceClosure())
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, tianyi.name)
    room:obtainCard(me, { slashK.id, jinkA.id, slash.id, slash2.id })
    room:obtainCard(comp2, { peachA.id, analepticK.id })
    me:gainAnExtraTurn(false, "", { Player.Play })
  end)

  -- 拼点没赢时禁止使用杀，且本阶段不能再次发动天义。
  lu.assertEquals(me:getMark("wzzz_v__tianyi_lose-turn"), 1)
  lu.assertIsFalse(me:canUse(slash))
  lu.assertIsFalse(Fk.skills[tianyi.name]:canUse(me))

  -- 结束出牌阶段，让房间恢复正常
  FkTest.resumeRoom()

  -- test2: 用K拼A，再中断一次检查tmd技能生效情况
  FkTest.setNextReplies(me, {
    FkTest.ReplyUseSkill(tianyi.name, { comp2 }),
    FkTest.ReplyChooseCards({ slashK.id }),
  })
  FkTest.setNextReplies(comp2, {
    FkTest.ReplyChooseCards({ peachA.id }),
  })
  FkTest.setRoomBreakpoint(me, "PlayCard", createTwiceClosure())
  FkTest.runInRoom(function()
    me:gainAnExtraTurn(false, "", { Player.Play })
  end)
  lu.assertEquals(me:getMark("wzzz_v__tianyi_win-turn"), 1)
  lu.assertIsTrue(me:canUseTo(slash, comp4))
  lu.assertEquals(slash:getSkill(me):getMaxTargetNum(me, slash), 2)

  FkTest.setNextReplies(me, {
    FkTest.ReplyCard(slash, { comp2, comp3 }),
    FkTest.ReplyCard(slash2, { comp4 }),
    "__cancel",
  })
  FkTest.setNextReplies(comp2, { "__cancel" })
  FkTest.setNextReplies(comp3, { "__cancel" })
  FkTest.setNextReplies(comp4, { "__cancel" })
  FkTest.resumeRoom()
  lu.assertEquals(comp2.hp, comp2.maxHp - 1)
  lu.assertEquals(comp3.hp, comp3.maxHp - 1)
  lu.assertEquals(comp4.hp, comp4.maxHp - 1)
end)

return tianyi
