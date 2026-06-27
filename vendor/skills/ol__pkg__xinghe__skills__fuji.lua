local fuji = fk.CreateSkill{
  name = "wzzz_v__fuji",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__fuji"] = "伏骑",
  [":wzzz_v__fuji"] = "锁定技，当你使用【杀】或普通锦囊牌时，计算与你距离为2以内的其他角色均不能响应此牌。",

  ["$wzzz_v__fuji1"] = "白马？不足挂齿！",
  ["$wzzz_v__fuji2"] = "掌握之中，岂可逃之？",
}

fuji:addEffect(fk.CardUsing, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(fuji.name) and
      (data.card.trueName == "slash" or data.card:isCommonTrick()) and
      table.find(player.room:getOtherPlayers(player, false), function(p)
        return player:distanceTo(p) <= 2
      end)
  end,
  on_use = function(self, event, target, player, data)
    data.disresponsiveList = data.disresponsiveList or {}
    for _, p in ipairs(player.room:getOtherPlayers(player, false)) do
      if player:distanceTo(p) <= 2 then
        table.insertIfNeed(data.disresponsiveList, p)
      end
    end
  end,
})

return fuji
