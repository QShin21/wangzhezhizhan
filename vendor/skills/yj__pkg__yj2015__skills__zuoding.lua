local wzzz_v__zuoding = fk.CreateSkill {
  name = "wzzz_v__zuoding",
}

Fk:loadTranslationTable{
  ["wzzz_v__zuoding"] = "佐定",
  [":wzzz_v__zuoding"] = "当其他角色于其出牌阶段内使用♠牌指定目标后，若本阶段没有角色受到过伤害，你可以令其中一名目标角色摸一张牌。",

  ["#wzzz_v__zuoding-choose"] = "佐定：你可以令一名目标角色摸一张牌",

  ["$wzzz_v__zuoding1"] = "只有忠心，没有谋略，是不够的。",
  ["$wzzz_v__zuoding2"] = "承君恩宠，报效国家！",
}

wzzz_v__zuoding:addEffect(fk.TargetSpecified, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(wzzz_v__zuoding.name) and target ~= player and target.phase == Player.Play and data.firstTarget and
      data.card.suit == Card.Spade and
      table.find(data.use.tos, function(p)
        return not p.dead
      end) and
      #player.room.logic:getActualDamageEvents(1, Util.TrueFunc, Player.HistoryPhase) == 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      skill_name = wzzz_v__zuoding.name,
      min_num = 1,
      max_num = 1,
      targets = data.use.tos,
      prompt = "#wzzz_v__zuoding-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    event:getCostData(self).tos[1]:drawCards(1, wzzz_v__zuoding.name)
  end,
})

return wzzz_v__zuoding
