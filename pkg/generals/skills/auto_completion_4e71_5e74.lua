local skill_4e71_5e74 = fk.CreateSkill {
  name = "wzzz_s__4e71_5e74",
  attached_skill_name = "wzzz_s__4e71_5e74_active&",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable {
  ["wzzz_s__4e71_5e74"] = "乱年",
  [":" .. "wzzz_s__4e71_5e74"] = "主公技，其他群势力角色出牌阶段限一次，其可以弃置X张牌，对“雄争”角色造成1点伤害（X为此技能本轮此前发动的次数+1）。",
}

local function updateLuannian(room, player)
  if player.kingdom == "qun" and table.find(room.alive_players, function(p)
    return p ~= player and p:hasSkill(skill_4e71_5e74.name, true)
  end) then
    room:handleAddLoseSkills(player, skill_4e71_5e74.attached_skill_name, nil, false, true)
  else
    room:handleAddLoseSkills(player, "-" .. skill_4e71_5e74.attached_skill_name, nil, false, true)
  end
end

skill_4e71_5e74:addAcquireEffect(function(self, player)
  local room = player.room
  for _, p in ipairs(room:getOtherPlayers(player, false)) do
    updateLuannian(room, p)
  end
end)

skill_4e71_5e74:addLoseEffect(function(self, player)
  local room = player.room
  for _, p in ipairs(room.alive_players) do
    updateLuannian(room, p)
  end
end)

skill_4e71_5e74:addEffect(fk.AfterPropertyChange, {
  can_refresh = function(self, event, target, player, data)
    return target == player
  end,
  on_refresh = function(self, event, target, player, data)
    updateLuannian(player.room, player)
  end,
})

return skill_4e71_5e74
