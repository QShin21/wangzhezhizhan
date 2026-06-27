local changbiao = fk.CreateSkill{
  name = "wzzz_v__changbiao",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable {
  ["wzzz_v__changbiao"] = "长标",
  [":wzzz_v__changbiao"] = "限定技，出牌阶段，你可以将任意张手牌（至少一张）当一张无距离限制的【杀】使用，若此【杀】造成过伤害，出牌阶段结束时，你摸等量的牌。",

  ["#wzzz_v__changbiao"] = "长标：你可以将任意张手牌当【杀】使用",
  ["@wzzz_v__changbiao_draw-phase"] = "长标",

  ["$wzzz_v__changbiao1"] = "长标如虹，以伐蜀汉！",
  ["$wzzz_v__changbiao2"] = "长标在此，谁敢拦我？",
}

changbiao:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "slash",
  prompt = "#wzzz_v__changbiao",
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = math.huge,
    pattern = ".|.|.|^equip",
  },
  view_as = function(self, player, cards)
    if #cards < 1 then return end
    local c = Fk:cloneCard("slash")
    c.skillName = changbiao.name
    c:addSubcards(cards)
    return c
  end,
  before_use = function(self, player, use)
    use.extra_data = use.extra_data or {}
    use.extra_data.changbiao = player
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(changbiao.name, Player.HistoryGame) == 0
  end,
  enabled_at_response = Util.FalseFunc,
})

changbiao:addEffect(fk.EventPhaseEnd, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:getMark("@wzzz_v__changbiao_draw-phase") > 0
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:drawCards(player:getMark("@wzzz_v__changbiao_draw-phase"), "wzzz_v__changbiao")
  end,
})

changbiao:addEffect(fk.CardUseFinished, {
  can_refresh = function(self, event, target, player, data)
    return (data.extra_data or {}).changbiao == player and data.damageDealt and not player.dead
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addPlayerMark(player, "@wzzz_v__changbiao_draw-phase", #data.card.subcards)
  end,
})

changbiao:addEffect("targetmod", {
  bypass_distances =  function(self, player, skill, card, to)
    return table.contains(card.skillNames, changbiao.name)
  end,
})

return changbiao
