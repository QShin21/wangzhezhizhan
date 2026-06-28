local huoshou = fk.CreateSkill {
  name = "wzzz_v__huoshou",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__huoshou"] = "祸首",
  [":wzzz_v__huoshou"] = "锁定技，【南蛮入侵】对你无效；其他角色使用【南蛮入侵】指定目标后，你代替其成为此牌伤害来源。出牌阶段结束时，若你有手牌，你须弃置所有手牌并视为使用一张【南蛮入侵】。",

  ["$wzzz_v__huoshou1"] = "背黑锅我来，送死？你去！",
  ["$wzzz_v__huoshou2"] = "通通算我的！",
}

huoshou:addEffect(fk.PreCardEffect, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(huoshou.name) and data.card.trueName == "savage_assault" and data.to == player
  end,
  on_use = function (self, event, target, player, data)
    data.nullified = true
  end,
})
huoshou:addEffect(fk.TargetSpecified, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target ~= player and player:hasSkill(huoshou.name) and data.card.trueName == "savage_assault" and data.firstTarget
  end,
  on_use = function(self, event, target, player, data)
    data.extra_data = data.extra_data or {}
    data.extra_data.huoshou = player.id
  end,
})
huoshou:addEffect(fk.PreDamage, {
  can_refresh = function(self, event, target, player, data)
    if data.card and data.card.trueName == "savage_assault" then
      local e = player.room.logic:getCurrentEvent():findParent(GameEvent.UseCard)
      if e then
        local use = e.data
        return use.extra_data and use.extra_data.huoshou
      end
    end
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    local e = room.logic:getCurrentEvent():findParent(GameEvent.UseCard)
    if e then
      local use = e.data
      local from = room:getPlayerById(use.extra_data.huoshou)
      data.from = not from.dead and from or nil
    end
  end,
})

huoshou:addEffect(fk.EventPhaseEnd, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(huoshou.name) and player.phase == Player.Play and
      not player:isKongcheng()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:throwCard(player:getCardIds("h"), huoshou.name, player, player)
    if not player.dead then
      local card = Fk:cloneCard("savage_assault")
      card.skillName = huoshou.name
      room:useCard{
        from = player,
        tos = {},
        card = card,
        extraUse = true,
      }
    end
  end,
})

return huoshou
