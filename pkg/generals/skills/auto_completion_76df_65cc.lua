local skill_76df_65cc = fk.CreateSkill {
  name = "wzzz_s__76df_65cc",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable {
  ["wzzz_s__76df_65cc"] = "盟旌",
  [":" .. "wzzz_s__76df_65cc"] = "主公技，其他群势力角色杀死一名角色后，其可以回复1点体力或摸Y张牌（Y为死亡角色所在阵营的存活角色数且至多为2）。",
  ["wzzz_s__76df_65cc_recover"] = "回复1点体力",
  ["wzzz_s__76df_65cc_draw"] = "摸牌",
}

local function sameCamp(role1, role2)
  if table.contains({ "lord", "loyalist" }, role1) then
    return table.contains({ "lord", "loyalist" }, role2)
  end
  if table.contains({ "rebel", "rebel_chief" }, role1) then
    return table.contains({ "rebel", "rebel_chief" }, role2)
  end
  return role1 == role2
end

local function aliveCampCount(room, victim)
  return #table.filter(room.alive_players, function(p)
    return sameCamp(p.role, victim.role)
  end)
end

skill_76df_65cc:addEffect(fk.Death, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(skill_76df_65cc.name) and data.killer and data.killer ~= player and
      data.killer.kingdom == "qun" and not data.killer.dead
  end,
  on_cost = function(self, event, target, player, data)
    local choices = { "wzzz_s__76df_65cc_draw", "Cancel" }
    if data.killer:isWounded() then table.insert(choices, 1, "wzzz_s__76df_65cc_recover") end
    local choice = player.room:askToChoice(data.killer, { choices = choices, skill_name = skill_76df_65cc.name })
    if choice ~= "Cancel" then
      event:setCostData(self, { choice = choice, tos = { data.killer } })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local killer = event:getCostData(self).tos[1]
    local choice = event:getCostData(self).choice
    if choice == "wzzz_s__76df_65cc_recover" then
      room:recover {
        who = killer,
        num = 1,
        recoverBy = killer,
        skillName = skill_76df_65cc.name,
      }
    else
      killer:drawCards(math.min(2, aliveCampCount(room, target)), skill_76df_65cc.name)
    end
  end,
})

skill_76df_65cc:addTest(function(room, me)
  lu.assertTrue(sameCamp("lord", "loyalist"))
  lu.assertTrue(sameCamp("rebel", "rebel_chief"))
  lu.assertFalse(sameCamp("lord", "rebel"))

  local fake_room = {
    alive_players = {
      { role = "lord" },
      { role = "rebel" },
      { role = "rebel" },
      { role = "rebel_chief" },
    },
  }
  lu.assertEquals(aliveCampCount(fake_room, { role = "loyalist" }), 1)
  lu.assertEquals(math.min(2, aliveCampCount(fake_room, { role = "rebel" })), 2)
  lu.assertEquals(aliveCampCount(fake_room, { role = "renegade" }), 0)
end)

return skill_76df_65cc
