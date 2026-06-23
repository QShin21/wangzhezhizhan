local shuzhi = fk.CreateSkill {
  name = "wzzz__shuzhi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz__shuzhi"] = "述志",
  [":wzzz__shuzhi"] = "锁定技，亮将后，你选择“奸雄”和“清正”中的一个技能添加限定技标签。",
  ["#wzzz__shuzhi-choice"] = "述志：选择本局限一次发动的技能",
}

shuzhi:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(shuzhi.name)
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local choices = {}
    if player:hasSkill("wzzz_v__ex__jianxiong", true) then table.insert(choices, "wzzz_v__ex__jianxiong") end
    if player:hasSkill("wzzz_v__mou__qingzheng", true) then table.insert(choices, "wzzz_v__mou__qingzheng") end
    if #choices > 0 then
      player.room:setPlayerMark(player, "wzzz__shuzhi_limited", player.room:askToChoice(player, {
        choices = choices,
        skill_name = shuzhi.name,
        prompt = "#wzzz__shuzhi-choice",
      }))
    end
  end,
})

shuzhi:addEffect(fk.AfterSkillEffect, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("wzzz__shuzhi_limited") == data.skill:getSkeleton().name
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:invalidateSkill(player, player:getMark("wzzz__shuzhi_limited"), "-game")
  end,
})

return shuzhi
