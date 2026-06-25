local skill_96c4_4e89 = fk.CreateSkill {
  name = "wzzz_s__96c4_4e89"
}

Fk:loadTranslationTable {
  ["wzzz_s__96c4_4e89"] = "雄争",
  [":" .. "wzzz_s__96c4_4e89"] = "每轮开始时，你可以选择一名未被此技能选择过的角色。若如此做，本轮结束时，你可以选择一项：1.视为对除其以外任意名本轮未对其造成过伤害的角色各使用一张【杀】；2.令任意名本轮对其造成过伤害的角色各摸两张牌。",
  ["@wzzz_s__96c4_4e89-round"] = "雄争",
  ["#wzzz_s__96c4_4e89-choose"] = "雄争：选择一名未被你以此法选择过的角色",
  ["wzzz_s__96c4_4e89_slash"] = "视为使用【杀】",
  ["wzzz_s__96c4_4e89_draw"] = "令伤害来源摸牌",
  ["#wzzz_s__96c4_4e89-slash"] = "雄争：选择未对“雄争”角色造成过伤害的角色，视为对其使用【杀】",
  ["#wzzz_s__96c4_4e89-draw"] = "雄争：选择本轮对“雄争”角色造成过伤害的角色，其各摸两张牌",
}

local TARGET_MARK = "@wzzz_s__96c4_4e89-round"
local CHOSEN_MARK = "wzzz_s__96c4_4e89_chosen"
local DAMAGER_MARK = "wzzz_s__96c4_4e89_damagers-round"

skill_96c4_4e89:addEffect(fk.RoundStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(skill_96c4_4e89.name) and
      table.find(player.room.alive_players, function(p)
        return p ~= player and not table.contains(player:getTableMark(CHOSEN_MARK), p.id)
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local tos = player.room:askToChoosePlayers(player, {
      targets = table.filter(player.room.alive_players, function(p)
        return p ~= player and not table.contains(player:getTableMark(CHOSEN_MARK), p.id)
      end),
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_s__96c4_4e89-choose",
      skill_name = skill_96c4_4e89.name,
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, { tos = tos })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:setPlayerMark(player, TARGET_MARK, to.id)
    room:setPlayerMark(player, DAMAGER_MARK, 0)
    room:addTableMarkIfNeed(player, CHOSEN_MARK, to.id)
  end,
})

skill_96c4_4e89:addEffect(fk.Damage, {
  mute = true,
  can_refresh = function(self, event, target, player, data)
    return data.from and data.to
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    for _, owner in ipairs(room.alive_players) do
      if owner:hasSkill(skill_96c4_4e89.name, true) and owner:getMark(TARGET_MARK) == data.to.id then
        room:addTableMarkIfNeed(owner, DAMAGER_MARK, data.from.id)
      end
    end
  end,
})

skill_96c4_4e89:addEffect(fk.RoundEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    local id = player:getMark(TARGET_MARK)
    return player:hasSkill(skill_96c4_4e89.name) and type(id) == "number" and id > 0 and
      not player.room:getPlayerById(id).dead
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local damagers = player:getTableMark(DAMAGER_MARK)
    local targetPlayer = room:getPlayerById(player:getMark(TARGET_MARK))
    local slashTargets = table.filter(room.alive_players, function(p)
      return p ~= player and p ~= targetPlayer and not table.contains(damagers, p.id)
    end)
    local choices = {}
    if #slashTargets > 0 then table.insert(choices, "wzzz_s__96c4_4e89_slash") end
    if #damagers > 0 then table.insert(choices, "wzzz_s__96c4_4e89_draw") end
    table.insert(choices, "Cancel")
    local choice = room:askToChoice(player, { choices = choices, skill_name = skill_96c4_4e89.name })
    if choice ~= "Cancel" then
      event:setCostData(self, { choice = choice })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choice = event:getCostData(self).choice
    local damagers = player:getTableMark(DAMAGER_MARK)
    local targetPlayer = room:getPlayerById(player:getMark(TARGET_MARK))
    if choice == "wzzz_s__96c4_4e89_draw" then
      local tos = table.map(table.filter(damagers, function(id)
        return not room:getPlayerById(id).dead
      end), function(id) return room:getPlayerById(id) end)
      if #tos == 0 then return end
      tos = room:askToChoosePlayers(player, {
        targets = tos,
        min_num = 1,
        max_num = #tos,
        prompt = "#wzzz_s__96c4_4e89-draw",
        skill_name = skill_96c4_4e89.name,
        cancelable = true,
      })
      for _, p in ipairs(tos) do
        if not p.dead then p:drawCards(2, skill_96c4_4e89.name) end
      end
    else
      local tos = table.filter(room.alive_players, function(p)
        return p ~= player and p ~= targetPlayer and not table.contains(damagers, p.id)
      end)
      tos = room:askToChoosePlayers(player, {
        targets = tos,
        min_num = 1,
        max_num = #tos,
        prompt = "#wzzz_s__96c4_4e89-slash",
        skill_name = skill_96c4_4e89.name,
        cancelable = true,
      })
      for _, p in ipairs(tos) do
        if not p.dead and not player.dead then
          room:useVirtualCard("slash", nil, player, p, skill_96c4_4e89.name, true)
        end
      end
    end
  end,
})

return skill_96c4_4e89
