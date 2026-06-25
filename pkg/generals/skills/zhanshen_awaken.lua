local zhanshen = fk.CreateSkill {
  name = "wzzz__zhanshen_awaken",
  tags = { Skill.Wake },
}

Fk:loadTranslationTable {
  ["wzzz__zhanshen_awaken"] = "战神",
  [":wzzz__zhanshen_awaken"] = "觉醒技，准备阶段，若你已受伤且场上存活人数小于5，你减1点体力上限，并可以弃置装备区里的武器牌，然后获得“马术”和“神戟”。",
  ["#wzzz__zhanshen_awaken-discard"] = "战神：你可以弃置装备区里的武器牌",
}

zhanshen:addEffect(fk.EventPhaseStart, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhanshen.name) and player.phase == Player.Start and
      player:usedSkillTimes(zhanshen.name, Player.HistoryGame) == 0
  end,
  can_wake = function(self, event, target, player, data)
    return player:isWounded() and #player.room.alive_players < 5
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:changeMaxHp(player, -1)
    if player.dead then return end
    local weapons = player:getEquipments(Card.SubtypeWeapon)
    if #weapons > 0 and room:askToSkillInvoke(player, {
      skill_name = zhanshen.name,
      prompt = "#wzzz__zhanshen_awaken-discard",
    }) then
      room:throwCard({ weapons[1] }, zhanshen.name, player, player)
    end
    if player.dead then return end
    room:handleAddLoseSkills(player, "wzzz_v__mashu|wzzz_v__shenji", nil, false, true)
  end,
})

return zhanshen
