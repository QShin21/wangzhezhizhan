local jugu = fk.CreateSkill{
  name = "wzzz_v__jugu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__jugu"] = "巨贾",
  [":wzzz_v__jugu"] = "锁定技，你的手牌上限+X；游戏开始时，你摸X张牌。（X为你的体力上限）",

  ["$wzzz_v__jugu1"] = "钱？要多少有多少。",
  ["$wzzz_v__jugu2"] = "君子爱财，取之有道。",
}

jugu:addEffect(fk.GameStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jugu.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, jugu.name))
  end,
  on_use = function(self, event, target, player, data)
    player.room:drawCards(player, player.maxHp, jugu.name)
  end,
})
jugu:addEffect("maxcards", {
  correct_func = function(self, player)
    if player:hasSkill(jugu.name) then
      return player.maxHp
    end
  end,
})

return jugu
