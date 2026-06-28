local canshi = fk.CreateSkill{
  name = "wzzz_v__ol__canshi",
}

Fk:loadTranslationTable{
  ["wzzz_v__ol__canshi"] = "残蚀",
  [":wzzz_v__ol__canshi"] = "摸牌阶段，你可以改为摸X张牌（X为已受伤的角色数且至少为4）。若如此做，当你本回合内使用非装备牌时，你弃置一张牌。",

  ["$wzzz_v__ol__canshi1"] = "君王治政，岂容他人置喙？",
  ["$wzzz_v__ol__canshi2"] = "怀怒肆威暴，何人敢不从！",
}

canshi:addEffect(fk.DrawNCards, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(canshi.name)
  end,
  on_use = function(self, event, target, player, data)
    data.n = math.max(4, #table.filter(player.room.alive_players, function (p)
      return p:isWounded() or (player:hasSkill("wzzz_v__guiming") and p.kingdom == "wu")
    end))
  end,
})
canshi:addEffect(fk.CardUsing, {
  anim_type = "negative",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and data.card.type ~= Card.TypeEquip and
      player:usedSkillTimes(canshi.name, Player.HistoryTurn) > 0 and
      not player:isNude() and not player.dead
  end,
  on_use = function(self, event, target, player, data)
    player.room:askToDiscard(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = canshi.name,
      cancelable = false,
    })
  end,
})

return canshi
