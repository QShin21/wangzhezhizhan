local wzzz_v__bingyi = fk.CreateSkill {
  name = "wzzz_v__bingyi"
}

Fk:loadTranslationTable{
  ["wzzz_v__bingyi"] = "秉壹",
  [":wzzz_v__bingyi"] = "结束阶段，你可以展示所有手牌，若均为同一颜色，则你令至多X名角色各摸一张牌（X为你的手牌数）。",

  ["#wzzz_v__bingyi-choose"] = "秉壹：你可以令至多%arg名角色各摸一张牌",

  ["$wzzz_v__bingyi1"] = "公正无私，秉持如一。",
  ["$wzzz_v__bingyi2"] = "诸君看仔细了！",
}

wzzz_v__bingyi:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__bingyi.name) and player.phase == Player.Finish and
      not player:isKongcheng()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = player:getCardIds("h")
    player:showCards(cards)
    if player.dead then return end
    if table.every(cards, function (id)
      return Fk:getCardById(id).color == Fk:getCardById(cards[1]).color
    end) then
      local tos = room:askToChoosePlayers(player, {
        skill_name = wzzz_v__bingyi.name,
        min_num = 1,
        max_num = #cards,
        targets = room.alive_players,
        prompt = "#wzzz_v__bingyi-choose:::"..#cards,
      })
      if #tos > 0 then
        room:sortByAction(tos)
        for _, p in ipairs(tos) do
          if not p.dead then
            p:drawCards(1, wzzz_v__bingyi.name)
          end
        end
      end
    end
  end,
})

return wzzz_v__bingyi
