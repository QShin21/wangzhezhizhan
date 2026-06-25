local wzzz_v__bushi = fk.CreateSkill{
  name = "wzzz_v__bushi",
}

Fk:loadTranslationTable{
  ["wzzz_v__bushi"] = "布施",
  [":wzzz_v__bushi"] = "当你受到1点伤害，或当一名角色受到你造成的1点伤害后，受到伤害的角色可以获得一张“米”。",

  ["#wzzz_v__bushi-invoke"] = "布施：你可以获得 %src 的一张“米”",

  ["$wzzz_v__bushi1"] = "布施行善，乃道义之本。",
  ["$wzzz_v__bushi2"] = "行布施，得天道。",
}

wzzz_v__bushi:addEffect(fk.Damaged, {
  anim_type = "masochism",
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  can_trigger = function (self, event, target, player, data)
    return player:hasSkill(wzzz_v__bushi.name) and #player:getPile("zhanglu_mi") > 0 and
      (target == player or (data.from == player and not target.dead))
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(target, {
      skill_name = wzzz_v__bushi.name,
      prompt = "#wzzz_v__bushi-invoke:"..player.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = player:getPile("zhanglu_mi")
    if #cards > 1 then
      cards = room:askToChooseCard(target, {
        target = target,
        flag = { card_data = {{ "zhanglu_mi", cards }} },
        skill_name = wzzz_v__bushi.name,
      })
    end
    room:obtainCard(target, cards, true, fk.ReasonJustMove, target, wzzz_v__bushi.name)
  end,
})

return wzzz_v__bushi
