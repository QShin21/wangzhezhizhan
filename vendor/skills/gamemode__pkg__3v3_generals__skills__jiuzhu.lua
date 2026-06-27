local jiuzhu = fk.CreateSkill {
  name = "wzzz_v__jiuzhu",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__jiuzhu"] = "救主",
  [":wzzz_v__jiuzhu"] = "限定技，当一名其他角色进入濒死状态时，你可以失去“冲阵”并选择一项：1.令其回复1点体力，你获得“涯角”；2.令一名角色摸三张牌。",

  ["#wzzz_v__jiuzhu-choice"] = "救主：失去“冲阵”，选择令 %dest 回复并获得“涯角”，或令一名角色摸三张牌",
  ["#wzzz_v__jiuzhu-draw"] = "救主：令一名角色摸三张牌",
  ["wzzz_v__jiuzhu_recover"] = "令濒死角色回复1点体力，获得“涯角”",
  ["wzzz_v__jiuzhu_draw"] = "令一名角色摸三张牌",
}

jiuzhu:addEffect(fk.EnterDying, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(jiuzhu.name) and
      player:hasSkill("wzzz_v__chongzhen", true) and
      player:usedSkillTimes(jiuzhu.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choice = room:askToChoice(player, {
      choices = { "wzzz_v__jiuzhu_recover", "wzzz_v__jiuzhu_draw", "Cancel" },
      skill_name = jiuzhu.name,
      prompt = "#wzzz_v__jiuzhu-choice::"..target.id,
    })
    if choice == "wzzz_v__jiuzhu_recover" then
      event:setCostData(self, {tos = {target}, choice = choice})
      return true
    elseif choice == "wzzz_v__jiuzhu_draw" then
      local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room.alive_players,
        skill_name = jiuzhu.name,
        prompt = "#wzzz_v__jiuzhu-draw",
        cancelable = false,
      })
      event:setCostData(self, {tos = tos, choice = choice})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:handleAddLoseSkills(player, "-wzzz_v__chongzhen", nil, false, true)
    if player.dead then return end
    if event:getCostData(self).choice == "wzzz_v__jiuzhu_recover" then
      if not target.dead and target:isWounded() then
        room:recover{
          who = target,
          num = 1,
          recoverBy = player,
          skillName = jiuzhu.name,
        }
      end
      if not player.dead then
        room:handleAddLoseSkills(player, "wzzz_v__yajiao", nil, false, true)
      end
    else
      local to = event:getCostData(self).tos[1]
      if to and not to.dead then
        to:drawCards(3, jiuzhu.name)
      end
    end
  end,
})

return jiuzhu
