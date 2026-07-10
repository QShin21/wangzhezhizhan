local skill_7236_840c = fk.CreateSkill {
  name = "wzzz_s__7236_840c",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_s__7236_840c"] = "父萌",
  [":" .. "wzzz_s__7236_840c"] = "锁定技，每回合你第一次成为【杀】或【决斗】的目标后，若使用者的手牌数不小于你，此牌对你无效。",
}

local TARGETED_MARK = "wzzz_s__7236_840c_targeted-turn"

skill_7236_840c:addEffect(fk.TargetConfirming, {
  anim_type = "defensive",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill_7236_840c.name, true) and data.from and
      (data.card.trueName == "slash" or data.card.name == "duel")
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addPlayerMark(player, TARGETED_MARK, 1)
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill_7236_840c.name) and data.from and
      (data.card.trueName == "slash" or data.card.name == "duel") and
      player:getMark(TARGETED_MARK) == 1 and
      data.from:getHandcardNum() >= player:getHandcardNum()
  end,
  on_use = function(self, event, target, player, data)
    data:cancelCurrentTarget()
  end,
})

skill_7236_840c:addTest(function(room, me)
  local from = room.players[2]
  local hand = room:printCard("jink")
  local from_cards = { room:printCard("jink"), room:printCard("peach") }
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, skill_7236_840c.name)
    room:obtainCard(me, hand)
    room:useCard { from = from, tos = { me }, card = Fk:cloneCard("slash") }
    room:obtainCard(from, from_cards)
    room:useCard { from = from, tos = { me }, card = Fk:cloneCard("slash") }
  end)
  lu.assertEquals(me:getMark(TARGETED_MARK), 2)
  lu.assertEquals(me.hp, me.maxHp - 2)
end)

return skill_7236_840c
