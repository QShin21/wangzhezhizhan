local jishi = fk.CreateSkill {
  name = "wzzz_v__jishi",
}

Fk:loadTranslationTable {
  ["wzzz_v__jishi"] = "济世",
  [":wzzz_v__jishi"] = "亮将后，你选择“除疠”和“青囊”中的一个技能添加限定技标签。",
  ["#wzzz_v__jishi-choice"] = "济世：选择本局限一次发动的技能",
}

jishi:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(jishi.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, jishi.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local choices = {}
    if player:hasSkill("wzzz_v__ex__chuli", true) then table.insert(choices, "wzzz_v__ex__chuli") end
    if player:hasSkill("wzzz_v__m_ex__qingnang", true) then table.insert(choices, "wzzz_v__m_ex__qingnang") end
    if #choices > 0 then
      player.room:setPlayerMark(player, "wzzz_v__jishi_limited", player.room:askToChoice(player, {
        choices = choices,
        skill_name = jishi.name,
        prompt = "#wzzz_v__jishi-choice",
      }))
    end
  end,
})

jishi:addEffect(fk.AfterSkillEffect, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("wzzz_v__jishi_limited") == data.skill:getSkeleton().name
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:invalidateSkill(player, player:getMark("wzzz_v__jishi_limited"), "-game")
  end,
})

return jishi
