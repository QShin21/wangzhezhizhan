local wzzz_v__cixiao = fk.CreateSkill {
  name = "wzzz_v__cixiao",
}

Fk:loadTranslationTable{
  ["wzzz_v__cixiao"] = "慈孝",
  [":wzzz_v__cixiao"] = "准备阶段，若场上没有拥有“义子”标记的其他角色，则你可以令一名其他角色获得一个“义子”标记，否则你可以弃置一张牌并将“义子”标记移动给另一名其他角色（当其他角色获得/失去“义子”标记时，其获得/失去“叛弑”）。",

  ["#wzzz_v__cixiao-choose"] = "慈孝：你可以选择一名其他角色成为“义子”",
  ["#wzzz_v__cixiao-discard"] = "慈孝：你可以弃置一张牌，转移“义子”标记",
  ["@@wzzz_v__panshi_son"] = "义子",

  ["$wzzz_v__cixiao1"] = "吾儿奉先，天下无敌！",
  ["$wzzz_v__cixiao2"] = "父慈子孝，义理为先！"
}

wzzz_v__cixiao:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__cixiao.name) and player.phase == Player.Start and
      table.find(player.room.alive_players, function(p)
        return p ~= player and not p:hasSkill("wzzz_v__panshi", true)
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if table.find(room.alive_players, function(p)
      return p:hasSkill("wzzz_v__panshi", true)
    end) then
      local to, cards = room:askToChooseCardsAndPlayers(player, {
        min_card_num = 1,
        max_card_num = 1,
        min_num = 1,
        max_num = 1,
        targets = table.filter(room.alive_players, function(p)
          return p ~= player and not p:hasSkill("wzzz_v__panshi", true)
        end),
        skill_name = wzzz_v__cixiao.name,
        prompt = "#wzzz_v__cixiao-discard",
        cancelable = true,
        will_throw = true,
      })
      if #to > 0 and #cards > 0 then
        event:setCostData(self, { tos = to, cards = cards })
        return true
      end
    else
      local to = room:askToChoosePlayers(player, {
        targets = room:getOtherPlayers(player, false),
        min_num = 1,
        max_num = 1,
        prompt = "#wzzz_v__cixiao-choose",
        skill_name = wzzz_v__cixiao.name,
        cancelable = true,
      })
      if #to > 0 then
        event:setCostData(self, { tos = to })
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cost_data = event:getCostData(self)
    local to = event:getCostData(self).tos[1]
    if cost_data.cards then
      room:throwCard(cost_data.cards, wzzz_v__cixiao.name, player, player)
    end
    for _, p in ipairs(room.alive_players) do
      room:handleAddLoseSkills(p, "-wzzz_v__panshi")
    end
    if not to.dead then
      room:handleAddLoseSkills(to, "wzzz_v__panshi")
    end
  end,
})

return wzzz_v__cixiao
