local daizui = fk.CreateSkill {
  name = "wzzz_v__daizui",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__daizui"] = "戴罪",
  [":wzzz_v__daizui"] = "限定技，当你受到致命伤害时，你可以对伤害来源发动一次“盗书”，若本次“盗书”你对其造成了伤害，则防止你受到的致命伤害。",

  ["#wzzz_v__daizui-invoke"] = "戴罪：你可以对 %dest 发动一次“盗书”，若造成伤害则防止此致命伤害",
  ["#wzzz_v__daizui-give"] = "戴罪：交给 %dest 一张非%arg手牌",

  ["$wzzz_v__daizui1"] = "望丞相权且记过，容干将功折罪啊！",
  ["$wzzz_v__daizui2"] = "干，谢丞相不杀之恩！",
}

daizui:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(daizui.name) and
      math.max(0, player.hp) + player.shield <= data.damage and
      data.from and data.from ~= player and not data.from.dead and not data.from:isKongcheng() and
      player:usedSkillTimes(daizui.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = daizui.name,
      prompt = "#wzzz_v__daizui-invoke::"..data.from.id,
    }) then
      local choice = room:askToChoice(player, {
        choices = {"log_spade", "log_club", "log_heart", "log_diamond"},
        skill_name = daizui.name,
      })
      event:setCostData(self, {tos = {data.from}, choice = choice})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local source = data.from
    local choice = event:getCostData(self).choice
    room:sendLog{
      type = "#Choice",
      from = player.id,
      arg = choice,
      toast = true,
    }
    local card = room:askToChooseCard(player, {
      target = source,
      flag = "h",
      skill_name = daizui.name,
    })
    room:obtainCard(player, card, true, fk.ReasonPrey, player, daizui.name)
    if player.dead then return end
    player:showCards(card)
    if Fk:getCardById(card):getSuitString(true) == choice then
      local event_id = room.logic:getCurrentEvent().id
      if not source.dead then
        room:damage{
          from = player,
          to = source,
          damage = 1,
          skillName = daizui.name,
        }
      end
      if #room.logic:getActualDamageEvents(1, function(e)
        return e.data.from == player and e.data.to == source and e.data.skillName == daizui.name
      end, nil, event_id) > 0 then
        data:preventDamage()
      end
    else
      if player.dead or player:isKongcheng() or source.dead then return end
      local others = table.filter(player:getCardIds("h"), function(id)
        return Fk:getCardById(id):getSuitString(true) ~= Fk:getCardById(card):getSuitString(true)
      end)
      if #others > 0 then
        local give = room:askToCards(player, {
          min_num = 1,
          max_num = 1,
          pattern = tostring(Exppattern{ id = others }),
          prompt = "#wzzz_v__daizui-give::"..source.id..":"..Fk:getCardById(card):getSuitString(true),
          skill_name = daizui.name,
          cancelable = false,
        })[1]
        player:showCards(give)
        room:obtainCard(source, give, true, fk.ReasonGive, player, daizui.name)
      else
        player:showCards(player:getCardIds("h"))
      end
    end
  end,
})

return daizui
