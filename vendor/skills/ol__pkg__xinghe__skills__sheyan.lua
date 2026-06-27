local sheyan = fk.CreateSkill{
  name = "wzzz_v__sheyan",
}

Fk:loadTranslationTable{
  ["wzzz_v__sheyan"] = "舍宴",
  [":wzzz_v__sheyan"] = "当你成为普通锦囊牌的目标时，你可以令此牌增加一个无距离限制的目标，若此牌目标数大于1，你可以改为令此牌对其中一个目标无效。",

  ["#wzzz_v__sheyan-choose"] = "舍宴：你可以为%arg增加一个目标，或令其对一个目标无效",

  ["$wzzz_v__sheyan1"] = "公事为重，宴席不去也罢。",
  ["$wzzz_v__sheyan2"] = "还是改日吧。",
}

sheyan:addEffect(fk.TargetConfirming, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(sheyan.name) and data.card:isCommonTrick() and not data.cancelled then
      local targets = data:getExtraTargets({ bypass_distances = true })
      local origin_targets = data.use.tos
      if #origin_targets > 1 then
        table.insertTable(targets, origin_targets)
      end
      if #targets > 0 then
        event:setCostData(self, {extra_data = targets})
        return true
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = event:getCostData(self).extra_data,
      skill_name = sheyan.name,
      prompt = "#wzzz_v__sheyan-choose:::"..data.card:toLogString(),
      cancelable = true,
      extra_data = table.map(data.use.tos, Util.IdMapper),
      target_tip_name = "addandcanceltarget_tip",
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local to = event:getCostData(self).tos[1]
    if table.contains(data.use.tos, to) then
      data:cancelTarget(to)
    else
      data:addTarget(to)
    end
  end,
})

return sheyan
