local shiyuan = fk.CreateSkill {
  name = "wzzz_v__shiyuan",
}

Fk:loadTranslationTable{
  ["wzzz_v__shiyuan"] = "诗怨",
  [":wzzz_v__shiyuan"] = "每回合每项限一次，当你成为其他角色使用牌的目标后，若该角色的体力值：大于你，你可以摸两张牌；等于你，你可以摸两张牌；小于你，你可以摸一张牌。",

  ["$wzzz_v__shiyuan1"] = "感怀诗于前，绝怨赋于后。",
  ["$wzzz_v__shiyuan2"] = "汉宫楚歌起，四面无援矣。",
}

shiyuan:addEffect(fk.TargetConfirmed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(shiyuan.name) and data.from ~= player then
      local n = 1
      if player:hasSkill("wzzz_v__yuwei") and player.room.current.kingdom == "qun" then
        n = 2
      end
      return (data.from.hp > player.hp and player:getMark("wzzz_v__shiyuan1-turn") < n) or
        (data.from.hp == player.hp and player:getMark("wzzz_v__shiyuan2-turn") < n) or
        (data.from.hp < player.hp and player:getMark("wzzz_v__shiyuan3-turn") < n)
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if data.from.hp > player.hp then
      room:addPlayerMark(player, "wzzz_v__shiyuan1-turn", 1)
      player:drawCards(2, shiyuan.name)
    elseif data.from.hp == player.hp then
      room:addPlayerMark(player, "wzzz_v__shiyuan2-turn", 1)
      player:drawCards(2, shiyuan.name)
    elseif data.from.hp < player.hp then
      room:addPlayerMark(player, "wzzz_v__shiyuan3-turn", 1)
      player:drawCards(1, shiyuan.name)
    end
  end,
})

shiyuan:addLoseEffect(function (self, player, is_death)
  local room = player.room
  room:setPlayerMark(player, "wzzz_v__shiyuan1-turn", 0)
  room:setPlayerMark(player, "wzzz_v__shiyuan2-turn", 0)
  room:setPlayerMark(player, "wzzz_v__shiyuan3-turn", 0)
end)

return shiyuan
