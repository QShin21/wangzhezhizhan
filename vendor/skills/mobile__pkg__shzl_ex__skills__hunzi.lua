local hunzi = fk.CreateSkill{
  name = "wzzz_v__m_ex__hunzi",
  tags = { Skill.Wake },
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__hunzi"] = "魂姿",
  [":wzzz_v__m_ex__hunzi"] = "觉醒技，准备阶段，若你的体力值不大于2，你减1点体力上限，然后获得〖英姿〗和〖英魂〗。",

  ["$wzzz_v__m_ex__hunzi1"] = "小霸王之名响彻天下，何人不知？",
  ["$wzzz_v__m_ex__hunzi2"] = "江东已平，中原动荡，直取许昌。",
}

hunzi:addEffect(fk.EventPhaseStart, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(self) and
      player:usedSkillTimes(self.name, Player.HistoryGame) == 0 and
      player.phase == Player.Start
  end,
  can_wake = function(self, event, target, player, data)
    return player.hp <= 2
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:changeMaxHp(player, -1)
    if player.dead then return end
    room:handleAddLoseSkills(player, "wzzz_v__ex__yingzi|wzzz_v__yinghun")
  end,
})

return hunzi
