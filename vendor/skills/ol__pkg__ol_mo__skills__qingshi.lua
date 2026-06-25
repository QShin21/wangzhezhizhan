local qingshi = fk.CreateSkill {
  name = "wzzz_v__qingshic",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__qingshic"] = "倾世",
  [":wzzz_v__qingshic"] = "锁定技，亮将后，你失去“离间”或“离魂”。",
}

qingshi:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(qingshi.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, qingshi.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local choices = {}
    if player:hasSkill("wzzz_v__lijian", true) then table.insert(choices, "wzzz_v__lijian") end
    if player:hasSkill("wzzz_v__lihun", true) then table.insert(choices, "wzzz_v__lihun") end
    if #choices > 0 then
      local skill = player.room:askToChoice(player, {
        choices = choices,
        skill_name = qingshi.name,
      })
      player.room:handleAddLoseSkills(player, "-" .. skill, nil, false, true)
    end
  end,
})

return qingshi
