local luanji = fk.CreateSkill {
  name = "wzzz_v__ofl_mou__luanji",
}

Fk:loadTranslationTable{
  ["wzzz_v__ofl_mou__luanji"] = "乱击",
  [":wzzz_v__ofl_mou__luanji"] = "出牌阶段限一次，你可以将两张手牌当【万箭齐发】使用。当其他角色打出【闪】响应你使用的【万箭齐发】时，"..
  "若你的手牌数小于你的手牌上限，你可以摸一张牌。你于回合内杀死一名角色时，本回合手牌上限+2。",

  ["#wzzz_v__ofl_mou__luanji"] = "乱击：你可以将两张手牌当【万箭齐发】使用",

  ["$wzzz_v__ofl_mou__luanji1"] = "翦公孙，平夷患，起高橹，靖四州！",
  ["$wzzz_v__ofl_mou__luanji2"] = "乱箭之下，尽显吾袁门之威！",
}

luanji:addEffect("viewas", {
  anim_type = "offensive",
  prompt = "#wzzz_v__ofl_mou__luanji",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    return #selected < 2 and table.contains(player:getHandlyIds(), to_select)
  end,
  view_as = function(self, player, cards)
    if #cards ~= 2 then return end
    local card = Fk:cloneCard("archery_attack")
    card:addSubcards(cards)
    return card
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(luanji.name, Player.HistoryPhase) == 0
  end,
})

luanji:addEffect(fk.CardResponding, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(luanji.name) and target ~= player and data.card.name == "jink" and
      data.responseToEvent and data.responseToEvent.from == player and
      data.responseToEvent.card.trueName == "archery_attack" and
      player:getHandcardNum() < player:getMaxCards()
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, luanji.name)
  end,
})

luanji:addEffect(fk.Deathed, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(luanji.name) and player.room.current == player and data.killer == player
  end,
  on_use = function(self, event, target, player, data)
    player.room:addPlayerMark(player, "wzzz_v__ofl_mou__luanji-turn", 2)
  end,
})

luanji:addEffect("maxcards", {
  correct_func = function(self, player)
    if player:hasSkill(luanji.name) then
      return player:getMark("wzzz_v__ofl_mou__luanji-turn")
    end
    return 0
  end,
})

luanji:addAI(nil, "vs_skill")

return luanji
