local jiezi = fk.CreateSkill{
  name = "wzzz_v__m_ex__jiezi",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__jiezi"] = "截辎",
  [":wzzz_v__m_ex__jiezi"] = "其他角色跳过摸牌阶段后，你可以令一名角色摸一张牌。",
  ["#wzzz_v__m_ex__jiezi-choose"] = "截辎：你可以令一名角色摸一张牌",

  ["$wzzz_v__m_ex__jiezi1"] = "因粮于敌，故军食可足也。",
  ["$wzzz_v__m_ex__jiezi2"] = "食敌一钟，当吾二十钟。",
}

jiezi:addEffect(fk.EventPhaseSkipped, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jiezi.name) and target ~= player and data.phase == Player.Draw
  end,
  on_cost = function(self, event, target, player, data)
    local to = player.room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = player.room.alive_players,
      skill_name = jiezi.name,
      prompt = "#wzzz_v__m_ex__jiezi-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    event:getCostData(self).tos[1]:drawCards(1, jiezi.name)
  end,
})

return jiezi
