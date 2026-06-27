local dushi = fk.CreateSkill {
  name = "wzzz_v__dushi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__dushi"] = "毒逝",
  [":wzzz_v__dushi"] = "锁定技，当你进入濒死状态时，其他角色不能对你使用【桃】直到此次濒死结算结束。当你脱离濒死状态后或当你死亡时，你失去此技能并令一名其他角色获得之。",

  ["#wzzz_v__dushi-choose"] = "毒逝：令一名其他角色获得“毒逝”",

  ["$wzzz_v__dushi1"] = "孤无病，此药无需服。",
  ["$wzzz_v__dushi2"] = "辟恶之毒，为最毒。",
}

dushi:addEffect(fk.Death, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(dushi.name, false, true)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "-"..dushi.name)
    local targets = table.filter(room.alive_players, function(p)
      return not p:hasSkill(dushi.name, true)
    end)
    if #targets == 0 then return end
    local to = room:askToChoosePlayers(player, {
      targets = targets,
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__dushi-choose",
      skill_name = dushi.name,
      cancelable = false,
    })[1]
    room:handleAddLoseSkills(to, dushi.name)
  end,
})

dushi:addEffect(fk.AfterDying, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and not player.dead and player:hasSkill(dushi.name) and
      #player.room:getOtherPlayers(player, false) > 0
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      return not p:hasSkill(dushi.name, true)
    end)
    room:handleAddLoseSkills(player, "-"..dushi.name)
    if #targets == 0 then return end
    local to = room:askToChoosePlayers(player, {
      targets = targets,
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__dushi-choose",
      skill_name = dushi.name,
      cancelable = false,
    })[1]
    room:handleAddLoseSkills(to, dushi.name)
  end,
})

dushi:addEffect(fk.EnterDying, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(dushi.name)
  end,
  on_refresh = function(self, event, target, player, data)
    player:broadcastSkillInvoke(dushi.name)
    player.room:notifySkillInvoked(player, dushi.name)
  end
})

dushi:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    if card.name == "peach" and not player.dying then
      return table.find(Fk:currentRoom().alive_players, function(p)
        return p.dying and p:hasSkill(dushi.name) and p ~= player
      end)
    end
  end,
})

return dushi
