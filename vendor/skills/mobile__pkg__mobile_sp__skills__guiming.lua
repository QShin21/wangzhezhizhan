local guiming = fk.CreateSkill{
  name = "wzzz_v__guiming",
  tags = { Skill.Lord, Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__guiming"] = "归命",
  [":wzzz_v__guiming"] = "主公技，锁定技，其他吴势力角色于你的摸牌阶段视为已受伤的角色。",

  ["$wzzz_v__guiming1"] = "这是要我命归黄泉吗？",
  ["$wzzz_v__guiming2"] = "这就是末世皇帝的不归路！",
}

guiming:addEffect("targetmod", {
})

return guiming
