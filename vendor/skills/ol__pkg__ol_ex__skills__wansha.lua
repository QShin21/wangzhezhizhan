local wansha = fk.CreateSkill {
  name = "wzzz_v__ol_ex__wansha",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__wansha"] = "完杀",
  [":wzzz_v__ol_ex__wansha"] = "锁定技，你的回合内，若有角色处于濒死状态，只有你和处于濒死状态的角色才能使用【桃】；任意角色的濒死结算中，除你和濒死角色外的其他角色非锁定技失效。",

  ["$wzzz_v__ol_ex__wansha1"] = "有谁敢试试？",
  ["$wzzz_v__ol_ex__wansha2"] = "斩草务尽，以绝后患。",
}

wansha:addEffect("prohibit" ,{
  prohibit_use = function(self, player, card)
    if card.name == "peach" and not player.dying then
      local room = Fk:currentRoom()
      return table.find(room.players, function(p) return p.dying end) and
        room.current and room.current:hasSkill(wansha.name) and room.current ~= player
    end
  end,
})

wansha:addEffect("invalidity", {
  recheck_invalidity = true,
  invalidity_func = function(self, from, skill)
    if table.find(Fk:currentRoom().players, function(p)
      return p.dying
    end) and
    table.find(Fk:currentRoom().alive_players, function(p)
      return Fk:currentRoom().current == p and p:hasSkill(wansha.name) and p ~= from
    end) and
    not from.dying then
      return table.contains(from.player_skills, skill) and skill:isPlayerSkill(from) and
        not skill:hasTag(Skill.Compulsory)
    end
  end,
})

wansha:addEffect(fk.EnterDying, {
  anim_type = "offensive",
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(wansha.name) and player.room.current == player
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:notifySkillInvoked(player, wansha.name)
    player:broadcastSkillInvoke(wansha.name)
  end,
})

wansha:addTest(function (room, me)
  local dying = room.players[2]
  local other = room.players[3]
  local peach = room:printCard("peach")
  FkTest.runInRoom(function ()
    room:handleAddLoseSkills(me, wansha.name)
    room:handleAddLoseSkills(other, "wzzz_v__ex__biyue|wzzz_v__ty_ex__jinjiu")
    room:loseHp(me, 1)
    room:loseHp(other, 1)
    room:setCurrent(me)
    dying.dying = true
  end)

  FkTest.runInRoom(function ()
    lu.assertIsTrue(other:prohibitUse(peach))
    lu.assertIsFalse(me:prohibitUse(peach))
    lu.assertIsFalse(dying:prohibitUse(peach))
    lu.assertIsFalse(Fk.skills["wzzz_v__ex__biyue"]:isEffectable(other))
    lu.assertIsTrue(Fk.skills["wzzz_v__ty_ex__jinjiu"]:isEffectable(other))

    dying.dying = false
    lu.assertIsFalse(other:prohibitUse(peach))
    lu.assertIsTrue(Fk.skills["wzzz_v__ex__biyue"]:isEffectable(other))
  end)
end)

return wansha
