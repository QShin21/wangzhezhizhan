local hanzhan = fk.CreateSkill{
  name = "wzzz_v__hanzhan",
}

Fk:loadTranslationTable {
  ["wzzz_v__hanzhan"] = "酣战",
  [":wzzz_v__hanzhan"] = "当你拼点前，你可以令对方用你选择的手牌拼点；当你拼点后，你可以获得拼点牌中点数最大的【杀】。",
  ["#wzzz_v__hanzhan-invoke"] = "酣战：是否选择对方用于拼点的手牌？",

  ["$wzzz_v__hanzhan1"] = "伯符，且与我一战！",
  ["$wzzz_v__hanzhan2"] = "与君酣战，快哉快哉！",
}

hanzhan:addEffect(fk.StartPindian, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(hanzhan.name) then return false end
    if player == data.from then
      for _, to in ipairs(data.tos) do
        if not (data.results[to] and data.results[to].toCard) then
          return true
        end
      end
    elseif not data.fromCard then
      return table.contains(data.tos, player)
    end
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = hanzhan.name,
      prompt = "#wzzz_v__hanzhan-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player == data.from then
      for _, to in ipairs(data.tos) do
        if not (to.dead or to:isKongcheng() or (data.results[to] and data.results[to].toCard)) then
          data.results[to] = data.results[to] or {}
          local id = room:askToChooseCard(player, {
            target = to,
            flag = "h",
            skill_name = hanzhan.name,
          })
          data.results[to].toCard = Fk:getCardById(id)
        end
      end
    elseif not (data.from.dead or data.from:isKongcheng()) then
      local id = room:askToChooseCard(player, {
        target = data.from,
        flag = "h",
        skill_name = hanzhan.name,
      })
      data.fromCard = Fk:getCardById(id)
    end
  end,
})

hanzhan:addEffect(fk.PindianResultConfirmed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(hanzhan.name) then return false end
    if player == data.from or player == data.to then
      local cardA = Fk:getCardById(data.fromCard:getEffectiveId())
      local cardB = Fk:getCardById(data.toCard:getEffectiveId())
      local cards = {}
      if cardA.trueName == "slash" then
        cards = {cardA.id}
      end
      if cardB.trueName == "slash" then
        if cardA.trueName == "slash" then
          if cardA.number == cardB.number and cardA.id ~= cardB.id then
            table.insert(cards, cardB.id)
          elseif cardA.number < cardB.number then
            cards = {cardB.id}
          end
        else
          cards = {cardB.id}
        end
      end
      cards = table.filter(cards, function (id)
        return player.room:getCardArea(id) == Card.Processing
      end)
      if #cards > 0 then
        event:setCostData(self, {cards = cards})
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:moveCardTo(event:getCostData(self).cards, Player.Hand, player, fk.ReasonPrey, hanzhan.name, nil, true, player)
  end,
})

return hanzhan
