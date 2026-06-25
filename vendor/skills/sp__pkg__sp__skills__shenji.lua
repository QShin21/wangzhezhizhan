local wzzz_v__shenji = fk.CreateSkill {
  name = "wzzz_v__shenji",
}

Fk:loadTranslationTable {
  ["wzzz_v__shenji"] = "神戟",
  [":wzzz_v__shenji"] = "若你的装备区里没有武器牌，你使用【杀】可额外选择至多两名角色为目标。",

  ["$wzzz_v__shenji1"] = "杂鱼们，都去死吧！",
  ["$wzzz_v__shenji2"] = "竟想赢我，痴人说梦！",
}

wzzz_v__shenji:addEffect("targetmod", {
  extra_target_func = function(self, player, skill)
    if player:hasSkill(wzzz_v__shenji.name) and skill.trueName == "slash_skill" and
      #player:getEquipments(Card.SubtypeWeapon) == 0 then
      return 2
    end
  end,
})

return wzzz_v__shenji
