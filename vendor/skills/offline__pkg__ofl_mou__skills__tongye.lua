local tongye = fk.CreateSkill {
  name = "wzzz_v__ofl_mou__tongye",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ofl_mou__tongye"] = "统业",
  [":wzzz_v__ofl_mou__tongye"] = "主公技，锁定技，首轮开始时，你获得“英姿”和“固政”；首轮结束时，你失去“英姿”和“固政”。",
}

tongye:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tongye.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local skills = table.filter({"wzzz_v__ex__yingzi", "wzzz_v__guzheng"}, function(s)
      return not player:hasSkill(s, true)
    end)
    if #skills > 0 then
      room:setPlayerMark(player, tongye.name, skills)
      room:handleAddLoseSkills(player, table.concat(skills, "|"), nil, false, true)
    end
  end,
})

tongye:addEffect(fk.RoundEnd, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:getMark(tongye.name) ~= 0
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:handleAddLoseSkills(player, "-"..table.concat(player:getTableMark(tongye.name), "|-"), nil, false, true)
    player.room:setPlayerMark(player, tongye.name, 0)
  end,
})

tongye:addLoseEffect(function(self, player)
  if player:getMark(tongye.name) ~= 0 then
    player.room:handleAddLoseSkills(player, "-"..table.concat(player:getTableMark(tongye.name), "|-"), nil, false, true)
    player.room:setPlayerMark(player, tongye.name, 0)
  end
end)

return tongye
