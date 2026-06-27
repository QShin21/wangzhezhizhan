Fk:loadTranslationTable{
  ["wzzz_v__ex__yiji"] = "遗计",
  [":wzzz_v__ex__yiji"] = "当你受到1点伤害后，你可以摸两张牌，然后你可以将至多两张手牌交给一至两名其他角色。当你每轮首次进入濒死状态时，你可以摸一张牌，然后你可以将一张手牌交给一名其他角色。",

  ["#wzzz_v__ex__yiji-give"] = "遗计：将至多%arg张手牌分配给其他角色",

  ["$wzzz_v__ex__yiji1"] = "锦囊妙策，终定社稷。",
  ["$wzzz_v__ex__yiji2"] = "依此计行，辽东可定。",
}

local yiji = fk.CreateSkill{
  name = "wzzz_v__ex__yiji",
}

yiji:addEffect(fk.Damaged, {
  anim_type = "masochism",
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(2, yiji.name)
    if player.dead or player:isKongcheng() or #room:getOtherPlayers(player, false) == 0 then return end
    room:askToYiji(player, {
      cards = player:getCardIds("h"),
      targets = room:getOtherPlayers(player, false),
      skill_name = yiji.name,
      min_num = 0,
      max_num = 2,
    })
  end
})

yiji:addEffect(fk.EnterDying, {
  anim_type = "masochism",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yiji.name) and
      player:getMark("wzzz_v__ex__yiji_dying-round") == 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:setPlayerMark(player, "wzzz_v__ex__yiji_dying-round", 1)
    player:drawCards(1, yiji.name)
    if player.dead or player:isKongcheng() or #room:getOtherPlayers(player, false) == 0 then return end
    room:askToYiji(player, {
      cards = player:getCardIds("h"),
      targets = room:getOtherPlayers(player, false),
      skill_name = yiji.name,
      min_num = 0,
      max_num = 1,
    })
  end,
})

return yiji
