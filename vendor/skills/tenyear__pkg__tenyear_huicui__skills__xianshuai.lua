local wzzz_v__xianshuai = fk.CreateSkill {
  name = "wzzz_v__xianshuai",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__xianshuai"] = "先率",
  [":wzzz_v__xianshuai"] = "锁定技，一名角色造成伤害后，若此伤害是本轮第一次造成伤害，你摸一张牌；若伤害来源为你，你对受到伤害的角色造成1点伤害。",

  ["$wzzz_v__xianshuai1"] = "九州齐喑，首义瞩吾！",
  ["$wzzz_v__xianshuai2"] = "雄兵一击，则天下大白！",
}

wzzz_v__xianshuai:addEffect(fk.Damage, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(wzzz_v__xianshuai.name) and target and player:usedSkillTimes(wzzz_v__xianshuai.name, Player.HistoryRound) == 0 then
      local damage_event = player.room.logic:getActualDamageEvents(1, Util.TrueFunc, Player.HistoryRound)
      return #damage_event == 1 and damage_event[1].data == data
    end
  end,
  on_cost = function (self, event, target, player, data)
    if target == player and not data.to.dead then
      event:setCostData(self, {tos = {data.to}})
    else
      event:setCostData(self, nil)
    end
    return true
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, wzzz_v__xianshuai.name)
    if target == player and not data.to.dead then
      player.room:damage{
        from = player,
        to = data.to,
        damage = 1,
        skillName = wzzz_v__xianshuai.name,
      }
    end
  end,
})

return wzzz_v__xianshuai
