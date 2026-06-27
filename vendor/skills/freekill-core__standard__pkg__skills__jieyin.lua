local jieyin = fk.CreateSkill {
  name = "wzzz_v__jieyin",
}

jieyin:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__jieyin-active",
  max_phase_use_time = 1,
  card_num = 1,
  target_num = 1,
  card_filter = function(self, player, to_select, selected)
    if #selected > 0 then return false end
    local card = Fk:getCardById(to_select)
    return (card.type == Card.TypeEquip and table.contains(player:getCardIds("he"), to_select)) or
      (table.contains(player:getCardIds("h"), to_select) and not player:prohibitDiscard(to_select))
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    if #selected ~= 0 or #selected_cards ~= 1 or not to_select:isMale() then return false end
    local card = Fk:getCardById(selected_cards[1])
    return card.type ~= Card.TypeEquip or to_select:canMoveCardIntoEquip(selected_cards[1], true)
  end,
  on_use = function(self, room, effect)
    local from = effect.from
    local target = effect.tos[1]
    local card = Fk:getCardById(effect.cards[1])
    if card.type == Card.TypeEquip then
      room:moveCardIntoEquip(target, effect.cards[1], jieyin.name, true, from)
    else
      room:throwCard(effect.cards, jieyin.name, from, from)
    end
    if from.dead or target.dead or from.hp == target.hp then return end
    local higher = from.hp > target.hp and from or target
    local lower = higher == from and target or from
    higher:drawCards(1, jieyin.name)
    if not lower.dead and lower:isWounded() then
      room:recover{
        who = lower,
        num = 1,
        recoverBy = from,
        skillName = jieyin.name,
      }
    end
  end,
})


jieyin:addAI(Fk.Ltk.AI.newActiveStrategy {
  think = function(self, ai)
    local cards = ai:getEnabledCards()
    local targets = ai:getEnabledTargets()
    if #cards == 0 or #targets == 0 then return {}, -1000 end

    cards = table.filter(cards, function(id)
      return ai:getCardValue(id, "use_value") < 45 and ai:getCardValue(id, "keep_value") < 45
    end)
    if #cards == 0 then return {}, -1000 end
    local use_card = cards[1]
    local benefits = {}

    for _, target in ipairs(targets) do
      local benefit = ai:getBenefitOfEvents(function(logic)
        if Fk:getCardById(use_card).type ~= Card.TypeEquip then
          logic:throwCard(use_card, jieyin.name, ai.player, ai.player)
        end
        local higher = ai.player.hp > target.hp and ai.player or target
        local lower = higher == ai.player and target or ai.player
        logic:drawCards(higher, 1, jieyin.name)
        logic:recover {
          who = lower,
          num = 1,
          recoverBy = ai.player,
          skillName = jieyin.name,
        }
      end)
      benefits[#benefits + 1] = { target, benefit }
    end

    table.sort(benefits, function(a, b) return a[2] > b[2] end)
    if #benefits == 0 then return {}, -1000 end

    return { { use_card }, { benefits[1][1] } }, benefits[1][2]
  end,
})

return jieyin
