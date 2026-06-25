local wzzz_v__dianjun = fk.CreateSkill{
  name = "wzzz_v__dianjun",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__dianjun"] = "殿军",
  [":wzzz_v__dianjun"] = "锁定技，结束阶段结束时，你受到1点伤害并执行一个额外的出牌阶段。",

  ["$wzzz_v__dianjun1"] = "大将军勿忧，翼可领后军。",
  ["$wzzz_v__dianjun2"] = "诸将速行，某自领军殿后！",
}

wzzz_v__dianjun:addEffect(fk.EventPhaseEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__dianjun.name) and player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    player.room:damage{
      from = player,
      to = player,
      damage = 1,
      skillName = wzzz_v__dianjun.name,
    }
    if player.dead then return false end
    player:gainAnExtraPhase(Player.Play, wzzz_v__dianjun.name)
  end,
})

return wzzz_v__dianjun
