local gongao = fk.CreateSkill {
  name = "wzzz_v__ty_ex__gongao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__gongao"] = "功獒",
  [":wzzz_v__ty_ex__gongao"] = "锁定技，每名角色限一次，当一名其他角色第一次进入濒死状态时，你加1点体力上限并回复1点体力。你觉醒后，此技能改为当其他角色死亡后发动。",

  ["$wzzz_v__ty_ex__gongao1"] = "百战余生者，唯我大魏虎贲。",
  ["$wzzz_v__ty_ex__gongao2"] = "大魏凭武立国，当以骨血为饲。",
}

gongao:addEffect(fk.EnterDying, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(gongao.name) and target ~= player and
      player:usedSkillTimes("wzzz_v__ty_ex__juyi", Player.HistoryGame) == 0 and
      not table.contains(player:getTableMark(gongao.name), target.id) then
      local dying_events =  player.room.logic:getEventsOfScope(GameEvent.Dying, 1, function (e)
        return e.data.who == target
      end, Player.HistoryGame)
      return #dying_events == 1 and dying_events[1].data == data
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addTableMark(player, gongao.name, target.id)
    room:changeMaxHp(player, 1)
    if not player.dead and player:isWounded() then
      room:recover{
        num = 1,
        who = player,
        recoverBy = player,
        skillName = gongao.name,
      }
    end
  end,
})

gongao:addEffect(fk.Death, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(gongao.name) and target ~= player and
      player:usedSkillTimes("wzzz_v__ty_ex__juyi", Player.HistoryGame) > 0 and
      not table.contains(player:getTableMark(gongao.name), target.id)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:addTableMark(player, gongao.name, target.id)
    room:changeMaxHp(player, 1)
    if not player.dead and player:isWounded() then
      room:recover{
        num = 1,
        who = player,
        recoverBy = player,
        skillName = gongao.name,
      }
    end
  end,
})

return gongao
