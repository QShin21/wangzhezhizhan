local pindi = fk.CreateSkill {
  name = "wzzz_v__ty_ex__pindi",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__pindi"] = "品第",
  [":wzzz_v__ty_ex__pindi"] = "出牌阶段每名角色限一次，你可以弃置一张本阶段未以此法弃置类型的牌并选择一名角色，令其摸X张牌或弃置X张牌"..
  "（X为本回合此技能发动次数）。若其已受伤，你横置。",

  ["#wzzz_v__ty_ex__pindi"] = "品第：弃置一张未弃置过类别的牌，令一名角色摸牌或弃牌（%arg张）",
  ["@@TyPindiSelected"] = "已选过",

  ["$wzzz_v__ty_ex__pindi1"] = "以九品论才，正是栋梁之谋。",
  ["$wzzz_v__ty_ex__pindi2"] = "置州郡中正，可为百年之政。",
}

pindi:addEffect("active", {
  anim_type = "control",
  prompt = function(self, player)
    return "#wzzz_v__ty_ex__pindi:::"..(player:usedSkillTimes(pindi.name, Player.HistoryTurn) + 1)
  end,
  card_num = 1,
  target_num = 1,
  interaction = UI.ComboBox { choices = {"draw_card", "discard_skill"} },
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and not player:prohibitDiscard(to_select) and
      not table.contains(player:getTableMark("wzzz_v__ty_ex__pindi-phase"), Fk:getCardById(to_select):getTypeString())
  end,
  target_tip = function (self, player, to_select)
    if table.contains(player:getTableMark("wzzz_v__ty_ex__pindi_target-phase"), to_select.id) then
      return { {content = "@@TyPindiSelected", type = "warning"} }
    end
  end,
  target_filter = function(self, player, to_select, selected)
    if #selected == 0 and not table.contains(player:getTableMark("wzzz_v__ty_ex__pindi_target-phase"), to_select.id) then
      return self.interaction.data == "draw_card" or not to_select:isNude()
    end
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:addTableMark(player, "wzzz_v__ty_ex__pindi-phase", Fk:getCardById(effect.cards[1]):getTypeString())
    room:addTableMark(player, "wzzz_v__ty_ex__pindi_target-phase", target.id)
    local n = player:usedSkillTimes(pindi.name, Player.HistoryTurn)
    room:throwCard(effect.cards, pindi.name, player)
    if not target.dead then
      if effect.interaction_data == "draw_card" then
        target:drawCards(n, pindi.name)
      else
        room:askToDiscard(target, {
          skill_name = pindi.name,
          min_num = n,
          max_num = n,
          include_equip = true,
          cancelable = false,
        })
      end
    end
    if target:isWounded() and not player.dead and not player.chained then
      player:setChainState(true)
    end
  end,
})

pindi:addLoseEffect(function (self, player, is_death)
  player.room:setPlayerMark(player, "wzzz_v__ty_ex__pindi-phase", 0)
  player.room:setPlayerMark(player, "wzzz_v__ty_ex__pindi_target-phase", 0)
end)

return pindi
