local yicheng = fk.CreateSkill {
  name = "wzzz_v__v33__yicheng",
}

Fk:loadTranslationTable{
  ["wzzz_v__v33__yicheng"] = "疑城",
  [":wzzz_v__v33__yicheng"] = "与你相邻的角色成为【杀】的目标后，你可以令其摸一张牌，然后弃置一张牌。",

  ["#wzzz_v__v33__yicheng-ask"] = "疑城：是否令 %dest 摸一张牌并弃置一张手牌？",
  ["#wzzz_v__v33__yicheng-discard"] = "疑城：请弃置一张牌",

  ["$wzzz_v__v33__yicheng1"] = "不怕死，就尽管放马过来！",
  ["$wzzz_v__v33__yicheng2"] = "待末将布下疑城，以退曹贼。",
}

local function isAdjacent(player, target)
  return player:getNextAlive() == target or target:getNextAlive() == player
end

yicheng:addEffect(fk.TargetConfirmed, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yicheng.name) and data.card.trueName == "slash" and target ~= player and
      isAdjacent(player, target)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = yicheng.name,
      prompt = "#wzzz_v__v33__yicheng-ask::"..target.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    target:drawCards(1, yicheng.name)
    if not target.dead and not target:isNude() then
      local card = room:askToDiscard(target, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = yicheng.name,
        cancelable = false,
        prompt = "#wzzz_v__v33__yicheng-discard",
      })
    end
  end,
})

return yicheng
