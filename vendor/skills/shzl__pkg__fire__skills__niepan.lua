local niepan = fk.CreateSkill {
  name = "wzzz_v__niepan",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__niepan"] = "涅槃",
  [":wzzz_v__niepan"] = "限定技，当你处于濒死状态时，你可以弃置区域里的所有牌，然后复原你的武将牌，摸三张牌，将体力回复至3点，然后你获得“八阵”“火计”“看破”中的一个。",
  ["#wzzz_v__niepan-choice"] = "涅槃：选择获得一个技能",

  ["$wzzz_v__niepan1"] = "凤雏岂能消亡？",
  ["$wzzz_v__niepan2"] = "浴火重生！",
}

niepan:addEffect(fk.AskForPeaches, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(niepan.name) and player.dying and
      player:usedSkillTimes(niepan.name, Player.HistoryGame) == 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:throwAllCards("hej")
    if player.dead then return end
    player:reset()
    if player.dead then return end
    player:drawCards(3, niepan.name)
    if player.dead or player.hp > 2 then return end
    room:recover{
      who = player,
      num = math.min(3, player.maxHp) - player.hp,
      recoverBy = player,
      skillName = niepan.name,
    }
    if player.dead then return end
    local choice = room:askToChoice(player, {
      choices = {"wzzz_v__pangtong__bazhen", "wzzz_v__pangtong__huoji", "wzzz_v__pangtong__kanpo"},
      skill_name = niepan.name,
      prompt = "#wzzz_v__niepan-choice",
    })
    room:handleAddLoseSkills(player, choice, nil, false, true)
  end,
})

return niepan
