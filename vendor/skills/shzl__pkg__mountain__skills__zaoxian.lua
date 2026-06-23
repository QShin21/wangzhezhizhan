local zaoxian = fk.CreateSkill {
  name = "wzzz_v__zaoxian",
  tags = {Skill.Wake},
  related_skills = { "wzzz_v__jixi" },
}

Fk:loadTranslationTable{
  ["wzzz_v__zaoxian"] = "凿险",
  [":wzzz_v__zaoxian"] = "觉醒技，准备阶段，若“田”的数量不少于3张，你减1点体力上限，然后获得〖急袭〗。",

  ["$wzzz_v__zaoxian1"] = "屯田日久，当建奇功！",
  ["$wzzz_v__zaoxian2"] = "开辟险路，奇袭敌军！",
}

zaoxian:addEffect(fk.EventPhaseStart, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zaoxian.name) and
      player:usedSkillTimes(zaoxian.name, Player.HistoryGame) == 0 and
      player.phase == Player.Start
  end,
  can_wake = function(self, event, target, player, data)
    return #player:getPile("dengai_field") > 2
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:changeMaxHp(player, -1)
    if not player.dead then
      room:handleAddLoseSkills(player, "wzzz_v__jixi", nil, true, false)
    end
  end,
})

return zaoxian
