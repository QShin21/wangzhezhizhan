local qinglong = fk.CreateSkill { name = "wzzz__qinglong" }

Fk:loadTranslationTable {
  ["wzzz__qinglong"] = "青龙",
  [":wzzz__qinglong"] = "当你使用的【杀】被目标角色使用的【闪】抵消时，你可以对其使用一张红色的【杀】（有距离限制）。",
  ["#wzzz__qinglong-use"] = "青龙：你可以对 %dest 使用一张红色【杀】",
}

qinglong:addEffect(fk.CardEffectCancelledOut, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(qinglong.name) and data.card.trueName == "slash" and not data.to.dead
  end,
  on_cost = function(self, event, target, player, data)
    local use = player.room:askToUseCard(player, {
      pattern = "slash|.|heart,diamond", prompt = "#wzzz__qinglong-use::" .. data.to.id,
      skill_name = qinglong.name, cancelable = true, extra_data = { exclusive_targets = { data.to.id } },
    })
    if use then event:setCostData(self, use); return true end
  end,
  on_use = function(self, event, target, player, data)
    local use = event:getCostData(self)
    use.extraUse = true
    player.room:useCard(use)
  end,
})

return qinglong
