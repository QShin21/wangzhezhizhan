local wzzz_v__yuce = fk.CreateSkill {
  name = "wzzz_v__yuce",
}

Fk:loadTranslationTable{
  ["wzzz_v__yuce"] = "御策",
  [":wzzz_v__yuce"] = "当你受到伤害后，你可以展示一张手牌，令伤害来源弃置一张类别不同的手牌，否则你回复1点体力。",

  ["#wzzz_v__yuce-invoke"] = "御策：你可以展示一张手牌，伤害来源需弃置一张类别不同的手牌，否则你回复1点体力",
  ["#wzzz_v__yuce-discard"] = "御策：你需弃置一张非%arg手牌，否则 %src 回复1点体力",

  ["$wzzz_v__yuce1"] = "御敌之策，成竹于胸。",
  ["$wzzz_v__yuce2"] = "以缓制急，不战屈兵。",
}

wzzz_v__yuce:addEffect(fk.Damaged, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__yuce.name) and not player:isKongcheng()
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local card = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = wzzz_v__yuce.name,
      cancelable = true,
      prompt = "#wzzz_v__yuce-invoke",
    })
    if #card > 0 then
      event:setCostData(self, {cards = card})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local card = event:getCostData(self).cards
    local type = Fk:getCardById(card[1]):getTypeString()
    player:showCards(card)
    if player.dead or not data.from or data.from.dead then return end
    local types = {"basic", "trick", "equip"}
    table.removeOne(types, type)
    if #room:askToDiscard(data.from, {
      skill_name = wzzz_v__yuce.name,
      include_equip = false,
      min_num = 1,
      max_num = 1,
      pattern = ".|.|.|hand|.|"..table.concat(types, ","),
      prompt = "#wzzz_v__yuce-discard:"..player.id.."::"..type,
      cancelable = true,
    }) == 0 then
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = wzzz_v__yuce.name,
      }
    end
  end,
})

return wzzz_v__yuce
