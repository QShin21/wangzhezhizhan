local zishu = fk.CreateSkill {
  name = "wzzz_v__mobile__zishu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__mobile__zishu"] = "自书",
  [":wzzz_v__mobile__zishu"] = "锁定技，当你于回合内非因此法而获得牌后，你摸一张牌；其他角色的回合结束后，你弃置X张牌。（X为你本回合获得的牌数）",

  ["@wzzz_v__mobile__zishu-turn"] = "自书",

  ["$wzzz_v__mobile__zishu1"] = "我意已决，诸兄何复多言？",
  ["$wzzz_v__mobile__zishu2"] = "此去如若不成，吾宁殉志而终。",
}

zishu:addEffect(fk.EventPhaseEnd, {
  anim_type = "negative",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(zishu.name) and target ~= player and target.phase == Player.Finish and
      player:getMark("@wzzz_v__mobile__zishu-turn") > 0 and not player:isNude()
  end,
  on_use = function(self, event, target, player, data)
    local n = math.min(player:getMark("@wzzz_v__mobile__zishu-turn"), #player:getCardIds("he"))
    player.room:askToDiscard(player, {
      min_num = n,
      max_num = n,
      include_equip = true,
      skill_name = zishu.name,
      cancelable = false,
    })
  end,
})

zishu:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(zishu.name) and player.room:getCurrent() == player then
      for _, move in ipairs(data) do
        if move.to == player and move.toArea == Player.Hand and move.skillName ~= zishu.name then
          return true
        end
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, zishu.name)
  end,

  can_refresh = function(self, event, target, player, data)
    return player:hasSkill(zishu.name, true) and player.room:getCurrent() ~= player
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    for _, move in ipairs(data) do
      if move.to == player and move.toArea == Player.Hand then
        room:addPlayerMark(player, "@wzzz_v__mobile__zishu-turn", #move.moveInfo)
      end
    end
  end,
})

return zishu
