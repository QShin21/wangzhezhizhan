local anxu = fk.CreateSkill {
  name = "wzzz_v__m_ex__anxu",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__anxu"] = "安恤",
  [":wzzz_v__m_ex__anxu"] = "出牌阶段限一次，你可以令一名其他角色获得另一名其他角色的一张牌并展示之，若其获得的是手牌且不为黑桃牌，你摸一张牌。",

  ["#wzzz_v__m_ex__anxu-active"] = "安恤：选择两名其他角色，令先选择的角色获得后选择的角色的一张牌",

  ["$wzzz_v__m_ex__anxu1"] = "贤淑重礼，育人育己。",
  ["$wzzz_v__m_ex__anxu2"] = "雨露均沾，后宫不乱。",
}

anxu:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__m_ex__anxu-active",
  max_phase_use_time = 1,
  card_num = 0,
  target_num = 2,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    if #selected == 1 and to_select:isNude() then return false end
    return #selected < 2 and to_select ~= player
  end,
  on_use = function(self, room, use)
    local player = use.from
    local target1 = use.tos[1]
    local target2 = use.tos[2]
    local card = room:askToChooseCard(target1, {
      target = target2,
      flag = "he",
      skill_name = anxu.name,
    })
    local can_draw = room:getCardArea(card) == Card.PlayerHand and Fk:getCardById(card).suit ~= Card.Spade
    target1:showCards(card)
    room:obtainCard(target1, card, false, fk.ReasonPrey, target1, anxu.name)
    if can_draw and not player.dead then
      player:drawCards(1, anxu.name)
    end
  end,
})

return anxu
