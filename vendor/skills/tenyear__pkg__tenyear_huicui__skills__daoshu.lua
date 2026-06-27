local daoshu = fk.CreateSkill {
  name = "wzzz_v__daoshu",
}

Fk:loadTranslationTable{
  ["wzzz_v__daoshu"] = "盗书",
  [":wzzz_v__daoshu"] = "出牌阶段限一次，你可以选择一名有手牌的其他角色并声明一种花色，然后你获得其一张手牌并展示之，若此牌与你声明的花色：相同，你对其造成1点伤害，“盗书”视为未发动过；不同，你展示一张与此法获得的牌花色不同的手牌并交给该角色（没有则改为展示手牌）。",

  ["#wzzz_v__daoshu"] = "盗书：声明一种花色，获得一名角色的一张手牌",
  ["#wzzz_v__daoshu-give"] = "盗书：交给 %dest 一张非%arg手牌",

  ["$wzzz_v__daoshu1"] = "得此文书，丞相定可高枕无忧。",
  ["$wzzz_v__daoshu2"] = "让我看看，这是什么机密。",
}

daoshu:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__daoshu",
  card_num = 0,
  target_num = 1,
  interaction = UI.ComboBox { choices = {"log_spade", "log_club", "log_heart", "log_diamond"} },
  can_use = function(self, player)
    return player:usedSkillTimes(daoshu.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:sendLog{
      type = "#Choice",
      from = player.id,
      arg = self.interaction.data,
      toast = true,
    }
    local card = room:askToChooseCard(player, {
      target = target,
      flag = "h",
      skill_name = daoshu.name,
    })
    room:obtainCard(player, card, true, fk.ReasonPrey, player, daoshu.name)
    if not player.dead then
      player:showCards(card)
    end
    if Fk:getCardById(card):getSuitString(true) == self.interaction.data then
      if not target.dead then
        room:damage{
          from = player,
          to = target,
          damage = 1,
          skillName = daoshu.name,
        }
      end
      player:addSkillUseHistory(daoshu.name, -1)
    else
      if player.dead or player:isKongcheng() then return end
      local others = table.filter(player:getCardIds("h"), function(id)
        return Fk:getCardById(id):getSuitString(true) ~= Fk:getCardById(card):getSuitString(true)
      end)
      if #others > 0 then
        local cards = room:askToCards(player, {
          min_num = 1,
          max_num = 1,
          pattern = tostring(Exppattern{ id = others }),
          prompt = "#wzzz_v__daoshu-give::"..target.id..":"..Fk:getCardById(card):getSuitString(true),
          skill_name = daoshu.name,
          cancelable = false,
        })[1]
        player:showCards(cards)
        room:obtainCard(target, cards, true, fk.ReasonGive, player, daoshu.name)
      else
        player:showCards(player:getCardIds("h"))
      end
    end
  end,
})

return daoshu
