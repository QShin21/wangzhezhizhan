local gongxin = fk.CreateSkill {
  name = "wzzz_v__gongxin",
}

Fk:loadTranslationTable{
  ["wzzz_v__gongxin"] = "攻心",
  [":wzzz_v__gongxin"] = "出牌阶段限一次，你可以观看一名其他角色的手牌并可以展示其中的一张<font color='red'>♥</font>牌，"..
  "选择：1.弃置此牌；2.将此牌置于牌堆顶。",

  ["#wzzz_v__gongxin"] = "攻心：观看一名其他角色的手牌",
  ["#wzzz_v__gongxin-view"] = "攻心：观看%dest的手牌",
  ["wzzz_v__gongxin_discard"] = "弃置此牌",
  ["wzzz_v__gongxin_put"] = "将此牌置于牌堆顶",

  ["$wzzz_v__gongxin1"] = "攻城为下，攻心为上。",
  ["$wzzz_v__gongxin2"] = "我替施主把把脉。",
}

gongxin:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__gongxin",
  target_num = 1,
  card_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(gongxin.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local cards = target:getCardIds("h")
    local hearts = table.filter(cards, function (id)
      return Fk:getCardById(id).suit == Card.Heart
    end)
    local ids, choice = room:askToChooseCardsAndChoice(player, {
      cards = hearts,
      choices = {"wzzz_v__gongxin_discard", "wzzz_v__gongxin_put"},
      skill_name = gongxin.name,
      prompt = "#wzzz_v__gongxin-view::" .. target.id,
      cancel_choices = {"Cancel"},
      min_num = 1,
      max_num = 1,
      all_cards = cards
    })
    if choice == "wzzz_v__gongxin_discard" then
      room:throwCard(ids, gongxin.name, target, player)
    elseif choice == "wzzz_v__gongxin_put" then
      room:moveCardTo(ids, Card.DrawPile, nil, fk.ReasonPut, gongxin.name, nil, true)
    end
  end,
})

return gongxin
