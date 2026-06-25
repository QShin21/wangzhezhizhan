local mouJiuyuan = fk.CreateSkill({
  name = "wzzz_v__mou__jiuyuan",
  tags = { Skill.Lord },
})

Fk:loadTranslationTable{
  ["wzzz_v__mou__jiuyuan"] = "救援",
  [":wzzz_v__mou__jiuyuan"] = "主公技，当其他吴势力角色使用【桃】时，你可以摸一张牌。其他吴势力角色对你使用【桃】时，你可以额外回复1点体力。",
  ["#wzzz_v__mou__jiuyuan-draw"] = "救援：是否因 %src 使用【桃】摸一张牌？",
  ["#wzzz_v__mou__jiuyuan-recover"] = "救援：是否令 %src 对你使用的【桃】额外回复1点体力？",

  ["$wzzz_v__mou__jiuyuan1"] = "汝救护有功，吾必当厚赐。",
  ["$wzzz_v__mou__jiuyuan2"] = "诸位将军，快快拦住贼军！",
}

mouJiuyuan:addEffect(fk.PreHpRecover, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(mouJiuyuan.name) and
      data.card and
      data.card.trueName == "peach" and
      data.recoverBy and
      data.recoverBy.kingdom == "wu" and
      data.recoverBy ~= player
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = mouJiuyuan.name,
      prompt = "#wzzz_v__mou__jiuyuan-recover:" .. data.recoverBy.id,
    })
  end,
  on_use = function(self, event, target, player, data)
    data.num = data.num + 1
  end,
})

mouJiuyuan:addEffect(fk.CardUsing, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(mouJiuyuan.name) and target ~= player and target.kingdom == "wu" and data.card.trueName == "peach"
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = mouJiuyuan.name,
      prompt = "#wzzz_v__mou__jiuyuan-draw:" .. target.id,
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, mouJiuyuan.name)
  end,
})

return mouJiuyuan
