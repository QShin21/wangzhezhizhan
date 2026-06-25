local tianming = fk.CreateSkill {
  name = "wzzz_v__tianming",
}

Fk:loadTranslationTable {
  ["wzzz_v__tianming"] = "天命",
  [":wzzz_v__tianming"] = "当你成为【杀】的目标后，你可以弃置两张牌并摸两张牌（不足则全弃，无牌则不弃），然后你可以令全场除你以外体力值唯一最大的角色也如此做。",

  ["#wzzz_v__tianming-invoke"] = "天命：你可以弃置两张牌（不足则全弃，无牌则不弃），然后摸两张牌",
  ["#wzzz_v__tianming-target"] = "天命：是否令 %src 也弃置两张牌并摸两张牌？",
  ["#wzzz_v__tianming-discard"] = "天命：请弃置两张牌，然后摸两张牌",

  ["$wzzz_v__tianming1"] = "皇汉国祚，千年不息！",
  ["$wzzz_v__tianming2"] = "朕乃大汉皇帝，天命之子！",
}

local function getUniqueOtherMaxHp(room, player)
  local others = table.filter(room.alive_players, function(p)
    return p ~= player
  end)
  if #others == 0 then return end
  local maxHp = others[1].hp
  for _, p in ipairs(others) do
    maxHp = math.max(maxHp, p.hp)
  end
  local targets = table.filter(others, function(p)
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
      skill_name = tianming.name,
      cancelable = false,
      prompt = "#wzzz_v__tianming-discard",
    })
    if #cards < 2 then return end
  elseif #ids > 0 then
    room:throwCard(ids, tianming.name, player, player)
  end
  if not player.dead then
    player:drawCards(2, tianming.name)
  end
end

tianming:addEffect(fk.TargetConfirmed, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(tianming.name) and data.card.trueName == "slash"
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local ids = table.filter(player:getCardIds("he"), function(id)
      return not player:prohibitDiscard(id)
    end)
    if #ids <= 2 then
      if room:askToSkillInvoke(player, {
        skill_name = tianming.name,
        prompt = "#wzzz_v__tianming-invoke"
      }) then
        event:setCostData(self, {cards = ids})
        return true
      end
    else
      local cards = room:askToDiscard(player, {
        min_num = 2,
        max_num = 2,
        include_equip = true,
        skill_name = tianming.name,
        cancelable = true,
        prompt = "#wzzz_v__tianming-invoke",
        skip = true,
      })
      if #cards > 0 then
        event:setCostData(self, {cards = cards})
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if #event:getCostData(self).cards > 0 then
      room:throwCard(event:getCostData(self).cards, tianming.name, player, player)
    end
    if not player.dead then
      player:drawCards(2, tianming.name)
    end
    if player.dead then return end
    local to = getUniqueOtherMaxHp(room, player)
    if not to then return end
    if room:askToSkillInvoke(player, {
        skill_name = tianming.name,
        prompt = "#wzzz_v__tianming-target:" .. to.id,
      }) then
      room:doIndicate(player.id, { to.id })
      doTianming(room, to)
    end
  end,
})

return tianming
