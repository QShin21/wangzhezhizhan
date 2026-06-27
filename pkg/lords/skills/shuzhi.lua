local shuzhi = fk.CreateSkill {
  name = "wzzz__shuzhi",
  tags = { Skill.Compulsory },
}

local SHUZHI_LIMIT_MARK = "wzzz__shuzhi_limited"
local SHUZHI_USED_MARK = "wzzz__shuzhi_limited_used"

WzzzShuzhi = WzzzShuzhi or {}

function WzzzShuzhi.skillAvailable(player, skillName)
  return player:getMark(SHUZHI_LIMIT_MARK) ~= skillName or
    (player:getMark(SHUZHI_USED_MARK) == 0 and player:usedSkillTimes(skillName, Player.HistoryGame) == 0)
end

function WzzzShuzhi.sealSkill(player, skillName)
  if player:getMark(SHUZHI_LIMIT_MARK) ~= skillName then return end
  player.room:setPlayerMark(player, SHUZHI_USED_MARK, 1)
  player:setSkillUseHistory(skillName, math.max(player:usedSkillTimes(skillName, Player.HistoryGame), 1), Player.HistoryGame)
  player.room:invalidateSkill(player, skillName, "-game")
end

Fk:loadTranslationTable {
  ["wzzz__shuzhi"] = "述志",
  [":wzzz__shuzhi"] = "锁定技，亮将后，你选择“奸雄”和“清正”中的一个技能添加限定技标签。",
  ["#wzzz__shuzhi-choice"] = "述志：选择本局限一次发动的技能",
}

shuzhi:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(shuzhi.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, shuzhi.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local choices = {}
    if player:hasSkill("wzzz_v__ex__jianxiong", true) then table.insert(choices, "wzzz_v__ex__jianxiong") end
    if player:hasSkill("wzzz_v__mou__qingzheng", true) then table.insert(choices, "wzzz_v__mou__qingzheng") end
    if #choices > 0 then
      player.room:setPlayerMark(player, SHUZHI_LIMIT_MARK, player.room:askToChoice(player, {
        choices = choices,
        skill_name = shuzhi.name,
        prompt = "#wzzz__shuzhi-choice",
      }))
      player.room:setPlayerMark(player, SHUZHI_USED_MARK, 0)
    end
  end,
})

shuzhi:addEffect(fk.AfterSkillEffect, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark(SHUZHI_LIMIT_MARK) == data.skill:getSkeleton().name
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    WzzzShuzhi.sealSkill(player, data.skill:getSkeleton().name)
  end,
})

return shuzhi
