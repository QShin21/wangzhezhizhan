local wzzz_v__zhitian = fk.CreateSkill{
  name = "wzzz_v__zhitian",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhitian"] = "知天",
  [":wzzz_v__zhitian"] = "出牌阶段，牌堆顶的7张牌对你可见。你的【火攻】结算中，你可观看并选择牌堆顶7张牌中的一张牌代替【火攻】弃牌。",

  ["@[wzzz_v__zhitian]"] = "知天",

  ["$wzzz_v__zhitian1"] = "天火熊熊，再兴炎汉国祚！",
  ["$wzzz_v__zhitian2"] = "地火愔愔，燎尽不臣之贼！",
}

Fk:addQmlMark{
  name = "wzzz_v__zhitian",
  how_to_show = function(name, value, p)
    return tostring(value)
  end,
  qml = function(name, value, p)
    if Self:isBuddy(p) and p.phase == Player.Play and p:hasSkill(wzzz_v__zhitian.name) then
      if type(value) ~= "number" or value < 1 then return {} end
      local drawPile = Fk:currentRoom().draw_pile
      local cards = {}
      for i = 1, math.min(value, #drawPile), 1 do
        table.insert(cards, drawPile[i])
      end
      return {
        uri = "LunarLtk.Pages.InfoPopups",
        name = "wzzz_v__ViewPile",
        prop = {
          ids = cards
        },
      }
    end
    return {}
  end,
}

wzzz_v__zhitian:addEffect(fk.PreCardEffect, {
  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(wzzz_v__zhitian.name) and data.from == player and data.card.trueName == "fire_attack"
  end,
  on_refresh = function(self, event, target, player, data)
    data:changeCardSkill("wzzz_v__zhitian__fire_attack_skill")
  end,
})

wzzz_v__zhitian:addAcquireEffect(function (self, player)
  player.room:setPlayerMark(player, "@[wzzz_v__zhitian]", 7)
end)

wzzz_v__zhitian:addLoseEffect(function (self, player)
  player.room:setPlayerMark(player, "@[wzzz_v__zhitian]", 0)
end)

return wzzz_v__zhitian
