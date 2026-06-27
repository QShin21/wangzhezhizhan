local pozhu = fk.CreateSkill{
  name = "wzzz_v__pozhu",
}

Fk:loadTranslationTable{
  ["wzzz_v__pozhu"] = "破竹",
  [":wzzz_v__pozhu"] = "出牌阶段，你可以弃置一张手牌，并展示一名其他角色的手牌，若展示牌与你弃置的牌花色不同，你对其造成1点伤害，然后此技能失效。",

  ["#wzzz_v__pozhu"] = "破竹：弃置一张手牌并令一名其他角色展示一张手牌",
  ["#wzzz_v__pozhu-show"] = "破竹：展示一张手牌",

  ["$wzzz_v__pozhu1"] = "攻其不备，摧枯拉朽！",
  ["$wzzz_v__pozhu2"] = "势如破竹，铁锁横江亦难挡！",
}

pozhu:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__pozhu",
  card_num = 1,
  target_num = 1,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and table.contains(player:getCardIds("h"), to_select) and
      not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local discarded = effect.cards[1]
    local suit = Fk:getCardById(discarded).suit
    room:throwCard(effect.cards, pozhu.name, player, player)
    if not target.dead and not target:isKongcheng() then
      local shown = room:askToCards(target, {
        min_num = 1,
        max_num = 1,
        include_equip = false,
        skill_name = pozhu.name,
        prompt = "#wzzz_v__pozhu-show",
        cancelable = false,
      })
      target:showCards(shown)
      if not player.dead and not target.dead and Fk:getCardById(shown[1]).suit ~= suit then
        room:damage{
          from = player,
          to = target,
          damage = 1,
          skillName = pozhu.name,
        }
      end
    end
    if not player.dead then
      room:invalidateSkill(player, pozhu.name, "-turn")
    end
  end,
})

return pozhu
