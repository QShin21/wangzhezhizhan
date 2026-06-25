local wzzz_v__cunwei = fk.CreateSkill {
  name = "wzzz_v__cunwei",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__cunwei"] = "存畏",
  [":wzzz_v__cunwei"] = "锁定技，当你成为锦囊牌的目标后，若你：是此牌唯一目标，你摸一张牌；不是此牌唯一目标，你弃置一张牌。",

  ["$wzzz_v__cunwei1"] = "陛下专宠，诸侯畏惧。",
  ["$wzzz_v__cunwei2"] = "君侧之人，众所畏惧。",
}

wzzz_v__cunwei:addEffect(fk.TargetConfirmed, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__cunwei.name) and data.card.type == Card.TypeTrick
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke(wzzz_v__cunwei.name)
    if data:isOnlyTarget(player) then
      room:notifySkillInvoked(player, wzzz_v__cunwei.name, "drawcard")
      player:drawCards(1, wzzz_v__cunwei.name)
    else
      room:notifySkillInvoked(player, wzzz_v__cunwei.name, "negative")
      room:askToDiscard(player, {
        min_num = 1,
        max_num = 1,
        include_equip = true,
        skill_name = wzzz_v__cunwei.name,
        cancelable = false,
      })
    end
  end,
})

return wzzz_v__cunwei
