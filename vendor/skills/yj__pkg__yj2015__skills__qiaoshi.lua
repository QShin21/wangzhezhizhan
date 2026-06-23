local qiaoshi = fk.CreateSkill {
  name = "wzzz_v__qiaoshi",
}

Fk:loadTranslationTable{
  ["wzzz_v__qiaoshi"] = "樵拾",
  [":wzzz_v__qiaoshi"] = "其他角色的结束阶段，若其手牌数等于你，你可以与其各摸一张牌。",

  ["#wzzz_v__qiaoshi-invoke"] = "樵拾：你可以与 %dest 各摸一张牌",

  ["$wzzz_v__qiaoshi1"] = "樵前情窦开，君后寻迹来。",
  ["$wzzz_v__qiaoshi2"] = "樵心遇郎君，妾心涟漪生。",
}

qiaoshi:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(qiaoshi.name) and target.phase == Player.Finish and
      not target.dead and player:getHandcardNum() == target:getHandcardNum()
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = qiaoshi.name,
      prompt = "#wzzz_v__qiaoshi-invoke::"..target.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    target:drawCards(1, qiaoshi.name)
    if not player.dead then
      player:drawCards(1, qiaoshi.name)
    end
  end,
})

return qiaoshi
