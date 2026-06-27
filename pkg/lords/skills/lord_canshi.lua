local lordCanshi = fk.CreateSkill{
  name = "wzzz_lord__ol__canshi",
}

Fk:loadTranslationTable{
  ["wzzz_lord__ol__canshi"] = "残蚀",
  [":wzzz_lord__ol__canshi"] = "摸牌阶段，你可以改为摸X张牌（X为已受伤的角色数且至少为4）。若如此做，当你本回合内使用【杀】或普通锦囊牌时，你弃置一张牌。",

  ["$wzzz_lord__ol__canshi1"] = "君王治政，岂容他人置喙？",
  ["$wzzz_lord__ol__canshi2"] = "怀怒肆威暴，何人敢不从！",
}

lordCanshi:addEffect(fk.DrawNCards, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(lordCanshi.name) and
      table.find(player.room.alive_players, function(p)
        return p:isWounded() or (player:hasSkill("wzzz_v__guiming") and p.kingdom == "wu")
      end)
  end,
  on_use = function(self, event, target, player, data)
    data.n = math.max(4, #table.filter(player.room.alive_players, function(p)
      return p:isWounded() or (player:hasSkill("wzzz_v__guiming") and p.kingdom == "wu")
    end))
  end,
})

lordCanshi:addEffect(fk.CardUsing, {
  anim_type = "negative",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and (data.card.trueName == "slash" or data.card:isCommonTrick()) and
      player:usedSkillTimes(lordCanshi.name, Player.HistoryTurn) > 0 and
      not player:isNude() and not player.dead
  end,
  on_use = function(self, event, target, player, data)
    player.room:askToDiscard(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = lordCanshi.name,
      cancelable = false,
    })
  end,
})

return lordCanshi
