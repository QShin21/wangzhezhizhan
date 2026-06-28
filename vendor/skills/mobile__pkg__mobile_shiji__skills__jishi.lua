local jishi = fk.CreateSkill {
  name = "wzzz_v__jishi",
}

local JISHI_LIMIT_MARK = "wzzz_v__jishi_limited"
local JISHI_USED_MARK = "wzzz_v__jishi_limited_used"

WzzzJishi = WzzzJishi or {}

function WzzzJishi.skillAvailable(player, skillName)
  return player:getMark(JISHI_LIMIT_MARK) ~= skillName or
    (player:getMark(JISHI_USED_MARK) == 0 and player:usedSkillTimes(skillName, Player.HistoryGame) == 0)
end

function WzzzJishi.sealSkill(player, skillName)
  if player:getMark(JISHI_LIMIT_MARK) ~= skillName then return end
  player.room:setPlayerMark(player, JISHI_USED_MARK, 1)
  player:setSkillUseHistory(skillName, math.max(player:usedSkillTimes(skillName, Player.HistoryGame), 1), Player.HistoryGame)
  player.room:invalidateSkill(player, skillName, "-game")
end

Fk:loadTranslationTable {
  ["wzzz_v__jishi"] = "济世",
  [":wzzz_v__jishi"] = "亮将后，你选择“除疠”和“青囊”中的一个技能添加限定技标签。",
  ["#wzzz_v__jishi-choice"] = "济世：选择本局限一次发动的技能",
  ["wzzz_v__jishi_limited"] = "济世",
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
      player.room:setPlayerMark(player, JISHI_LIMIT_MARK, player.room:askToChoice(player, {
        choices = choices,
        skill_name = jishi.name,
        prompt = "#wzzz_v__jishi-choice",
      }))
      player.room:setPlayerMark(player, JISHI_USED_MARK, 0)
    end
  end,
})

jishi:addEffect(fk.AfterSkillEffect, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark(JISHI_LIMIT_MARK) == data.skill:getSkeleton().name
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    WzzzJishi.sealSkill(player, data.skill:getSkeleton().name)
  end,
})

return jishi
