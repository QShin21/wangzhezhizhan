local zhiba = fk.CreateSkill {
  name = "wzzz_v__zhiba",
  tags = { Skill.Lord },
  attached_skill_name = "wzzz_v__zhiba_active&",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhiba"] = "制霸",
  [":wzzz_v__zhiba"] = "主公技，其他吴势力角色的出牌阶段限一次，其可以与你拼点（若你发动过〖魂姿〗，你可以拒绝此拼点），若其没赢，你可以获得拼点的两张牌。",

  ["#wzzz_v__zhiba-ask"] = "%src 发起“制霸”拼点，是否拒绝？",
  ["wzzz_v__zhiba_yes"] = "进行“制霸”拼点",
  ["wzzz_v__zhiba_no"] = "拒绝“制霸”拼点",

  ["$wzzz_v__zhiba1"] = "是友是敌，一探便知。",
  ["$wzzz_v__zhiba2"] = "我若怕你，非孙伯符也！",
}

zhiba:addAcquireEffect(function (self, player)
  local room = player.room
  for _, p in ipairs(room:getOtherPlayers(player, false)) do
    if p.kingdom == "wu" then
      room:handleAddLoseSkills(p, "wzzz_v__zhiba_active&", nil, false, true)
    else
      room:handleAddLoseSkills(p, "-wzzz_v__zhiba_active&", nil, false, true)
    end
  end
end)

zhiba:addEffect(fk.AfterPropertyChange, {
  can_refresh = function(self, event, target, player, data)
    return target == player
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    if player.kingdom == "wu" and table.find(room.alive_players, function (p)
      return p ~= player and p:hasSkill(zhiba.name, true)
    end) then
      room:handleAddLoseSkills(player, "wzzz_v__zhiba_active&", nil, false, true)
    else
      room:handleAddLoseSkills(player, "-wzzz_v__zhiba_active&", nil, false, true)
    end
  end,
})

return zhiba
