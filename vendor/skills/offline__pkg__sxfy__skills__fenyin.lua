local fenyin = fk.CreateSkill {
  name = "wzzz_v__sxfy__fenyin",
}

Fk:loadTranslationTable{
  ["wzzz_v__sxfy__fenyin"] = "奋音",
  [":wzzz_v__sxfy__fenyin"] = "当你于回合内使用牌时，若此牌与你本回合使用的上一张牌颜色不同，你可以摸一张牌。",

  ["@wzzz_v__sxfy__fenyin-turn"] = "奋音",
  ["#wzzz_v__sxfy__fenyin-invoke"] = "奋音：是否摸一张牌？",
}

fenyin:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(fenyin.name) and data.extra_data and data.extra_data.wzzz_v__sxfy__fenyin
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = fenyin.name,
      prompt = "#wzzz_v__sxfy__fenyin-invoke",
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, fenyin.name)
  end,
})

fenyin:addEffect(fk.AfterCardUseDeclared, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(fenyin.name, true) and player.phase ~= Player.NotActive
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local color = data.card:getColorString()
    if color == "nocolor" then
      room:setPlayerMark(player, "@wzzz_v__sxfy__fenyin-turn", 0)
    else
      if player:getMark("@wzzz_v__sxfy__fenyin-turn") ~= 0 and color ~= player:getMark("@wzzz_v__sxfy__fenyin-turn") then
        data.extra_data = data.extra_data or {}
        data.extra_data.wzzz_v__sxfy__fenyin = true
      end
      room:setPlayerMark(player, "@wzzz_v__sxfy__fenyin-turn", color)
    end
  end,
})

return fenyin
