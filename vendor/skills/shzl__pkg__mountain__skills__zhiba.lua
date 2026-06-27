local zhiba = fk.CreateSkill {
  name = "wzzz_v__zhiba",
  tags = { Skill.Lord },
  attached_skill_name = "wzzz_v__zhiba_active&",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhiba"] = "制霸",
  [":wzzz_v__zhiba"] = "主公技，其他吴势力角色的出牌阶段限一次，其可以与你拼点（你可以拒绝此拼点）；出牌阶段限一次，你可以与一名其他吴势力角色拼点。若其没赢，你可以获得拼点的两张牌。",

  ["#wzzz_v__zhiba-active"] = "制霸：你可以与一名其他吴势力角色拼点",
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

zhiba:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__zhiba-active",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(zhiba.name, Player.HistoryPhase) == 0 and not player:isKongcheng() and
      table.find(Fk:currentRoom().alive_players, function(p)
        return p ~= player and p.kingdom == "wu" and player:canPindian(p)
      end)
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and to_select ~= player and to_select.kingdom == "wu" and player:canPindian(to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    if not target or target.dead then return end
    local pindian = player:pindian({ target }, zhiba.name)
    if player.dead or target.dead then return end
    if pindian.results[target].winner ~= target then
      local to_get = {}
      local cid = pindian.fromCard and pindian.fromCard:getEffectiveId()
      if room:getCardArea(cid) == Card.DiscardPile then
        table.insert(to_get, cid)
      end
      local toCard = pindian.results[target].toCard
      cid = toCard and toCard:getEffectiveId()
      if room:getCardArea(cid) == Card.DiscardPile then
        table.insertIfNeed(to_get, cid)
      end
      if #to_get > 0 then
        room:obtainCard(player, to_get, true, fk.ReasonJustMove, player, zhiba.name)
      end
    end
  end,
})

return zhiba
