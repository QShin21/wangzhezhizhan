local yizhuang = fk.CreateSkill {
  name = "wzzz_v__yizhuang",
}

Fk:loadTranslationTable{
  ["wzzz_v__yizhuang"] = "益壮",
  [":wzzz_v__yizhuang"] = "准备阶段，若你的判定区内有牌，你可以对自己造成1点伤害，然后弃置判定区内所有牌。",

  ["#wzzz_v__yizhuang-invoke"] = "益壮：是否对自己造成1点伤害，弃置判定区内所有牌？",
}

yizhuang:addEffect(fk.EventPhaseStart, {
  anim_type = "masochism",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yizhuang.name) and player.phase == Player.Start and
      #player:getCardIds("j") > 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = yizhuang.name,
      prompt = "#wzzz_v__yizhuang-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:damage{
      from = player,
      to = player,
      damage = 1,
      skillName = yizhuang.name,
    }
    if not player.dead and #player:getCardIds("j") > 0 then
      player:throwAllCards("j", yizhuang.name)
    end
  end,
})

return yizhuang
