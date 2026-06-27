local xianzhen = fk.CreateSkill {
  name = "wzzz_v__ty_ex__xianzhen",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__xianzhen"] = "陷阵",
  [":wzzz_v__ty_ex__xianzhen"] = "出牌阶段限一次，你可以与一名角色拼点，若你：嬴，本回合你无视该角色的防具、对其使用牌无距离次数限制、使用每种牌名的牌第一次对其造成的伤害+1；没赢，本回合你不能使用【杀】，弃牌阶段开始时，你可以展示任意张【杀】并令这些牌此阶段不计入手牌上限。",

  ["#wzzz_v__ty_ex__xianzhen"] = "陷阵：与一名角色拼点，若赢，对其使用牌无距离次数限制且无视防具、伤害+1",
  ["#wzzz_v__ty_ex__xianzhen-show"] = "陷阵：你可以展示任意张【杀】，令这些牌此阶段不计入手牌上限",
  ["@@wzzz_v__ty_ex__xianzhen-turn"] = "陷阵",

  ["$wzzz_v__ty_ex__xianzhen1"] = "精练整齐，每战必克！",
  ["$wzzz_v__ty_ex__xianzhen2"] = "陷阵杀敌，好不爽快！",
}

xianzhen:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__ty_ex__xianzhen",
  card_num = 0,
  target_num = 1,
  times = function (_, player)
    return 1 - player:usedSkillTimes(xianzhen.name, Player.HistoryPhase)
  end,
  can_use = function(self, player)
    return player:usedSkillTimes(xianzhen.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and player:canPindian(to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local pindian = player:pindian({target}, xianzhen.name)
    if pindian.results[target].winner == player then
      room:addTableMark(target, "@@wzzz_v__ty_ex__xianzhen-turn", player.id)
      room:addTableMark(player, MarkEnum.MarkArmorInvalidTo .. "-turn", target.id)
    elseif not player.dead then
      room:setPlayerMark(player, "wzzz_v__ty_ex__xianzhen_lose-turn", 1)
    end
  end,
})

xianzhen:addEffect(fk.DamageCaused, {
  anim_type = "offensive",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and table.contains(data.to:getTableMark("@@wzzz_v__ty_ex__xianzhen-turn"), player.id) and
      data.card and not table.contains(player:getTableMark("wzzz_v__ty_ex__xianzhen_card-turn"), data.card.trueName)
  end,
  on_use = function(self, event, target, player, data)
    player.room:addTableMark(player, "wzzz_v__ty_ex__xianzhen_card-turn", data.card.trueName)
    data:changeDamage(1)
  end,
})

xianzhen:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card, to)
    return card and to and table.contains(to:getTableMark("@@wzzz_v__ty_ex__xianzhen-turn"), player.id)
  end,
  bypass_distances = function(self, player, skill, card, to)
    return card and to and table.contains(to:getTableMark("@@wzzz_v__ty_ex__xianzhen-turn"), player.id)
  end,
})

xianzhen:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    return player:getMark("wzzz_v__ty_ex__xianzhen_lose-turn") > 0 and card and card.trueName == "slash"
  end,
})

xianzhen:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Discard and
      player:getMark("wzzz_v__ty_ex__xianzhen_lose-turn") > 0 and
      table.find(player:getCardIds("h"), function(id)
        return Fk:getCardById(id).trueName == "slash"
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local slash_ids = table.filter(player:getCardIds("h"), function(id)
      return Fk:getCardById(id).trueName == "slash"
    end)
    local cards = player.room:askToCards(player, {
      min_num = 1,
      max_num = #slash_ids,
      include_equip = false,
      pattern = tostring(Exppattern{ id = slash_ids }),
      skill_name = xianzhen.name,
      prompt = "#wzzz_v__ty_ex__xianzhen-show",
      cancelable = true,
    })
    if #cards > 0 then
      player:showCards(cards)
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "wzzz_v__ty_ex__xianzhen_exclude-turn", event:getCostData(self).cards)
  end,
})

xianzhen:addEffect("maxcards", {
  exclude_from = function(self, player, card)
    return card.trueName == "slash" and
      table.contains(player:getTableMark("wzzz_v__ty_ex__xianzhen_exclude-turn"), card.id)
  end,
})

return xianzhen
