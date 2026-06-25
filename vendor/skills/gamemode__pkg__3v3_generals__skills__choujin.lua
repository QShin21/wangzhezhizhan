local choujin = fk.CreateSkill {
  name = "wzzz_v__choujin",
}

Fk:loadTranslationTable{
  ["wzzz_v__choujin"] = "筹进",
  [":wzzz_v__choujin"] = "游戏开始时，你可以令一名其他角色获得“筹进”标记；每回合限一次，一名角色对拥有“筹进”标记的角色造成伤害后，伤害来源可以摸一张牌。",

  ["#wzzz_v__choujin-choose"] = "筹进：你可以令一名其他角色获得“筹进”标记",
  ["#wzzz_v__choujin-draw"] = "筹进：你可以摸一张牌",
  ["@@wzzz_v__choujin"] = "筹进",

  ["$wzzz_v__choujin1"] = "预则立，不预则废！",
  ["$wzzz_v__choujin2"] = "就用你，给我军祭旗！",
}

choujin:addEffect(fk.GameStart, {
  anim_type = "special",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(choujin.name) and #player.room:getOtherPlayers(player, false) > 0 and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, choujin.name))
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local tos = room:askToChoosePlayers(player, {
      targets = room:getOtherPlayers(player, false),
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__choujin-choose",
      skill_name = choujin.name,
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, { tos = tos })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:setPlayerMark(to, "@@wzzz_v__choujin", 1)
    room:setPlayerMark(player, "wzzz_v__choujin_target", to.id)
  end
})

choujin:addEffect(fk.Damage, {
  anim_type = "drawcard",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target and data.to and player:getMark("wzzz_v__choujin_target") == data.to.id and
      player:hasSkill(choujin.name, true) and player:usedEffectTimes(self.name, Player.HistoryTurn) == 0
  end,
  on_cost = function(self, event, target, player, data)
    if target.dead then return false end
    if target.room:askToSkillInvoke(target, {
      skill_name = choujin.name,
      prompt = "#wzzz_v__choujin-draw",
    }) then
      event:setCostData(self, { tos = { target } })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    target:drawCards(1, choujin.name)
  end
})

return choujin
