local xiongyi = fk.CreateSkill{
  name = "wzzz_v__xh__xiongyi",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__xh__xiongyi"] = "雄异",
  [":wzzz_v__xh__xiongyi"] = "限定技，出牌阶段，你可以与一名其他角色各摸三张牌。若你的体力值为全场唯一最小，你回复1点体力。当你脱离濒死状态后，你复原此技能且删除回复体力的效果。",

  ["#wzzz_v__xh__xiongyi"] = "雄异：选择一名其他角色，你与其各摸三张牌",
  ["$wzzz_v__xh__xiongyi1"] = "弟兄们，我们的机会来啦！",
  ["$wzzz_v__xh__xiongyi2"] = "此时不战，更待何时！",
}

local function isUniqueMinHp(room, me)
  return table.every(room:getOtherPlayers(me, false), function(p)
    return p.hp > me.hp
  end)
end

xiongyi:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#wzzz_v__xh__xiongyi",
  card_num = 0,
  target_num = 1,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player
  end,

  can_use = function(self, player)
    return player.phase == Player.Play and player:usedSkillTimes(xiongyi.name, Player.HistoryGame) == 0
  end,

  on_use = function(self, room, effect)
    local player = effect.from

    local target = effect.tos[1]
    if not player.dead then
      player:drawCards(3, xiongyi.name)
    end
    if not target.dead then
      target:drawCards(3, xiongyi.name)
    end

    if player.dead then return end
    if player:getMark("wzzz_v__xh__xiongyi_noheal") > 0 then return end
    if not player:isWounded() then return end
    if not isUniqueMinHp(room, player) then return end

    room:recover{
      who = player,
      num = 1,
      recoverBy = player,
      skillName = xiongyi.name,
    }
  end,
})

xiongyi:addEffect(fk.AfterDying, {
  can_refresh = function(self, event, target, player, data)
    return target == player and not player.dead and player:usedSkillTimes(xiongyi.name, Player.HistoryGame) > 0
  end,
  on_refresh = function(self, event, target, player, data)
    player:setSkillUseHistory(xiongyi.name, 0, Player.HistoryGame)
    player.room:setPlayerMark(player, "wzzz_v__xh__xiongyi_noheal", 1)
  end,
})

return xiongyi
