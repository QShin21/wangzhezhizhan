local liuxieTianming = fk.CreateSkill {
  name = "wzzz_v__liuxie__tianming",
}

Fk:loadTranslationTable {
  ["wzzz_v__liuxie__tianming"] = "天命",
  [":wzzz_v__liuxie__tianming"] = "当你成为【杀】的目标后，你可以弃置两张牌并摸两张牌（不足则全弃，无牌则不弃），然后若全场体力值唯一最大的角色不为你，其也可以如此做。",

  ["#wzzz_v__liuxie__tianming-invoke"] = "天命：你可以弃置两张牌（不足则全弃，无牌则不弃），然后摸两张牌",
  ["#wzzz_v__liuxie__tianming-other"] = "天命：你也可以弃置两张牌（不足则全弃，无牌则不弃），然后摸两张牌",
  ["#wzzz_v__liuxie__tianming-discard"] = "天命：请弃置两张牌，然后摸两张牌",
}

local function getUniqueMaxHp(room)
  if #room.alive_players == 0 then return end
  local maxHp = room.alive_players[1].hp
  for _, p in ipairs(room.alive_players) do
    maxHp = math.max(maxHp, p.hp)
  end
  local targets = table.filter(room.alive_players, function(p)
    return p.hp == maxHp
  end)
  return #targets == 1 and targets[1] or nil
end

local function doTianming(room, player)
  local ids = table.filter(player:getCardIds("he"), function(id)
    return not player:prohibitDiscard(id)
  end)
  if #ids > 2 then
    local cards = room:askToDiscard(player, {
      min_num = 2,
      max_num = 2,
      include_equip = true,
      skill_name = liuxieTianming.name,
      cancelable = false,
      prompt = "#wzzz_v__liuxie__tianming-discard",
    })
    if #cards < 2 then return end
  elseif #ids > 0 then
    room:throwCard(ids, liuxieTianming.name, player, player)
  end
  if not player.dead then
    player:drawCards(2, liuxieTianming.name)
  end
end

liuxieTianming:addEffect(fk.TargetConfirmed, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(liuxieTianming.name) and data.card.trueName == "slash"
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local ids = table.filter(player:getCardIds("he"), function(id)
      return not player:prohibitDiscard(id)
    end)
    if #ids <= 2 then
      if room:askToSkillInvoke(player, {
        skill_name = liuxieTianming.name,
        prompt = "#wzzz_v__liuxie__tianming-invoke",
      }) then
        event:setCostData(self, { cards = ids })
        return true
      end
    else
      local cards = room:askToDiscard(player, {
        min_num = 2,
        max_num = 2,
        include_equip = true,
        skill_name = liuxieTianming.name,
        cancelable = true,
        prompt = "#wzzz_v__liuxie__tianming-invoke",
        skip = true,
      })
      if #cards > 0 then
        event:setCostData(self, { cards = cards })
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if #event:getCostData(self).cards > 0 then
      room:throwCard(event:getCostData(self).cards, liuxieTianming.name, player, player)
    end
    if not player.dead then
      player:drawCards(2, liuxieTianming.name)
    end
    if player.dead then return end

    local to = getUniqueMaxHp(room)
    if not to or to == player then return end
    if room:askToSkillInvoke(to, {
      skill_name = liuxieTianming.name,
      prompt = "#wzzz_v__liuxie__tianming-other",
    }) then
      room:doIndicate(player.id, { to.id })
      doTianming(room, to)
    end
  end,
})

return liuxieTianming
