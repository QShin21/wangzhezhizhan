local huojiFireAttack = fk.CreateSkill {
  name = "wzzz_v__ol_ex__huoji_fire_attack_skill",
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__huoji_fire_attack_skill"] = "火攻",
  ["#wzzz_v__ol_ex__huoji-discard"] = "火计：你可弃置一张与展示牌同花色的牌，对 %src 造成1点火焰伤害",
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

    local showCard = room:askToCards(to, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = huojiFireAttack.name,
      cancelable = false,
      pattern = ".|.|.|hand",
      prompt = "#fire_attack-show:" .. from.id,
    })[1]
    local suit = Fk:getCardById(showCard):getSuitString()
    to:showCards(showCard)

    local discardable = table.filter(from:getCardIds("h"), function(id)
      local card = Fk:getCardById(id)
      return card:getSuitString() == suit and not from:prohibitDiscard(card)
    end)
    local pile = {}
    local n = math.max(0, 4 - from:getMark("wzzz_v__ol_ex__huoji_damage-turn"))
    for _, id in ipairs(room.draw_pile) do
      if #pile == n then break end
      table.insert(pile, id)
      if Fk:getCardById(id):getSuitString() == suit then
        table.insertIfNeed(discardable, id)
      end
    end
    if #discardable == 0 then return end

    local cards = room:askToCards(from, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = "wzzz_v__ol_ex__huoji",
      cancelable = true,
      pattern = tostring(Exppattern { id = discardable }),
      expand_pile = pile,
      prompt = "#wzzz_v__ol_ex__huoji-discard:" .. to.id,
    })
    if #cards == 0 then return end

    if table.contains(from:getCardIds("h"), cards[1]) then
      room:throwCard(cards, "wzzz_v__ol_ex__huoji", from, from)
    else
      room:moveCardTo(cards, Card.DiscardPile, nil, fk.ReasonPutIntoDiscardPile, "wzzz_v__ol_ex__huoji", nil, nil, from)
    end
    if not to.dead then
      room:damage {
        from = from,
        to = to,
        card = effect.card,
        damage = 1,
        damageType = fk.FireDamage,
        skillName = "wzzz_v__ol_ex__huoji",
      }
    end
  end,
})

return huojiFireAttack
