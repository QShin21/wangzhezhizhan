local jiangchi = fk.CreateSkill {
  name = "wzzz_v__ty_ex__jiangchi",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__jiangchi"] = "将驰",
  [":wzzz_v__ty_ex__jiangchi"] = "出牌阶段开始时，你可以选择一项：1.摸两张牌，此阶段不能使用或打出【杀】；2.摸一张牌；3.弃置一张牌，"..
  "此阶段使用【杀】无距离限制且可以多使用一张【杀】。若你选择第一项，弃牌阶段开始时，你可以展示任意张【杀】并令这些牌此阶段不计入手牌上限。",

  ["#wzzz_v__ty_ex__jiangchi-invoke"] = "将驰：你可以选一项执行",
  ["#wzzz_v__ty_ex__jiangchi-show"] = "将驰：你可以展示任意张【杀】，令这些牌此阶段不计入手牌上限",
  ["@@wzzz_v__ty_ex__jiangchi_targetmod-phase"] = "将驰 多出杀",
  ["@@wzzz_v__ty_ex__jiangchi_prohibit-phase"] = "将驰 禁止出杀",

  ["$wzzz_v__ty_ex__jiangchi1"] = "率师而行，所向皆破！",
  ["$wzzz_v__ty_ex__jiangchi2"] = "数从征伐，志意慷慨，不避险阻！",
}

jiangchi:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiangchi.name) and player.phase == Player.Play
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local success, dat = room:askToUseActiveSkill(player, {
      skill_name = "wzzz_v__ty_ex__jiangchi_active",
      prompt = "#wzzz_v__ty_ex__jiangchi-invoke",
      cancelable = true,
    })
    if success and dat then
      event:setCostData(self, {cards = dat.cards, choice = dat.interaction})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choice = event:getCostData(self).choice
    if choice == "wzzz_v__ty_ex__jiangchi_discard" then
      room:setPlayerMark(player, "@@wzzz_v__ty_ex__jiangchi_targetmod-phase", 1)
      room:throwCard(event:getCostData(self).cards, jiangchi.name, player, player)
    elseif choice == "draw1" then
      player:drawCards(1, jiangchi.name)
    elseif choice == "wzzz_v__ty_ex__jiangchi_draw2" then
      room:setPlayerMark(player, "@@wzzz_v__ty_ex__jiangchi_prohibit-phase", 1)
      player:drawCards(2, jiangchi.name)
    end
  end,
})

jiangchi:addEffect("targetmod", {
  residue_func = function(self, player, skill, scope)
    if skill.trueName == "slash_skill" and player:getMark("@@wzzz_v__ty_ex__jiangchi_targetmod-phase") > 0 and
      scope == Player.HistoryPhase then
      return 1
    end
  end,
  bypass_distances = function(self, player, skill, card, to)
    return skill.trueName == "slash_skill" and player:getMark("@@wzzz_v__ty_ex__jiangchi_targetmod-phase") > 0
  end,
})

jiangchi:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    return player:getMark("@@wzzz_v__ty_ex__jiangchi_prohibit-phase") > 0 and card and card.trueName == "slash"
  end,
  prohibit_response = function (self, player, card)
    return player:getMark("@@wzzz_v__ty_ex__jiangchi_prohibit-phase") > 0 and card and card.trueName == "slash"
  end
})

jiangchi:addEffect(fk.EventPhaseStart, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Discard and
      player:getMark("@@wzzz_v__ty_ex__jiangchi_prohibit-phase") > 0 and
      table.find(player:getCardIds("h"), function(id)
        return Fk:getCardById(id).trueName == "slash"
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local cards = player.room:askToCards(player, {
      min_num = 0,
      max_num = 999,
      include_equip = false,
      pattern = "slash|.|.|hand",
      skill_name = jiangchi.name,
      prompt = "#wzzz_v__ty_ex__jiangchi-show",
      cancelable = true,
    })
    if #cards > 0 then
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player:showCards(event:getCostData(self).cards)
    player.room:setPlayerMark(player, "wzzz_v__ty_ex__jiangchi_exclude-phase", event:getCostData(self).cards)
  end,
})

jiangchi:addEffect("maxcards", {
  exclude_from = function(self, player, card)
    return table.contains(player:getTableMark("wzzz_v__ty_ex__jiangchi_exclude-phase"), card.id)
  end,
})

return jiangchi
