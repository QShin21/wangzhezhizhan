local yaowu = fk.CreateSkill{
  name = "wzzz_v__ol_ex__yaowu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ol_ex__yaowu"] = "耀武",
  [":wzzz_v__ol_ex__yaowu"] = "锁定技，当你受到伤害时，若对你造成伤害的牌为红色，伤害来源摸一张牌，否则你摸一张牌。",

  ["$wzzz_v__ol_ex__yaowu1"] = "有吾在此，解太师烦忧。",
  ["$wzzz_v__ol_ex__yaowu2"] = "这些杂兵，我有何惧！",
}

yaowu:addEffect(fk.DetermineDamageInflicted, {
  mute = true,
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(yaowu.name) then
      return not (data.card and data.card.color == Card.Red) or (data.from and not data.from.dead)
    end
  end,
  on_use = function(self, event, target, player, data)
    if not (data.card and data.card.color == Card.Red) then
      player.room:notifySkillInvoked(player, yaowu.name, "masochism")
      player:broadcastSkillInvoke(yaowu.name, 1)
      player:drawCards(1, yaowu.name)
    else
      player.room:notifySkillInvoked(player, yaowu.name, "negative")
      player:broadcastSkillInvoke(yaowu.name, 2)
      data.from:drawCards(1, yaowu.name)
    end
  end,
})

return yaowu
