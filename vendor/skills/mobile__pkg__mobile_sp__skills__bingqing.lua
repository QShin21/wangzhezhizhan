local bingqing = fk.CreateSkill {
  name = "wzzz_v__bingqing",
}

Fk:loadTranslationTable{
  ["wzzz_v__bingqing"] = "秉清",
  [":wzzz_v__bingqing"] = "当你于出牌阶段内使用牌时，若此牌与你此阶段使用过的牌花色均不相同，则你记录此花色。此牌结算结束后，"..
  "根据此阶段记录的花色数，你可以执行对应效果：<br>两种，令一名角色摸两张牌；<br>三种，弃置一名角色区域内的一张牌；<br>四种，对一名其他角色造成1点伤害。",

  ["@wzzz_v__bingqing-phase"] = "秉清",
  ["#wzzz_v__bingqing-draw"] = "秉清：你可以令一名角色摸两张牌",
  ["#wzzz_v__bingqing-discard"] = "秉清：你可以弃置一名角色区域里的一张牌",
  ["#wzzz_v__bingqing-damage"] = "秉清：你可以对一名其他角色造成1点伤害",

  ["$wzzz_v__bingqing1"] = "常怀圣言，以是自励。",
  ["$wzzz_v__bingqing2"] = "身受贵宠，不忘初心。",
}

bingqing:addEffect(fk.CardUseFinished, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(bingqing.name) and
      player.phase == Player.Play and
      (data.extra_data or {}).bingqing and
      #player:getTableMark("@wzzz_v__bingqing-phase") > 1 and
      #player:getTableMark("@wzzz_v__bingqing-phase") < 5
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local suitsNum = #player:getTableMark("@wzzz_v__bingqing-phase")
    local targets = {}
    local prompt = "#wzzz_v__bingqing-draw"
    if suitsNum == 2 then
      targets = room:getAlivePlayers(false)
    elseif suitsNum == 3 then
      targets = table.filter(room.alive_players, function(p)
        if p == player and not table.find(player:getCardIds("hej"), function(id)
          return not player:prohibitDiscard(Fk:getCardById(id))
        end) then
          return false
        end
        return not p:isAllNude()
      end)
      prompt = "#wzzz_v__bingqing-discard"
    else
      targets = room:getOtherPlayers(player, false)
      prompt = "#wzzz_v__bingqing-damage"
    end
    if #targets == 0 then return end

    local tos = room:askToChoosePlayers(player, {
      targets = targets,
      min_num = 1,
      max_num = 1,
      prompt = prompt,
      skill_name = bingqing.name,
    })
    if #tos > 0 then
      event:setCostData(self, { tos = tos })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    ---@type string
    local skillName = bingqing.name
    local room = player.room
    local suitsNum = #player:getTableMark("@wzzz_v__bingqing-phase")
    local to = event:getCostData(self).tos[1]
    if suitsNum == 2 then
      to:drawCards(2, skillName)
    elseif suitsNum == 3 then
      local cards = {}
      if to == player then
        cards = table.filter(player:getCardIds("hej"), function (id)
          return not player:prohibitDiscard(id)
        end)
        cards = room:askToCards(player, {
          min_num = 1,
          max_num = 1,
          include_equip = true,
          skill_name = bingqing.name,
          pattern = tostring(Exppattern{ id = cards }),
          cancelable = false,
          expand_pile = player:getCardIds("j"),
        })
      else
        cards = room:askToChooseCard(player, {
          target = to,
          flag = "hej",
          skill_name = skillName,
        })
      end
      room:throwCard(cards, skillName, to, player)
    else
      room:damage({
        from = player,
        to = to,
        damage = 1,
        damageType = fk.NormalDamage,
        skillName = skillName,
      })
    end
  end,
})

bingqing:addEffect(fk.CardUsing, {
  can_refresh = function(self, event, target, player, data)
    return
      player:hasSkill(bingqing.name, true) and
      target == player and
      player.phase == Player.Play and
      data.card.suit ~= Card.NoSuit and
      not table.contains(player:getTableMark("@wzzz_v__bingqing-phase"), data.card:getSuitString(true))
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    room:addTableMark(player, "@wzzz_v__bingqing-phase", data.card:getSuitString(true))
    data.extra_data = data.extra_data or {}
    data.extra_data.bingqing = true
  end,
})

return bingqing
