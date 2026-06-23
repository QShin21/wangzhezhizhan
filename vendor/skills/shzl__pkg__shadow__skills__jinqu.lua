local jinqu = fk.CreateSkill {
  name = "wzzz_v__jinqu",
}

Fk:loadTranslationTable{
  ["wzzz_v__jinqu"] = "进趋",
  [":wzzz_v__jinqu"] = "结束阶段，你可以摸两张牌，然后将手牌弃至X张（X为你本回合发动〖奇制〗的次数）。",

  ["#wzzz_v__jinqu-invoke"] = "进趋：是否摸两张牌，然后将手牌弃至%arg？",

  ["$wzzz_v__jinqu1"] = "建上昶水城，以逼夏口！",
  ["$wzzz_v__jinqu2"] = "通川聚粮，伐吴之业，当步步为营。",
}

jinqu:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jinqu.name) and player.phase == Player.Finish
  end,
  on_cost = function (self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = jinqu.name,
      prompt = "#wzzz_v__jinqu-invoke:::"..player:usedSkillTimes("wzzz_v__qizhi", Player.HistoryTurn)
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(2, jinqu.name)
    if player.dead then return end
    local n = player:getHandcardNum() - player:usedSkillTimes("wzzz_v__qizhi", Player.HistoryTurn)
    if n > 0 then
      player.room:askToDiscard(player, {
        min_num = n,
        max_num = n,
        include_equip = false,
        skill_name = jinqu.name,
        cancelable = false,
      })
    end
  end,
})

return jinqu
