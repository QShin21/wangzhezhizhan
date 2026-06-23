local yuanding = fk.CreateSkill {
  name = "wzzz__yuanding",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz__yuanding"] = "缘定",
  [":wzzz__yuanding"] = "锁定技，亮将后，你选择其中一项：1.“良助”添加限定技标签；2.失去“结姻”。",
}

yuanding:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data) return player:hasSkill(yuanding.name) end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choice = room:askToChoice(player, { choices = { "wzzz_v__liangzhu", "lose_jieyin" }, skill_name = yuanding.name })
    if choice == "lose_jieyin" then
      room:handleAddLoseSkills(player, "-wzzz_v__ex__jieyin", nil, false, true)
    else
      room:setPlayerMark(player, "wzzz__yuanding_liangzhu", 1)
    end
  end,
})

yuanding:addEffect(fk.AfterSkillEffect, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("wzzz__yuanding_liangzhu") > 0 and data.skill:getSkeleton().name == "wzzz_v__liangzhu"
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:invalidateSkill(player, "wzzz_v__liangzhu", "-game")
  end,
})

return yuanding
