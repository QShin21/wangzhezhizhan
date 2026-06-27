local yinbing = fk.CreateSkill {
  name = "wzzz_v__qshm__yinbing",
  derived_piles = "$yinbing",
}

Fk:loadTranslationTable{
  ["wzzz_v__qshm__yinbing"] = "引兵",
  [":wzzz_v__qshm__yinbing"] = "游戏开始时或结束阶段，你可以将任意名攻击范围内包含你的其他角色的各一张手牌置于你的武将牌上，然后你可以将你的一张手牌置于武将牌上，称为“引兵”（至多两张）；当你受到【杀】或【决斗】造成的伤害后，你移去一张“引兵”牌。",

  ["$yinbing"] = "引兵",
  ["#wzzz_v__qshm__yinbing-choose"] = "引兵：你可以将任意名攻击范围内包含你的其他角色各一张手牌置为“引兵”牌",
  ["#wzzz_v__qshm__yinbing-self"] = "引兵：你可以将一张手牌置为“引兵”牌（至多两张）",
  ["#wzzz_v__qshm__yinbing-remove"] = "引兵：移去一张“引兵”牌",
}

local function canYinbing(player)
  return table.find(player.room:getOtherPlayers(player, false), function (p)
    return p:inMyAttackRange(player) and not p:isKongcheng()
  end) or (not player:isKongcheng() and #player:getPile("$yinbing") < 2)
end

local function doYinbing(room, player)
  local targets = table.filter(room:getOtherPlayers(player, false), function (p)
    return p:inMyAttackRange(player) and not p:isKongcheng()
  end)
  local tos = {}
  if #targets > 0 then
    tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = #targets,
      targets = targets,
      skill_name = yinbing.name,
      prompt = "#wzzz_v__qshm__yinbing-choose",
      cancelable = true,
    })
    room:sortByAction(tos)
  end
  for _, p in ipairs(tos) do
    if not player:hasSkill(yinbing.name, true) then return end
    if not p:isKongcheng() then
      local card = room:askToChooseCard(player, {
        target = p,
        flag = "h",
        skill_name = yinbing.name,
      })
      player:addToPile("$yinbing", card, false, yinbing.name)
    end
  end
  if not player:isKongcheng() and #player:getPile("$yinbing") < 2 then
    local card = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = yinbing.name,
      prompt = "#wzzz_v__qshm__yinbing-self",
      cancelable = true,
    })
    if #card > 0 then
      player:addToPile("$yinbing", card, false, yinbing.name, player)
    end
  end
end

yinbing:addEffect(fk.GameStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yinbing.name) and canYinbing(player) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, yinbing.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    doYinbing(player.room, player)
  end,
})

yinbing:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yinbing.name) and player.phase == Player.Finish and canYinbing(player)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    doYinbing(player.room, player)
  end,
})

yinbing:addEffect(fk.Damaged, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yinbing.name) and #player:getPile("$yinbing") > 0 and
      data.card and (data.card.trueName == "slash" or data.card.name == "duel")
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local card = room:askToChooseCard(player, {
      target = player,
      flag = { card_data = {{ yinbing.name, player:getPile("$yinbing") }} },
      prompt = "#wzzz_v__qshm__yinbing-remove",
      skill_name = yinbing.name,
    })
    room:moveCardTo(card, Card.DiscardPile, nil, fk.ReasonPutIntoDiscardPile, yinbing.name, nil, true, player)
  end,
})

return yinbing
