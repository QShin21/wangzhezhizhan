local shouyue = fk.CreateSkill {
  name = "wzzz__shouyue",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable {
  ["wzzz__shouyue"] = "授钺",
  [":wzzz__shouyue"] = "主公技，出牌阶段结束时，你可以令一名体力值不小于你的其他蜀势力角色选择一项：1.跳过下一个出牌阶段；2.视为对其攻击范围内你指定的一名角色使用一张【杀】。",
  ["#wzzz__shouyue-choose"] = "授钺：选择一名体力值不小于你的蜀势力角色",
  ["#wzzz__shouyue-target"] = "授钺：选择【杀】的目标，或取消并跳过下个出牌阶段",
  ["@@wzzz__shouyue_skip"] = "授钺",
}

shouyue:addEffect(fk.EventPhaseEnd, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(shouyue.name) and player.phase == Player.Play and
      table.find(player.room:getOtherPlayers(player, false), function(p) return p.kingdom == "shu" and p.hp >= player.hp end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
      targets = table.filter(room:getOtherPlayers(player, false), function(p) return p.kingdom == "shu" and p.hp >= player.hp end),
      min_num = 1, max_num = 1, prompt = "#wzzz__shouyue-choose", skill_name = shouyue.name, cancelable = true,
    })
    if #tos > 0 then event:setCostData(self, { tos = tos }); return true end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local ally = event:getCostData(self).tos[1]
    local slash = Fk:cloneCard("slash")
    local targets = table.filter(room:getOtherPlayers(ally, false), function(p) return ally:canUseTo(slash, p) end)
    local tos = room:askToChoosePlayers(player, {
      targets = targets, min_num = 1, max_num = 1, prompt = "#wzzz__shouyue-target", skill_name = shouyue.name, cancelable = true,
    })
    if #tos == 0 then
      room:setPlayerMark(ally, "@@wzzz__shouyue_skip", 1)
    else
      room:useVirtualCard("slash", nil, ally, tos[1], shouyue.name, true)
    end
  end,
})

shouyue:addEffect(fk.EventPhaseChanging, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target:getMark("@@wzzz__shouyue_skip") > 0 and data.phase == Player.Play
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(target, "@@wzzz__shouyue_skip", 0)
    data.skipped = true
  end,
})

return shouyue
