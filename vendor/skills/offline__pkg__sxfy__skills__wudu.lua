local wudu = fk.CreateSkill {
  name = "wzzz_v__sxfy__wudu",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__sxfy__wudu"] = "无度",
  [":wzzz_v__sxfy__wudu"] = "限定技，当一名没有手牌的角色受到伤害时，你可以防止此伤害，然后你减1点体力上限。",

  ["#wzzz_v__sxfy__wudu-invoke"] = "无度：是否防止 %dest 受到的伤害，然后你减1点体力上限？",
}

wudu:addEffect(fk.DamageInflicted, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(wudu.name) and target:isKongcheng() and not target.dead and
      player:usedSkillTimes(wudu.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = wudu.name,
      prompt = "#wzzz_v__sxfy__wudu-invoke::"..data.to.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    data:preventDamage()
    player.room:changeMaxHp(player, -1)
  end,
})

return wudu
