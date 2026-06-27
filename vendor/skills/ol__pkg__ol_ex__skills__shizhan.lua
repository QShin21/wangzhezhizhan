local shizhan = fk.CreateSkill{
  name = "wzzz_v__shizhan"
}

Fk:loadTranslationTable{
  ["wzzz_v__shizhan"] = "势斩",
  [":wzzz_v__shizhan"] = "出牌阶段限两次，你可以选择一名本回合未被此技能选择过的其他角色，其视为对你使用一张【决斗】。",

  ["#wzzz_v__shizhan"] = "势斩：令一名本回合未被选择过的其他角色视为对你使用【决斗】",

  ["$wzzz_v__shizhan1"] = "看你能坚持几个回合！",
  ["$wzzz_v__shizhan2"] = "兀那汉子，且报上名来！",
}

shizhan:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__shizhan",
  times = function (self, player)
    return player.phase == Player.Play and 2 - player:usedSkillTimes(shizhan.name, Player.HistoryPhase) or -1
  end,
  can_use = function(self, player)
    return player:usedSkillTimes(shizhan.name, Player.HistoryPhase) < 2
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and to_select:getMark("wzzz_v__shizhan_target-turn") == 0 and
      not to_select:isProhibited(player, Fk:cloneCard("duel"))
  end,
  target_num = 1,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:setPlayerMark(target, "wzzz_v__shizhan_target-turn", 1)
    room:useVirtualCard("duel", nil, target, player, shizhan.name, true)
  end,
})

return shizhan
