local zhiyi = fk.CreateSkill {
  name = "wzzz_v__zhiyi",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhiyi"] = "执义",
  [":wzzz_v__zhiyi"] = "每名角色的结束阶段，若你本回合使用或打出过基本牌，你可以选择一项：1.摸一张牌；2.视为使用一张本回合你使用或打出过的基本牌。",
  ["#wzzz_v__zhiyi-invoke"] = "执义：你可以摸一张牌或视为使用一张基本牌",
  ["#wzzz_v__zhiyi-use"] = "执义：视为使用一张本回合使用或打出过的基本牌",
  ["wzzz_v__zhiyi_draw"] = "摸一张牌",
  ["wzzz_v__zhiyi_use"] = "视为使用基本牌",

  ["$wzzz_v__zhiyi1"] = "岂可擅退而误国家之功？",
  ["$wzzz_v__zhiyi2"] = "统摄不懈，只为破敌！",
}

zhiyi:addEffect(fk.TurnEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return
      player:hasSkill(zhiyi.name) and
      (
        #player.room.logic:getEventsOfScope(GameEvent.UseCard, 1, function(e)
          local use = e.data
          return use.from == player and use.card.type == Card.TypeBasic
        end, Player.HistoryTurn) > 0 or
        #player.room.logic:getEventsOfScope(GameEvent.RespondCard, 1, function(e)
          local use = e.data
          return use.from == player and use.card.type == Card.TypeBasic
        end, Player.HistoryTurn) > 0
      )
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = zhiyi.name,
      prompt = "#wzzz_v__zhiyi-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    ---@type string
    local skillName = zhiyi.name
    local room = player.room
    if player:getMark("wzzz_v__zhiyi_cards") == 0 then
      room:setPlayerMark(player, "wzzz_v__zhiyi_cards", room:getUniversalCards("b"))
    end

    local names = {}
    room.logic:getEventsOfScope(GameEvent.UseCard, 1, function(e)
      local use = e.data
      if use.from == player and use.card.type == Card.TypeBasic then
        table.insertIfNeed(names, use.card.name)
      end
    end, Player.HistoryTurn)
    room.logic:getEventsOfScope(GameEvent.RespondCard, 1, function(e)
      local use = e.data
      if use.from == player and use.card.type == Card.TypeBasic then
        table.insertIfNeed(names, use.card.name)
      end
    end, Player.HistoryTurn)

    local cards = table.filter(player:getMark("wzzz_v__zhiyi_cards"), function (id)
      return table.contains(names, Fk:getCardById(id).name)
    end)
    local choice = room:askToChoice(player, {
      choices = {"wzzz_v__zhiyi_draw", "wzzz_v__zhiyi_use"},
      skill_name = skillName,
    })
    if choice == "wzzz_v__zhiyi_draw" then
      player:drawCards(1, skillName)
      return
    end
    local use = room:askToUseRealCard(
      player,
      {
        pattern = cards,
        skill_name = skillName,
        prompt = "#wzzz_v__zhiyi-use",
        extra_data = { expand_pile = cards, bypass_times = true },
        skip = true,
      }
    )

    if use then
      local card = Fk:cloneCard(use.card.name)
      card.skillName = skillName
      use = {
        from = player,
        tos = use.tos,
        card = card,
        extraUse = true,
      }
      room:useCard(use)
    end
  end,
})

return zhiyi
