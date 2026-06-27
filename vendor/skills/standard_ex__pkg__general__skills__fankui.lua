Fk:loadTranslationTable{
  ["wzzz_v__ex__fankui"] = "反馈",
  [":wzzz_v__ex__fankui"] = "当你受到1点伤害后，可以选择其中一项：1.你获得一名角色区域里的一张牌；2.观看一名角色手牌并获得其中一张牌（每轮限一次）。",

  ["wzzz_v__ex__fankui_area"] = "获得区域里一张牌",
  ["wzzz_v__ex__fankui_hand"] = "观看手牌并获得一张",
  ["#wzzz_v__ex__fankui-area"] = "反馈：选择一名角色，获得其区域里一张牌",
  ["#wzzz_v__ex__fankui-hand"] = "反馈：选择一名角色，观看其手牌并获得其中一张",

  ["$wzzz_v__ex__fankui1"] = "哼，自作孽不可活！",
  ["$wzzz_v__ex__fankui2"] = "哼，正中下怀！",
}

local fankui = fk.CreateSkill{
  name = "wzzz_v__ex__fankui",
}

fankui:addEffect(fk.Damaged, {
  anim_type = "masochism",
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(fankui.name) and
      (table.find(player.room.alive_players, function(p)
        return #p:getCardIds("hej") > 0
      end) or
      (player:getMark("wzzz_v__ex__fankui_hand-round") == 0 and table.find(player.room.alive_players, function(p)
        return not p:isKongcheng()
      end)))
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local choices = {"Cancel"}
    if table.find(room.alive_players, function(p) return #p:getCardIds("hej") > 0 end) then
      table.insert(choices, 1, "wzzz_v__ex__fankui_area")
    end
    if player:getMark("wzzz_v__ex__fankui_hand-round") == 0 and
      table.find(room.alive_players, function(p) return not p:isKongcheng() end) then
      table.insert(choices, math.min(#choices, 2), "wzzz_v__ex__fankui_hand")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = fankui.name,
    })
    if choice == "Cancel" then return false end
    local targets = table.filter(room.alive_players, function(p)
      if choice == "wzzz_v__ex__fankui_area" then
        return #p:getCardIds("hej") > 0
      end
      return not p:isKongcheng()
    end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = fankui.name,
      prompt = choice == "wzzz_v__ex__fankui_area" and "#wzzz_v__ex__fankui-area" or "#wzzz_v__ex__fankui-hand",
      cancelable = false,
    })
    event:setCostData(self, {tos = to, choice = choice})
    return true
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    if event:getCostData(self).choice == "wzzz_v__ex__fankui_hand" then
      room:setPlayerMark(player, "wzzz_v__ex__fankui_hand-round", 1)
      room:viewCards(player, { cards = to:getCardIds("h"), skill_name = fankui.name, prompt = "$ViewCardsFrom:"..to.id })
      if to.dead or to:isKongcheng() then return end
      local card = room:askToChooseCard(player, {
        target = to,
        flag = "h",
        skill_name = fankui.name,
      })
      room:obtainCard(player, card, false, fk.ReasonPrey, player, fankui.name)
    else
      local card = room:askToChooseCard(player, {
        target = to,
        flag = "hej",
        skill_name = fankui.name,
      })
      room:obtainCard(player, card, false, fk.ReasonPrey, player, fankui.name)
    end
  end,
})

return fankui
