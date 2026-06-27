local zhuiji = fk.CreateSkill{
  name = "wzzz_v__ol__zhuiji",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ol__zhuiji"] = "追击",
  [":wzzz_v__ol__zhuiji"] = "锁定技，你计算与体力值不大于你的其他角色的距离视为1；体力值大于你的角色不能响应你使用的【杀】。当你使用【杀】指定距离为1的其他角色为目标后，其选择一项：1.弃置一张牌；2.重铸装备区里的所有牌。",

  ["#wzzz_v__ol__zhuiji-discard"] = "追击：弃置一张牌，或点“取消”重铸装备区所有牌",
}

zhuiji:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhuiji.name) and data.card.trueName == "slash" and
      data.to ~= player and player:distanceTo(data.to) == 1 and not data.to.dead and not data.to:isNude()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if data.to.hp > player.hp then
      data.use.disresponsiveList = data.use.disresponsiveList or {}
      table.insertIfNeed(data.use.disresponsiveList, data.to)
    end
    room:doIndicate(player, {data.to})
    local equips = data.to:getCardIds("e")
    local cards = room:askToDiscard(data.to, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = zhuiji.name,
      prompt = "#wzzz_v__ol__zhuiji-discard",
      cancelable = #equips > 0,
    })
    if #cards == 0 and #equips > 0 then
      room:recastCard(equips, data.to)
    end
  end,
})

zhuiji:addEffect(fk.TargetSpecified, {
  mute = true,
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhuiji.name) and data.card.trueName == "slash" and
      data.to ~= player and data.to.hp > player.hp
  end,
  on_refresh = function(self, event, target, player, data)
    data.use.disresponsiveList = data.use.disresponsiveList or {}
    table.insertIfNeed(data.use.disresponsiveList, data.to)
  end,
})
zhuiji:addEffect("distance", {
  fixed_func = function(self, from, to)
    if from:hasSkill(zhuiji.name) and from ~= to and from.hp >= to.hp then
      return 1
    end
  end,
})

return zhuiji
