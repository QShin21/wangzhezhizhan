local wulie = fk.CreateSkill{
  name = "wzzz_v__wulie",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable {
  ["wzzz_v__wulie"] = "武烈",
  [":wzzz_v__wulie"] = "限定技，结束阶段，你可以选择至多等同你体力值的其他角色并失去等量体力，然后防止这些角色下一次受到的伤害。",

  ["@@wzzz_v__wulie_lie"] = "烈",
  ["#wzzz_v__wulie-choose"] = "武烈：选择任意名其他角色并失去等量的体力，防止这些角色受到的下次伤害",

  ["$wzzz_v__wulie1"] = "孙武之后，英烈勇战。",
  ["$wzzz_v__wulie2"] = "兴义之中，忠烈之名。",
}

wulie:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wulie.name) and player.phase == Player.Finish and
      player:usedSkillTimes(wulie.name, Player.HistoryGame) < 1 and player.hp > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
      targets = room:getOtherPlayers(player, false),
      min_num = 1,
      max_num = player.hp,
      prompt = "#wzzz_v__wulie-choose",
      skill_name = wulie.name,
      cancelable = true,
    })
    if #tos > 0 then
      room:sortByAction(tos)
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:loseHp(player, #event:getCostData(self).tos, wulie.name)
    for _, p in ipairs(event:getCostData(self).tos) do
      if not p.dead then
        room:setPlayerMark(p, "@@wzzz_v__wulie_lie", 1)
      end
    end
  end,
})

wulie:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("@@wzzz_v__wulie_lie") > 0
  end,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@wzzz_v__wulie_lie", 0)
    data:preventDamage()
  end,
})

return wulie
