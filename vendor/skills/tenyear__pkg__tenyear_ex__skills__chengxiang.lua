local chengxiang = fk.CreateSkill {
  name = "wzzz_v__ty_ex__chengxiang",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__chengxiang"] = "称象",
  [":wzzz_v__ty_ex__chengxiang"] = "当你受到伤害后，你可以亮出牌堆顶的四张牌，获得其中任意张点数之和不大于13的牌。若获得的牌点数之和为13，"..
  "你可以复原武将牌或下次发动“称象”亮出牌堆顶五张牌。",
  ["wzzz_v__ty_ex__chengxiang_reset"] = "复原武将牌",
  ["wzzz_v__ty_ex__chengxiang_next"] = "下次亮出五张",

  ["$wzzz_v__ty_ex__chengxiang1"] = "冲有一法，可得其重。",
  ["$wzzz_v__ty_ex__chengxiang2"] = "待我细细算来。",
}

chengxiang:addEffect(fk.Damaged, {
  anim_type = "masochism",
  on_use = function(self, event, target, player, data)
    local room = player.room
    local n = player:getMark("wzzz_v__ty_ex__chengxiang_next")
    room:setPlayerMark(player, "wzzz_v__ty_ex__chengxiang_next", 0)
    local cards = room:getNCards(n > 0 and 5 or 4)
    room:turnOverCardsFromDrawPile(player, cards, chengxiang.name)
    local get = room:askToArrangeCards(player, {
      skill_name = chengxiang.name,
      card_map = {cards},
      prompt = "#chengxiang-choose",
      box_size = 0,
      max_limit = {#cards, #cards},
      min_limit = {0, 1},
      poxi_type = "chengxiang",
      default_choice = {{}, {cards[1]}}
    })[2]
    room:moveCardTo(get, Player.Hand, player, fk.ReasonJustMove, chengxiang.name, nil, true, player)
    room:cleanProcessingArea(cards)
    if not player.dead then
      local n = 0
      for _, id in ipairs(get) do
        n = n + Fk:getCardById(id).number
      end
      if n == 13 then
        local choice = room:askToChoice(player, {
          choices = {"wzzz_v__ty_ex__chengxiang_reset", "wzzz_v__ty_ex__chengxiang_next"},
          skill_name = chengxiang.name,
        })
        if choice == "wzzz_v__ty_ex__chengxiang_reset" then
          player:reset()
        else
          room:setPlayerMark(player, "wzzz_v__ty_ex__chengxiang_next", 1)
        end
      end
    end
  end,
})

return chengxiang
