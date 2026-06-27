local qizhi = fk.CreateSkill {
  name = "wzzz_v__qizhi",
}

Fk:loadTranslationTable{
  ["wzzz_v__qizhi"] = "奇制",
  [":wzzz_v__qizhi"] = "当你于回合内使用牌指定目标后，你可以弃置不是此牌目标的一名角色一张牌，然后该角色摸一张牌。",
  ["@wzzz_v__qizhi-turn"] = "奇制",
  ["#wzzz_v__qizhi-choose"] = "奇制：你可以弃置一名角色一张牌，然后其摸一张牌",

  ["$wzzz_v__qizhi1"] = "声东击西，敌寇一网成擒。",
  ["$wzzz_v__qizhi2"] = "吾意不在此地，已遣别部出发。",
}

qizhi:addEffect(fk.TargetSpecified, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(qizhi.name) and player.room.current == player and
      data.firstTarget and
      table.find(player.room.alive_players, function (p)
        return not p:isNude()
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room.alive_players, function(p)
      return not p:isNude() and not table.contains(data.use.tos, p)
    end)
    if table.contains(targets, player) and
      not table.find(player:getCardIds("he"), function (id)
        return not player:prohibitDiscard(id)
      end) then
      table.removeOne(targets, player)
    end
    if #targets == 0 then
      room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = false,
        skill_name = qizhi.name,
        pattern = "false",
        prompt = "#wzzz_v__qizhi-choose",
        cancelable = true,
      })
    else
      local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = qizhi.name,
        prompt = "#wzzz_v__qizhi-choose",
        cancelable = true,
      })
      if #to > 0 then
        event:setCostData(self, {tos = to})
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addPlayerMark(player, "@wzzz_v__qizhi-turn", 1)
    local to = event:getCostData(self).tos[1]
    if to == player then
      room:askToDiscard(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = qizhi.name,
        cancelable = false,
      })
    else
      local id = room:askToChooseCard(player, {
        target = to,
        flag = "he",
        skill_name = qizhi.name,
      })
      room:throwCard(id, qizhi.name, to, player)
    end
    if not to.dead then
      to:drawCards(1, qizhi.name)
    end
  end,
})

return qizhi
