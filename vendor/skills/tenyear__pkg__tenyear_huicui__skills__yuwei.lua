local yuwei = fk.CreateSkill {
  name = "wzzz_v__yuwei",
  tags = { Skill.Lord, Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__yuwei"] = "余威",
  [":wzzz_v__yuwei"] = "主公技，锁定技，其他群雄角色的回合内，〖诗怨〗改为“每回合每项限两次”。",
}

yuwei:addEffect("visibility", {})

return yuwei
