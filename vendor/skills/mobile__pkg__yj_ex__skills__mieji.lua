local mieji = fk.CreateSkill {
  name = "wzzz_v__m_ex__mieji",
}

local U = require "packages.wangzhezhizhan.vendor.modules.utility.utility"

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__mieji"] = "灭计",
  [":wzzz_v__m_ex__mieji"] = "出牌阶段限一次，你可以展示一张武器牌或锦囊牌并置于牌堆顶，然后令一名有手牌的其他角色选择一项："..
    "1.交给你一张锦囊牌；2.依次弃置两张非锦囊牌，若无法弃置第二张牌，则展示所有手牌。",

  ["#wzzz_v__m_ex__mieji-active"] = "灭计：展示一张武器牌或锦囊牌并置于牌堆顶，令一名其他角色选择",
  ["#wzzz_v__m_ex__mieji-choice"] = "灭计：选择交给%src一张锦囊牌，或依次弃置两张非锦囊牌",
  ["wzzz_v__m_ex__mieji_handovertrick"] = "交出一张锦囊牌",
  ["wzzz_v__m_ex__mieji_dis2card"] = "依次弃置两张非锦囊牌",
  ["#wzzz_v__m_ex__mieji-discard"] = "灭计：再选择一张非锦囊牌弃置",

  ["$wzzz_v__m_ex__mieji1"] = "就是要让你无路可走！",
  ["$wzzz_v__m_ex__mieji2"] = "你也逃不了！",
}

mieji:addEffect("active", {
  anim_type = "drawcard",
  prompt = "#wzzz_v__m_ex__mieji-active",
  max_phase_use_time = 1,
  card_num = 1,
  target_num = 1,
  card_filter = function(self, player, to_select, selected)
    if #selected > 0 then return false end
    local card = Fk:getCardById(to_select)
    return card.type == Card.TypeTrick or card.sub_type == Card.SubtypeWeapon
  end,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected_cards > 0 and #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, room, use)
    local player = use.from
    local target = use.tos[1]
    player:showCards(use.cards)
    room:moveCardTo(use.cards, Card.DrawPile, nil, fk.ReasonPut, mieji.name, nil, true, player)
    if target.dead then return end
    local trick_ids = table.filter(target:getCardIds("h"), function (id)
      return Fk:getCardById(id).type == Card.TypeTrick
    end)
    local non_trick_ids = table.filter(target:getCardIds("h"), function (id)
      local card = Fk:getCardById(id)
      return card.type ~= Card.TypeTrick and not target:prohibitDiscard(id)
    end)
    local cards, choice = U.askForCardByMultiPatterns(
      target,
      {
        { tostring(Exppattern{ id = trick_ids }), 1, 1, "wzzz_v__m_ex__mieji_handovertrick" },
        { tostring(Exppattern{ id = non_trick_ids }), 1, 1, "wzzz_v__m_ex__mieji_dis2card" }
      },
      mieji.name,
      false,
      "#wzzz_v__m_ex__mieji-choice:" .. player.id
    )
    if choice == "wzzz_v__m_ex__mieji_handovertrick" then
      room:obtainCard(player, cards, true, fk.ReasonGive, target, mieji.name)
    elseif choice == "wzzz_v__m_ex__mieji_dis2card" then
      room:throwCard(cards, mieji.name, target)
      if target.dead then return end
      local rest = table.filter(target:getCardIds("h"), function (id)
        return Fk:getCardById(id).type ~= Card.TypeTrick and not target:prohibitDiscard(id)
      end)
      if #rest > 0 then
        room:askToDiscard(target, {
          min_num = 1,
          max_num = 1,
          include_equip = false,
          skill_name = mieji.name,
          cancelable = false,
          pattern = tostring(Exppattern{ id = rest }),
          prompt = "#wzzz_v__m_ex__mieji-discard",
        })
      elseif not target:isKongcheng() then
        target:showCards(target:getCardIds("h"))
      end
    end
  end,
})

mieji:addTest(function (room, me)
  local comp2 = room.players[2]
  FkTest.runInRoom(function () room:handleAddLoseSkills(me, mieji.name) end)
  local card = room:printCard("duel", Card.Spade, 1)
  FkTest.setNextReplies(me, {json.encode {
    card = { skill = mieji.name, subcards = {card.id} }, targets = { comp2.id }
  } })
  FkTest.runInRoom(function ()
    room:obtainCard(me, card)
    room:drawCards(comp2, 2)
    GameEvent.Turn:create(TurnData:new(me, "game_rule", { Player.Play })):exec()
  end)
  lu.assertIsTrue(comp2:isKongcheng())
  lu.assertIsTrue(me:isKongcheng())

  local card2 = room:printCard("duel", Card.Spade, 2)
  FkTest.setNextReplies(me, {json.encode {
    card = { skill = mieji.name, subcards = {card.id} }, targets = { comp2.id }
  } })
  FkTest.runInRoom(function ()
    room:obtainCard(me, card)
    room:obtainCard(comp2, card2)
    GameEvent.Turn:create(TurnData:new(me, "game_rule", { Player.Play })):exec()
  end)
  lu.assertIsTrue(comp2:isKongcheng())
  lu.assertEquals(me:getHandcardNum(), 1)
end)

return mieji
