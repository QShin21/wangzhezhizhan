local qingnang = fk.CreateSkill{
  name = "wzzz_v__m_ex__qingnang",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__qingnang"] = "青囊",
  [":wzzz_v__m_ex__qingnang"] = "出牌阶段限一次，你可以弃置一张手牌并令一名本回合未以此法选择过的角色回复1点体力，若你弃置的牌为红色，你可以重复此流程。",

  ["#wzzz_v__m_ex__qingnang"] = "青囊：弃置一张手牌，令一名本回合未选择过的角色回复1点体力，若弃置了红色牌则可以继续发动",
  ["#wzzz_v__m_ex__qingnang-invoke"] = "青囊：你可以继续对本阶段未选择过的角色发动“青囊”",

  ["$wzzz_v__m_ex__qingnang1"] = "普济众生，乃行医本分。",
  ["$wzzz_v__m_ex__qingnang2"] = "先来一剂补药。",
}

qingnang:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__m_ex__qingnang",
  card_num = 1,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(qingnang.name, Player.HistoryPhase) == 0 and
      (not WzzzJishi or not WzzzJishi.skillAvailable or WzzzJishi.skillAvailable(player, qingnang.name))
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and table.contains(player:getCardIds("h"), to_select) and not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected, cards)
    return #selected == 0 and not table.contains(player:getTableMark("wzzz_v__m_ex__qingnang-phase"), to_select.id)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:addTableMark(player, "wzzz_v__m_ex__qingnang-phase", target.id)
    local yes = Fk:getCardById(effect.cards[1]).color == Card.Red
    room:throwCard(effect.cards, qingnang.name, player, player)
    if target:isWounded() and not target.dead then
      room:recover{
        who = target,
        num = 1,
        recoverBy = player,
        skillName = qingnang.name,
      }
    end
    if yes and not player.dead and not player:isKongcheng() then
      local targets = table.filter(room.alive_players, function (p)
        return not table.contains(player:getTableMark("wzzz_v__m_ex__qingnang-phase"), p.id)
      end)
      if #targets > 0 then
        room:askToUseActiveSkill(player, {
          skill_name = qingnang.name,
          prompt = "#wzzz_v__m_ex__qingnang-invoke",
          cancelable = true,
        })
      end
    end
  end,
})

return qingnang
