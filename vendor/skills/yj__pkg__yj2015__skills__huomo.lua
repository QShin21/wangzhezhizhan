local wzzz_v__huomo = fk.CreateSkill {
  name = "wzzz_v__huomo",
}

Fk:loadTranslationTable{
  ["wzzz_v__huomo"] = "活墨",
  [":wzzz_v__huomo"] = "当你需要使用基本牌时（你本回合使用过的基本牌除外），你可以展示一张黑色非基本牌并置于牌堆顶，视为使用此基本牌。",

  ["#wzzz_v__huomo"] = "活墨：将一张黑色非基本牌置于牌堆顶，视为使用一张基本牌",

  ["$wzzz_v__huomo1"] = "笔墨写春秋，挥毫退万敌！",
  ["$wzzz_v__huomo2"] = "妙笔在手，研墨在心。",
}

wzzz_v__huomo:addEffect("viewas", {
  pattern = ".|.|.|.|.|basic",
  prompt = "#wzzz_v__huomo",
  interaction = function(self, player)
    local all_names = Fk:getAllCardNames("b")
    local names = player:getViewAsCardNames(wzzz_v__huomo.name, all_names, nil, player:getTableMark("wzzz_v__huomo-turn"))
    if #names == 0 then return end
    return UI.CardNameBox {choices = names, all_names = all_names}
  end,
  filter_pattern = {
    min_num = 0,
    max_num = 0,
    pattern = "",
    subcards = {}
  },
  card_filter = function (self, player, to_select, selected)
    local card = Fk:getCardById(to_select)
    return #selected == 0 and card.type ~= Card.TypeBasic and card.color == Card.Black
  end,
  view_as = function(self, player, cards)
    if not self.interaction.data or #cards ~= 1 then return end
    local card = Fk:cloneCard(self.interaction.data)
    card.skillName = wzzz_v__huomo.name
    card:addFakeSubcards(cards)
    return card
  end,
  before_use = function (self, player, use)
    player:showCards(use.card.fake_subcards)
    player.room:moveCards({
      ids = use.card.fake_subcards,
      from = player,
      toArea = Card.DrawPile,
      moveReason = fk.ReasonPut,
      skillName = wzzz_v__huomo.name,
      proposer = player,
      moveVisible = true,
    })
  end,
  enabled_at_play = function(self, player)
    return not player:isNude()
  end,
  enabled_at_response = function(self, player, response)
    return not response and not player:isNude() and
      #player:getViewAsCardNames(wzzz_v__huomo.name, Fk:getAllCardNames("b"), nil, player:getTableMark("wzzz_v__huomo-turn"))
  end,
})

wzzz_v__huomo:addAcquireEffect(function (self, player, is_start)
  if not is_start and player.room.current == player then
    local room = player.room
    local names = {}
    room.logic:getEventsOfScope(GameEvent.UseCard, 1, function (e)
      local use = e.data
      if use.from == player and use.card.type == Card.TypeBasic then
        table.insertIfNeed(names, use.card.trueName)
      end
    end, Player.HistoryTurn)
    if #names > 0 then
      room:setPlayerMark(player, "wzzz_v__huomo-turn", names)
    end
  end
end)

wzzz_v__huomo:addEffect(fk.AfterCardUseDeclared, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__huomo.name, true) and data.card.type == Card.TypeBasic
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addTableMark(player, "wzzz_v__huomo-turn", data.card.trueName)
  end,
})

wzzz_v__huomo:addAI(nil, "vs_skill")

return wzzz_v__huomo
