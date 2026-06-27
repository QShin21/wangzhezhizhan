local osExPolu = fk.CreateSkill {
  name = "wzzz_v__os_ex__polu",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable{
  ["wzzz_v__os_ex__polu"] = "破虏",
  [":wzzz_v__os_ex__polu"] = "主公技，当吴势力角色杀死一名角色或死亡后，你可以令至多三名角色各摸Y张牌（Y为你此前发动过此技能的次数+1且至多为3）。",

  ["#wzzz_v__os_ex__polu"] = "破虏：你可选择至多三名角色，令其各摸 %arg 张牌",
  ["@wzzz_v__os_ex__polu"] = "破虏",

  ["$wzzz_v__os_ex__polu1"] = "义定四野，武匡海内。", -- 其实是给英魂的
  ["$wzzz_v__os_ex__polu2"] = "江东男儿，皆胸怀匡扶天下之志。",
}

osExPolu:addEffect(fk.Deathed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return
      player:hasSkill(osExPolu.name) and
      (
        (data.damage and data.damage.from and data.damage.from.kingdom == "wu") or
        target.kingdom == "wu"
      )
  end,
  on_trigger = function(self, event, target, player, data)
    if target.kingdom == "wu" then
      self:doCost(event, target, player, data)
    end
    if data.damage and data.damage.from and data.damage.from.kingdom == "wu" then
      self:doCost(event, target, player, data)
    end
  end,
  on_cost = function(self, event, target, player, data)
    ---@type string
    local skillName = osExPolu.name
    local alivePlayers = player.room:getAlivePlayers(false)
    local targets = player.room:askToChoosePlayers(
      player,
      {
        targets = alivePlayers,
        min_num = 1,
        max_num = math.min(3, #alivePlayers),
        prompt = "#wzzz_v__os_ex__polu:::" .. math.min(3, player:usedSkillTimes(skillName, Player.HistoryGame) + 1),
        skill_name = skillName,
        cancelable = true,
      }
    )
    if #targets > 0 then
      event:setCostData(self, targets)
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local targets = event:getCostData(self)
    local room = player.room
    room:sortByAction(targets)
    room:addPlayerMark(player, "@wzzz_v__os_ex__polu")
    local n = math.min(3, player:usedSkillTimes(osExPolu.name, Player.HistoryGame))
    for _, p in ipairs(targets) do
      if p:isAlive() then
        p:drawCards(n, osExPolu.name)
      end
    end
  end,
})

return osExPolu
