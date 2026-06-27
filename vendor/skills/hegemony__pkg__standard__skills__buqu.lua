local buqu = fk.CreateSkill{
  name = "wzzz_v__hs__buqu",
  derived_piles = "wzzz_v__hs__buqu_scar",
  tags = { Skill.Compulsory },
}
buqu:addEffect(fk.AskForPeaches, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(buqu.name) and player.dying
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local scar_id =room:getNCards(1)[1]
    local scar = Fk:getCardById(scar_id)
    player:addToPile("wzzz_v__hs__buqu_scar", scar_id, true, buqu.name)
    if player.dead or not table.contains(player:getPile("wzzz_v__hs__buqu_scar"), scar_id) then return false end
    local success = true
    for _, id in pairs(player:getPile("wzzz_v__hs__buqu_scar")) do
      if id ~= scar_id then
        local card = Fk:getCardById(id)
        if card.number == scar.number then
          success = false
          break
        end
      end
    end
    if success then
      room:recover({
        who = player,
        num = 1 - player.hp,
        recoverBy = player,
        skillName = buqu.name
      })
    else
      room:moveCardTo(scar, Card.DiscardPile, nil, fk.ReasonPutIntoDiscardPile, buqu.name, "wzzz_v__hs__buqu_scar", true, player)
    end
  end,
})

Fk:loadTranslationTable{
  ["wzzz_v__hs__buqu"] = "不屈",
  [":wzzz_v__hs__buqu"] = "锁定技，当你处于濒死状态时，你将牌堆顶的一张牌置于你的武将牌上，称为“创”，若此牌的点数与已有的“创”点数均不同，则你将体力回复至1点，若出现相同点数则将此牌置入弃牌堆。若你的武将牌上有“创”，则你的手牌上限与“创”的数量相等。",
  ["wzzz_v__hs__buqu_scar"] = "创",

  ["$wzzz_v__hs__buqu1"] = "战如熊虎，不惜躯命！",
  ["$wzzz_v__hs__buqu2"] = "哼，这点小伤算什么！",
}

buqu:addEffect("maxcards", {
  fixed_func = function(self, player)
    local n = #player:getPile("wzzz_v__hs__buqu_scar")
    if player:hasSkill(buqu.name) and n > 0 then
      return n
    end
  end,
})

return buqu
