local pingkou = fk.CreateSkill {
  name = "wzzz_v__pingkou",
}

Fk:loadTranslationTable{
  ["wzzz_v__pingkou"] = "平寇",
  [":wzzz_v__pingkou"] = "回合结束时，你可以对至多X名其他角色各造成1点伤害。若你选择的角色数小于X，则你获得其中一名角色装备区里的一张牌。（X为你本回合跳过的阶段数）",

  ["#wzzz_v__pingkou-choose"] = "平寇：你可以对至多%arg名角色各造成1点伤害",

  ["$wzzz_v__pingkou1"] = "对敌人仁慈，就是对自己残忍。",
  ["$wzzz_v__pingkou2"] = "反守为攻，直捣黄龙！",
}

pingkou:addEffect(fk.TurnEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pingkou.name) and
      table.find(data.phase_table, function(phase)
        return phase.who == player and phase.skipped
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local n = #table.filter(data.phase_table, function(phase)
      return phase.who == player and phase.skipped
    end)
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = n,
      targets = room:getOtherPlayers(player, false),
      skill_name = pingkou.name,
      prompt = "#wzzz_v__pingkou-choose:::" .. n,
      cancelable = true,
    })
    if #tos > 0 then
      room:sortByAction(tos)
      event:setCostData(self, {tos = tos, n = n})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local tos = event:getCostData(self).tos
    for _, p in ipairs(tos) do
      if not p.dead then
        room:damage{
          from = player,
          to = p,
          damage = 1,
          skillName = pingkou.name,
        }
      end
    end
    local n = event:getCostData(self).n
    if #tos < n and not player.dead then
      local targets = table.filter(tos, function(p)
        return not p.dead and #p:getCardIds("e") > 0
      end)
      if #targets > 0 then
        local to = room:askToChoosePlayers(player, {
          min_num = 1,
          max_num = 1,
          targets = targets,
          skill_name = pingkou.name,
          prompt = "#wzzz_v__pingkou-choose:::1",
          cancelable = true,
        })
        if #to > 0 then
          local id = room:askToChooseCard(player, {
            target = to[1],
            flag = "e",
            skill_name = pingkou.name,
          })
          room:moveCardTo(id, Card.PlayerHand, player, fk.ReasonPrey, pingkou.name, nil, true, player)
        end
      end
    end
  end,
})

return pingkou
