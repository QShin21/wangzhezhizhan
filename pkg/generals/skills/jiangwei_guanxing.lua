Fk:loadTranslationTable {
  ["wzzz_v__jiangwei__guanxing"] = "观星",
  [":wzzz_v__jiangwei__guanxing"] = "准备阶段，你可以观看牌堆顶的五张牌（若存活角色数小于4则改为三张），然后将这些牌以任意顺序置于牌堆顶或牌堆底。若你将这些牌均置于牌堆底，则结束阶段你可以再发动一次“观星”。",
}

local jiangweiGuanxing = fk.CreateSkill {
  name = "wzzz_v__jiangwei__guanxing",
}

jiangweiGuanxing:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiangweiGuanxing.name) and
      (player.phase == Player.Start or
        (player.phase == Player.Finish and player:getMark("wzzz_v__jiangwei__guanxing-turn") > 0))
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local result = room:askToGuanxing(player, { cards = room:getNCards(#room.alive_players < 4 and 3 or 5) })
    if #result.top == 0 and player.phase == Player.Start then
      room:setPlayerMark(player, "wzzz_v__jiangwei__guanxing-turn", 1)
    end
  end,
})

return jiangweiGuanxing
