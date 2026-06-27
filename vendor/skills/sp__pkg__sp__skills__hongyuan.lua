local hongyuan = fk.CreateSkill {
  name = "wzzz_v__hongyuan",
}

Fk:loadTranslationTable{
  ["wzzz_v__hongyuan"] = "弘援",
  [":wzzz_v__hongyuan"] = "摸牌阶段结束时，你可以依次交给至多两名其他角色各一张牌。",

  ["#wzzz_v__hongyuan-choose"] = "弘援：你可以交给至多两名其他角色各一张牌",
  ["#wzzz_v__hongyuan-give"] = "弘援：交给 %dest 一张手牌",

  ["$wzzz_v__hongyuan1"] = "诸将莫慌，粮草已到。",
  ["$wzzz_v__hongyuan2"] = "自舍其身，施于天下。",
}

hongyuan:addEffect(fk.EventPhaseEnd, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Draw and player:hasSkill(hongyuan.name) and
      not player:isKongcheng() and #player.room:getOtherPlayers(player, false) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
      targets = room:getOtherPlayers(player, false),
      min_num = 1,
      max_num = 2,
      prompt = "#wzzz_v__hongyuan-choose",
      skill_name = hongyuan.name,
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local tos = event:getCostData(self).tos
    for _, p in ipairs(tos) do
      if player.dead or player:isKongcheng() then return end
      if not p.dead then
        local card = room:askToCards(player, {
          min_num = 1,
          max_num = 1,
          include_equip = false,
          skill_name = hongyuan.name,
          prompt = "#wzzz_v__hongyuan-give::"..p.id,
          cancelable = false,
        })
        room:moveCardTo(card, Card.PlayerHand, p, fk.ReasonGive, hongyuan.name, nil, false, player)
      end
    end
  end,
})

return hongyuan
