local skill_5043_6708 = fk.CreateSkill {
  name = "wzzz_s__5043_6708",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_s__5043_6708"] = "偃月",
  [":" .. "wzzz_s__5043_6708"] = "锁定技，若你的装备区里没有武器牌，你视为装备着【青龙偃月刀】。",
  ["#wzzz_s__5043_6708-use"] = "偃月：你可以对 %dest 再使用一张【杀】",
}

skill_5043_6708:addEffect(fk.CardEffectCancelledOut, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(skill_5043_6708.name) and
      #player:getEquipments(Card.SubtypeWeapon) == 0 and
      data.card.trueName == "slash" and not data.to.dead
  end,
  on_cost = function(self, event, target, player, data)
    local use = player.room:askToUseCard(player, {
      pattern = "slash",
      prompt = "#wzzz_s__5043_6708-use::" .. data.to.id,
      skill_name = skill_5043_6708.name,
      cancelable = true,
      extra_data = { exclusive_targets = { data.to.id } },
    })
    if use then
      event:setCostData(self, use)
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local use = event:getCostData(self)
    use.extraUse = true
    player.room:useCard(use)
  end,
})

return skill_5043_6708
