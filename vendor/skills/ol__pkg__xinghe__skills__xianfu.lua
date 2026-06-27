local wzzz_v__xianfu = fk.CreateSkill{
  name = "wzzz_v__xianfu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__xianfu"] = "先辅",
  [":wzzz_v__xianfu"] = "锁定技，游戏开始时，你声明一名其他角色获得“先辅”标记，当其受到伤害后，你受到等量的无来源普通伤害；当其回复体力后，你回复等量的体力。",

  ["@wzzz_v__xianfu"] = "先辅",
  ["#wzzz_v__xianfu-choose"] = "先辅：请选择要先辅的角色",

  ["$wzzz_v__xianfu1"] = "辅佐明君，从一而终。",
  ["$wzzz_v__xianfu2"] = "吾于此生，竭尽所能。",
  ["$wzzz_v__xianfu3"] = "春蚕至死，蜡炬成灰！",
  ["$wzzz_v__xianfu4"] = "愿为主公，尽我所能。",
  ["$wzzz_v__xianfu5"] = "赠人玫瑰，手有余香。",
  ["$wzzz_v__xianfu6"] = "主公之幸，我之幸也。",
}

local updateXianfu = function (room, player, target)
  local mark = player:getTableMark("wzzz_v__xianfu")
  table.insertIfNeed(mark[2], target.id)
  room:setPlayerMark(player, "wzzz_v__xianfu", mark)
  local names = table.map(mark[2], function(pid) return Fk:translate(room:getPlayerById(pid).general) end)
  room:setPlayerMark(player, "@wzzz_v__xianfu", table.concat(names, ","))
end

wzzz_v__xianfu:addEffect(fk.GameStart, {
  audio_index = {1, 2},
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(wzzz_v__xianfu.name) and #player.room:getOtherPlayers(player, false) > 0 and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, wzzz_v__xianfu.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function (self, event, target, player, data)
    local room = player.room
    room:notifySkillInvoked(player, wzzz_v__xianfu.name)
    player:broadcastSkillInvoke(wzzz_v__xianfu.name, math.random(2))
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room:getOtherPlayers(player, false),
      skill_name = wzzz_v__xianfu.name,
      prompt = "#wzzz_v__xianfu-choose",
      cancelable = false,
      no_indicate = true,
    })[1]
    local mark = player:getTableMark(wzzz_v__xianfu.name)
    if #mark == 0 then mark = {{},{}} end
    table.insertIfNeed(mark[1], to.id)
    room:setPlayerMark(player, wzzz_v__xianfu.name, mark)
  end,
})
wzzz_v__xianfu:addEffect(fk.Damaged, {
  is_delay_effect = true,
  audio_index = {3, 4},
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    local mark = player:getTableMark(wzzz_v__xianfu.name)
    return not player.dead and not target.dead and #mark > 0 and table.contains(mark[1], target.id)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    updateXianfu (room, player, target)
    room:damage{
      to = player,
      damage = data.damage,
      skillName = wzzz_v__xianfu.name,
    }
  end,
})
wzzz_v__xianfu:addEffect(fk.HpRecover, {
  is_delay_effect = true,
  anim_type = "support",
  audio_index = {5, 6},
  can_trigger = function(self, event, target, player, data)
    local mark = player:getTableMark(wzzz_v__xianfu.name)
    return not player.dead and not target.dead and #mark > 0 and table.contains(mark[1], target.id) and player:isWounded()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    updateXianfu (room, player, target)
    room:recover{
      who = player,
      num = data.num,
      recoverBy = player,
      skillName = wzzz_v__xianfu.name,
    }
  end,
})

return wzzz_v__xianfu
