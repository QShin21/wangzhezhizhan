local huangtian = fk.CreateSkill {
  name = "wzzz_v__ol_ex__huangtian",
  tags = { Skill.Lord },
  attached_skill_name = "wzzz_v__ol_ex__huangtian_active&",
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__huangtian"] = "黄天",
  [":wzzz_v__ol_ex__huangtian"] = "主公技，其他群势力角色出牌阶段限一次，其可以交给你一张【闪】或【闪电】或黑桃手牌并展示之；每回合限一次，其他群势力角色使用或打出【闪】后，你可以获得之。",

  ["$wzzz_v__ol_ex__huangtian1"] = "黄天法力，万军可灭！",
  ["$wzzz_v__ol_ex__huangtian2"] = "天书庇佑，黄巾可兴！",
}

huangtian:addAcquireEffect(function (self, player)
  local room = player.room
  for _, p in ipairs(room:getOtherPlayers(player, false)) do
    if p.kingdom == "qun" then
      room:handleAddLoseSkills(p, "wzzz_v__ol_ex__huangtian_active&", nil, false, true)
    else
      room:handleAddLoseSkills(p, "-wzzz_v__ol_ex__huangtian_active&", nil, false, true)
    end
  end
end)

huangtian:addEffect(fk.AfterPropertyChange, {
  can_refresh = function(self, event, target, player, data)
    return target == player
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    if player.kingdom == "qun" and table.find(room.alive_players, function (p)
      return p ~= player and p:hasSkill(huangtian.name, true)
    end) then
      room:handleAddLoseSkills(player, huangtian.attached_skill_name, nil, false, true)
    else
      room:handleAddLoseSkills(player, "-" .. huangtian.attached_skill_name, nil, false, true)
    end
  end,
})

local huangtian_collect_spec = {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huangtian.name) and target and target ~= player and target.kingdom == "qun" and
      data.card and data.card.trueName == "jink" and player:getMark("wzzz_v__ol_ex__huangtian_collect-turn") == 0 and
      player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:addPlayerMark(player, "wzzz_v__ol_ex__huangtian_collect-turn")
    player.room:obtainCard(player, data.card, true, fk.ReasonJustMove, player, huangtian.name)
  end,
}

huangtian:addEffect(fk.CardUsing, huangtian_collect_spec)
huangtian:addEffect(fk.CardResponding, huangtian_collect_spec)

return huangtian
