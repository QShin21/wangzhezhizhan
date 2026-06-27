local qinqing = fk.CreateSkill {
  name = "wzzz_v__ty__qinqing",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__qinqing"] = "寝情",
  [":wzzz_v__ty__qinqing"] = "结束阶段，你可以弃置至多X名攻击范围内包含一号位的角色的各一张牌（X为场上存活角色最多阵营的角色数）；然后若其手牌数：小于一号位，其摸一张牌；大于一号位，你摸一张牌。",

  ["#wzzz_v__ty__qinqing-choose"] = "寝情：选择至多%arg名攻击范围内包含 %dest 的角色，各弃置一张牌",

  ["$wzzz_v__ty__qinqing1"] = "陛下今日不理朝政，退下吧！",
  ["$wzzz_v__ty__qinqing2"] = "此事咱家自会传达陛下。",
}

local function qinqingNum(room)
  local kingdoms = {}
  local n = 0
  for _, p in ipairs(room.alive_players) do
    kingdoms[p.kingdom] = (kingdoms[p.kingdom] or 0) + 1
    n = math.max(n, kingdoms[p.kingdom])
  end
  return n
end

local function qinqingTargets(room)
  local seat1 = room:getPlayerBySeat(1)
  return table.filter(room.alive_players, function(p)
    return p:inMyAttackRange(seat1) and not p:isNude()
  end)
end

qinqing:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(qinqing.name) and player.phase == Player.Finish and
      #qinqingTargets(player.room) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = qinqingTargets(room)
    local n = math.min(qinqingNum(room), #targets)
    local tos = room:askToChoosePlayers(player, {
      targets = targets,
      min_num = 1,
      max_num = n,
      prompt = "#wzzz_v__ty__qinqing-choose::"..room:getPlayerBySeat(1).id..":"..n,
      skill_name = qinqing.name,
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local seat1 = room:getPlayerBySeat(1)
    for _, to in ipairs(event:getCostData(self).tos) do
      if player.dead then return end
      if not to.dead and not to:isNude() then
        local id = room:askToChooseCard(player, {
          target = to,
          flag = "he",
          skill_name = qinqing.name,
        })
        room:throwCard(id, qinqing.name, to, player)
        if player.dead or to.dead then return end
        if to:getHandcardNum() < seat1:getHandcardNum() then
          to:drawCards(1, qinqing.name)
        elseif to:getHandcardNum() > seat1:getHandcardNum() then
          player:drawCards(1, qinqing.name)
        end
      end
    end
  end,
})

return qinqing
