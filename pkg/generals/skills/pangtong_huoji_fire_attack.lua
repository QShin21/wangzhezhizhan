local huojiFireAttack = fk.CreateSkill {
  name = "wzzz_v__pangtong__huoji_fire_attack_skill",
}

Fk:loadTranslationTable {
  ["wzzz_v__pangtong__huoji_fire_attack_skill"] = "火攻",
  ["#wzzz_v__pangtong__huoji-discard"] = "火计：你可弃置一张%arg手牌，对 %src 造成1点火焰伤害",
}

huojiFireAttack:addEffect("cardskill", {
  prompt = "#fire_attack_skill",
  can_use = Util.CanUse,
  target_num = 1,
  mod_target_filter = function(self, _, to_select, _, _, _)
    return not to_select:isKongcheng()
  end,
  target_filter = Util.CardTargetFilter,
  on_effect = function(self, room, effect)
    local from = effect.from
    local to = effect.to
    if to:isKongcheng() then return end

    local showCard = room:askToChooseCard(from, {
      target = to,
      flag = "h",
      skill_name = "wzzz_v__pangtong__huoji",
    })
    to:showCards(showCard)
    if from.dead or to.dead or not table.contains(to:getCardIds("h"), showCard) then return end

    local showColor = Fk:getCardById(showCard).color
    local discardable = table.filter(from:getCardIds("h"), function(id)
      local card = Fk:getCardById(id)
      return card.color == showColor and not from:prohibitDiscard(card)
    end)
    if #discardable == 0 then return end

    local colorText = showColor == Card.Red and "红色" or "黑色"
    local cards = room:askToCards(from, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = "wzzz_v__pangtong__huoji",
      cancelable = true,
      pattern = tostring(Exppattern { id = discardable }),
      prompt = "#wzzz_v__pangtong__huoji-discard:" .. to.id .. "::" .. colorText,
    })
    if #cards == 0 then return end

    room:throwCard(cards, "wzzz_v__pangtong__huoji", from, from)
    if not to.dead then
      room:damage {
        from = from,
        to = to,
        card = effect.card,
        damage = 1,
        damageType = fk.FireDamage,
        skillName = "wzzz_v__pangtong__huoji",
      }
    end
  end,
})

return huojiFireAttack
