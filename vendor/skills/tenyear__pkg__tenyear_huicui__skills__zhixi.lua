local zhixi = fk.CreateSkill {
  name = "wzzz_v__ty__zhixi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__zhixi"] = "止息",
  [":wzzz_v__ty__zhixi"] = "锁定技，你于出牌阶段内使用【杀】或普通锦囊牌时须弃置一张手牌。",
}

zhixi:addEffect(fk.CardUsing, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhixi.name) and
      player.phase == Player.Play and not player:isKongcheng() and
      (data.card.trueName == "slash" or data.card:isCommonTrick())
  end,
  on_use = function(self, event, target, player, data)
    player.room:askToDiscard(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = zhixi.name,
      cancelable = false,
    })
  end,
})

return zhixi
