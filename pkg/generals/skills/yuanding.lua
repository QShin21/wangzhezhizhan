local yuanding = fk.CreateSkill {
  name = "wzzz__yuanding",
  tags = { Skill.Compulsory },
}

local YUANDING_LIMIT_MARK = "wzzz__yuanding_liangzhu"
local YUANDING_USED_MARK = "wzzz__yuanding_liangzhu_used"

WzzzYuanding = WzzzYuanding or {}

function WzzzYuanding.liangzhuAvailable(player)
  return player:getMark(YUANDING_LIMIT_MARK) == 0 or
    (player:getMark(YUANDING_USED_MARK) == 0 and player:usedSkillTimes("wzzz_v__liangzhu", Player.HistoryGame) == 0)
end

function WzzzYuanding.sealLiangzhu(player)
  if player:getMark(YUANDING_LIMIT_MARK) == 0 then return end
  player.room:setPlayerMark(player, YUANDING_USED_MARK, 1)
  player:setSkillUseHistory("wzzz_v__liangzhu", math.max(player:usedSkillTimes("wzzz_v__liangzhu", Player.HistoryGame), 1), Player.HistoryGame)
  player.room:invalidateSkill(player, "wzzz_v__liangzhu", "-game")
end

Fk:loadTranslationTable {
  ["wzzz__yuanding"] = "缘定",
  [":wzzz__yuanding"] = "锁定技，亮将后，你选择其中一项：1.“良助”添加限定技标签；2.失去“结姻”。",
  ["#wzzz__yuanding-choice"] = "缘定：选择令“良助”本局限一次，或失去“结姻”",
}

yuanding:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yuanding.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, yuanding.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choice = room:askToChoice(player, {
      choices = { "wzzz_v__liangzhu", "lose_jieyin" },
      skill_name = yuanding.name,
      prompt = "#wzzz__yuanding-choice",
    })
    if choice == "lose_jieyin" then
      room:handleAddLoseSkills(player, "-wzzz_v__jieyin", nil, false, true)
    else
      room:setPlayerMark(player, YUANDING_LIMIT_MARK, 1)
      room:setPlayerMark(player, YUANDING_USED_MARK, 0)
    end
  end,
})

yuanding:addEffect(fk.AfterSkillEffect, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark(YUANDING_LIMIT_MARK) > 0 and data.skill:getSkeleton().name == "wzzz_v__liangzhu"
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    WzzzYuanding.sealLiangzhu(player)
  end,
})

return yuanding
