local huilei = fk.CreateSkill {
  name = "wzzz_v__huilei",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__huilei"] = "挥泪",
  [":wzzz_v__huilei"] = "锁定技，杀死你的角色弃置所有牌。",

  ["$wzzz_v__huilei1"] = "丞相视某如子，某以丞相为父。",
  ["$wzzz_v__huilei2"] = "谡愿以死安大局。",
}

huilei:addEffect(fk.Death, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(huilei.name, false, true) and
      data.killer and not data.killer.dead
  end,
  on_cost = function (self, event, target, player, data)
    event:setCostData(self, {tos = {data.killer}})
    return true
  end,
  on_use = function(self, event, target, player, data)
    data.killer:throwAllCards("he", huilei.name)
  end
})

return huilei