local guolun = fk.CreateSkill {
  name = "wzzz_v__guolun",
}

Fk:loadTranslationTable{
  ["wzzz_v__guolun"] = "过论",
  [":wzzz_v__guolun"] = "出牌阶段限一次，你可以展示一名其他角色的一张手牌。若如此做，你可以展示一张手牌交换之，然后你可以选择一项：1.令展示牌点数较小的角色摸一张牌；2.令展示牌点数较大的角色回复1点体力。",

  ["#wzzz_v__guolun"] = "过论：展示一名角色的一张手牌，然后你可以展示一张手牌与其交换",
  ["#wzzz_v__guolun-card"] = "过论：你可以展示一张牌并交换双方的牌（对方点数为%arg）",
  ["wzzz_v__guolun_draw"] = "点数较小的角色摸一张牌",
  ["wzzz_v__guolun_recover"] = "点数较大的角色回复1点体力",

  ["$wzzz_v__guolun1"] = "品过是非，讨评好坏。",
  ["$wzzz_v__guolun2"] = "若有天下太平时，必讨四海之内才。",
}

guolun:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__guolun",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(guolun.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local id1 = room:askToChooseCard(player, {
      target = target,
      flag = "h",
      skill_name = guolun.name
    })
    target:showCards(id1)
    if not target.dead and not player:isNude() and table.contains(target:getCardIds("h"), id1) then
      local n1 = Fk:getCardById(id1).number
      local card = room:askToCards(player, {
        min_num = 1,
        max_num = 1,
        include_equip = false,
        skill_name = guolun.name,
        cancelable = true,
        prompt = "#wzzz_v__guolun-card:::"..n1
      })
      if #card > 0 then
        local id2 = card[1]
        player:showCards(id2)
        local n2 = Fk:getCardById(id2).number
        if player.dead or target.dead or
          not table.contains(player:getCardIds("h"), id2) or
          not table.contains(target:getCardIds("h"), id1) then return end
        room:swapCards(player, {
          {player, {id2}},
          {target, {id1}},
        }, guolun.name)
        local smaller, bigger
        if n2 > n1 then
          smaller, bigger = target, player
        elseif n1 > n2 then
          smaller, bigger = player, target
        end
        if smaller and bigger then
          local choices = { "wzzz_v__guolun_draw", "wzzz_v__guolun_recover", "Cancel" }
          local choice = room:askToChoice(player, {
            choices = choices,
            skill_name = guolun.name,
          })
          if choice == "wzzz_v__guolun_draw" and not smaller.dead then
            smaller:drawCards(1, guolun.name)
          elseif choice == "wzzz_v__guolun_recover" and not bigger.dead and bigger:isWounded() then
            room:recover{
              who = bigger,
              num = 1,
              recoverBy = player,
              skillName = guolun.name,
            }
          end
        end
      end
    end
  end,
})

return guolun
