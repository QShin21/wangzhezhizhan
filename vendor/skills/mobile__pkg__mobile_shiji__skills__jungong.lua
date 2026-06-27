local jungong = fk.CreateSkill {
  name = "wzzz_v__jungong",
}

Fk:loadTranslationTable{
  ["wzzz_v__jungong"] = "峻攻",
  [":wzzz_v__jungong"] = "出牌阶段，你可以弃置X张牌或失去X点体力，视为使用一张无距离次数限制的【杀】（X为你本阶段此前发动过此技能的次数+1），然后当此【杀】造成伤害后，此技能本回合失效。",

  ["#wzzz_v__jungong"] = "峻攻：你可以执行一项，视为使用一张无距离次数限制的【杀】",
  ["wzzz_v__jungong_discard"] = "弃置%arg张牌",
  ["wzzz_v__jungong_loseHp"] = "失去%arg点体力",

  ["$wzzz_v__jungong1"] = "曹军营守，不能野战，此乃攻敌之机！",
  ["$wzzz_v__jungong2"] = "若此营攻之不下，览何颜面见袁公！",
}

jungong:addEffect("viewas", {
  anim_type = "offensive",
  prompt = "#wzzz_v__jungong",
  interaction = function(self, player)
    local n = player:usedSkillTimes(jungong.name, Player.HistoryPhase) + 1
    local choices = { "wzzz_v__jungong_discard:::"..n }
    if player.hp > 0 then
      table.insert(choices, "wzzz_v__jungong_loseHp:::"..n)
    end
    return UI.ComboBox { choices = choices }
  end,
  card_filter = function(self, player, to_select, selected)
    if self.interaction.data:startsWith("wzzz_v__jungong_discard") then
      return #selected <= player:usedSkillTimes(jungong.name, Player.HistoryPhase) and not player:prohibitDiscard(to_select)
    else
      return false
    end
  end,
  view_as = function(self, player, cards)
    local n = player:usedSkillTimes(jungong.name, Player.HistoryPhase) + 1
    if self.interaction.data:startsWith("wzzz_v__jungong_discard") and
      #cards ~= n then
      return
    end
    local card = Fk:cloneCard("slash")
    card.skillName = jungong.name
    self.extra_data = cards
    self.extra_cost = n
    return card
  end,
  before_use = function(self, player, use)
    local room = player.room
    use.extraUse = true
    if self.extra_data and #self.extra_data > 0 then
      room:throwCard(self.extra_data, jungong.name, player, player)
      self.extra_data = nil
    else
      room:loseHp(player, self.extra_cost or player:usedSkillTimes(jungong.name, Player.HistoryPhase) + 1)
    end
    self.extra_cost = nil
  end,
})
jungong:addEffect(fk.Damage, {
  can_refresh = function (self, event, target, player, data)
    return target == player and not data.chain and data.card and table.contains(data.card.skillNames, "wzzz_v__jungong")
  end,
  on_refresh = function (self, event, target, player, data)
    player.room:invalidateSkill(player, jungong.name, "-turn")
  end,
})
jungong:addEffect("targetmod", {
  bypass_distances = function (self, player, skill, card, to)
    return card and table.contains(card.skillNames, jungong.name)
  end,
  bypass_times = function (self, player, skill, scope, card, to)
    return card and table.contains(card.skillNames, jungong.name)
  end,
})

return jungong
