local wzzz_v__shenji = fk.CreateSkill {
  name = "wzzz_v__shenji",
}

Fk:loadTranslationTable {
  ["wzzz_v__shenji"] = "神戟",
  [":wzzz_v__shenji"] = "你使用【杀】的次数上限+1，额定目标数上限+2。",

  ["$wzzz_v__shenji1"] = "杂鱼们，都去死吧！",
  ["$wzzz_v__shenji2"] = "竟想赢我，痴人说梦！",
}

wzzz_v__shenji:addEffect("targetmod", {
  residue_func = function(self, player, skill, scope)
    if player:hasSkill(wzzz_v__shenji.name) and skill.trueName == "slash_skill" and scope == Player.HistoryPhase then
      return 1
    end
  end,
  extra_target_func = function(self, player, skill)
    if player:hasSkill(wzzz_v__shenji.name) and skill.trueName == "slash_skill" then
      return 2
    end
  end,
})

return wzzz_v__shenji
