local duanchang = fk.CreateSkill {
  name = "wzzz_v__duanchang",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__duanchang"] = "断肠",
  [":wzzz_v__duanchang"] = "锁定技，当你死亡时，杀死你的角色失去所有武将技能。",

  ["$wzzz_v__duanchang1"] = "流落异乡愁断肠。",
  ["$wzzz_v__duanchang2"] = "日东月西兮徒相望，不得相随兮空断肠。",
}

duanchang:addEffect(fk.Death, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(duanchang.name, false, true) and
        data.killer and not data.killer.dead
  end,
  on_cost = function(self, event, target, player, data)
    event:setCostData(self, { tos = { data.killer } })
    return true
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local skills = {}
    for _, s in ipairs(data.killer:getSkillNameList()) do
      if not Fk.skill_skels[s].mode_skill then
        table.insert(skills, "-" .. s)
      end
    end
    room:handleAddLoseSkills(data.killer, skills)
  end,
})

return duanchang
