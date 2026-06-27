
local kunfen = fk.CreateSkill {
  name = "wzzz_v__kunfenEx",
}

Fk:loadTranslationTable{
  ["wzzz_v__kunfenEx"] = "困奋",
  [":wzzz_v__kunfenEx"] = "结束阶段，你可以失去1点体力，然后摸两张牌，且可以视为使用一张【火攻】。",
  ["#wzzz_v__kunfenEx-fire_attack"] = "困奋：你可以视为使用一张【火攻】",

  ["$wzzz_v__kunfenEx1"] = "纵使困顿难行，亦当砥砺奋进！",
  ["$wzzz_v__kunfenEx2"] = "兴蜀需时，众将且勿惫怠！",
}

kunfen:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(kunfen.name) and player.phase == Player.Finish
  end,
  on_use = function(self, event, target, player, data)
    player.room:loseHp(player, 1, kunfen.name)
    if not player.dead then
      player:drawCards(2, kunfen.name)
    end
    if not player.dead then
      player.room:askToUseVirtualCard(player, {
        name = "fire_attack",
        skill_name = kunfen.name,
        prompt = "#wzzz_v__kunfenEx-fire_attack",
        cancelable = true,
        extra_data = {
          bypass_times = true,
          extraUse = true,
        },
      })
    end
  end,
})

return kunfen
