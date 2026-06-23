
local sishu = fk.CreateSkill {
  name = "wzzz_v__sishu",
}

Fk:loadTranslationTable {
  ["wzzz_v__sishu"] = "思蜀",
  [":wzzz_v__sishu"] = "出牌阶段开始时，你可选择一名角色，其本局游戏【乐不思蜀】的判定结果反转。",

  ["#wzzz_v__sishu-choose"] = "思蜀：选择一名角色，令其本局游戏【乐不思蜀】的判定结果反转",
  ["@@wzzz_v__sishu_effect"] = "思蜀",

  ["$wzzz_v__sishu1"] = "蜀乐乡土，怎不思念？",
  ["$wzzz_v__sishu2"] = "思乡心切，徘徊惶惶。",
}

sishu:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(sishu.name) and player.phase == Player.Play
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      targets = room.alive_players,
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__sishu-choose",
      skill_name = sishu.name,
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local to = event:getCostData(self).tos[1]
    player.room:setPlayerMark(to, "@@wzzz_v__sishu_effect", 1 - to:getMark("@@wzzz_v__sishu_effect"))
  end,
})


sishu:addEffect(fk.StartJudge, {
  can_refresh = function(self, event, target, player, data)
    return player:getMark("@@wzzz_v__sishu_effect") > 0 and target == player and data.reason == "indulgence"
  end,
  on_refresh = function(self, event, target, player, data)
    data:reversePattern()
  end,
})

return sishu