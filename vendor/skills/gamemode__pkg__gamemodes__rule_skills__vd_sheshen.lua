local sheshen = fk.CreateSkill {
  name = "wzzz_v__vd_sheshen",
}

Fk:loadTranslationTable {
  ["wzzz_v__vd_sheshen"] = "舍身",
  [":wzzz_v__vd_sheshen"] = "出牌阶段限一次，你可以弃置一名角色区域里的一张牌，然后失去1点体力，若弃置的牌为一名角色判定区里的牌，你失去“舍身”。",
  ["#wzzz_v__vd_sheshen"] = "舍身：弃置一名角色区域里的一张牌，然后失去1点体力",
}

sheshen:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__vd_sheshen",
  card_num = 0,
  target_num = 1,
  card_filter = Util.FalseFunc,
  can_use = function(self, player)
    return player:usedSkillTimes(sheshen.name, Player.HistoryPhase) == 0
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and (not to_select:isNude() or #to_select:getCardIds("j") > 0)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    if not target or target.dead then return end
    local card = room:askToChooseCard(player, {
      target = target,
      flag = "hej",
      skill_name = sheshen.name,
    })
    if not card then return end
    local from_judge = table.contains(target:getCardIds("j"), card)
    room:throwCard({ card }, sheshen.name, target, player)
    if not player.dead then
      room:loseHp(player, 1, sheshen.name)
    end
    if from_judge and not player.dead then
      room:handleAddLoseSkills(player, "-" .. sheshen.name, nil, false, true)
    end
  end,
})

return sheshen
