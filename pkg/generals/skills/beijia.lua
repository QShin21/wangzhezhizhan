local beijia = fk.CreateSkill {
  name = "wzzz__beijia",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz__beijia"] = "悲笳",
  [":wzzz__beijia"] = "锁定技，亮将后，你失去“陈情”或“断肠”。",
}

beijia:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(beijia.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, beijia.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local choices = {}
    if player:hasSkill("wzzz_v__chenqing", true) then table.insert(choices, "wzzz_v__chenqing") end
    if player:hasSkill("wzzz_v__duanchang", true) then table.insert(choices, "wzzz_v__duanchang") end
    if #choices > 0 then
      player.room:handleAddLoseSkills(player, "-" .. player.room:askToChoice(player, { choices = choices, skill_name = beijia.name }), nil, false, true)
    end
  end,
})

return beijia
