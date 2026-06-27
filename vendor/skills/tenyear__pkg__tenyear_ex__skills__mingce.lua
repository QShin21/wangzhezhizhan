local mingce = fk.CreateSkill {
  name = "wzzz_v__ty_ex__mingce",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__mingce"] = "明策",
  [":wzzz_v__ty_ex__mingce"] = "出牌阶段限一次，你可以展示一张【杀】或装备牌并交给一名其他角色，然后其选择一项：1.视为对你选择的一名角色使用一张【杀】，此【杀】第一次造成伤害后，其执行另一项；2.你与其各摸一张牌。",

  ["#wzzz_v__ty_ex__mingce"] = "明策：将一张装备牌或【杀】交给一名角色，然后选择第二名角色",
  ["#wzzz_v__ty_ex__mingce1"] = "明策：将一张装备牌或【杀】交给 %src，选择第二名角色",
  ["#wzzz_v__ty_ex__mingce2"] = "明策：将一张装备牌或【杀】交给 %src，其选择视为对 %dest 使用【杀】或与你各摸一张牌",
  ["wzzz_v__ty_ex__mingce_slash"] = "视为对%dest使用【杀】",
  ["wzzz_v__ty_ex__mingce_draw"] = "与%src各摸一张牌",

  ["$wzzz_v__ty_ex__mingce1"] = "阁下若纳此谋，则大业可成也！",
  ["$wzzz_v__ty_ex__mingce2"] = "形势如此，将军可按计行事。",
}

mingce:addEffect("active", {
  anim_type = "support",
  prompt = function (self, player, selected_cards, selected_targets)
    if #selected_targets == 0 then
      return "#wzzz_v__ty_ex__mingce"
    elseif #selected_targets == 1 then
      return "#wzzz_v__ty_ex__mingce1:"..selected_targets[1].id
    elseif #selected_targets == 2 then
      return "#wzzz_v__ty_ex__mingce2:"..selected_targets[1].id..":"..selected_targets[2].id
    end
  end,
  card_num = 1,
  target_num = 2,
  can_use = function(self, player)
    return player:usedSkillTimes(mingce.name, Player.HistoryPhase) == 0
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and (Fk:getCardById(to_select).trueName == "slash" or Fk:getCardById(to_select).type == Card.TypeEquip)
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    if #selected == 0 then
      return to_select ~= player
    elseif #selected == 1 and selected[1] ~= player then
      return true
    end
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local to = effect.tos[2]
    player:showCards(effect.cards)
    room:obtainCard(target, effect.cards, true, fk.ReasonGive, player, mingce.name)
    if target.dead then return end
    if not to.dead then
      local choice = room:askToChoice(target, {
        choices = {"wzzz_v__ty_ex__mingce_slash::"..to.id, "wzzz_v__ty_ex__mingce_draw:"..player.id},
        skill_name = mingce.name,
      })
      if choice:startsWith("wzzz_v__ty_ex__mingce_slash") then
        local use = room:useVirtualCard("slash", nil, target, to, mingce.name, true)
        if not (use and use.damageDealt) then return end
      end
    end
    if not player.dead then
      player:drawCards(1, mingce.name)
    end
    if not target.dead then
      target:drawCards(1, mingce.name)
    end
  end,
})

return mingce
