local wzzz_v__qingyu = fk.CreateSkill {
  name = "wzzz_v__qingyu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__qingyu"] = "清玉",
  [":wzzz_v__qingyu"] = "锁定技，当你受到伤害时，若你的牌数不小于2，则你须弃置两张牌并防止此伤害。",

  ["#wzzz_v__qingyu-discard"] = "清玉：弃置两张牌并防止你受到的伤害",

  ["$wzzz_v__qingyu1"] = "大家之韵，不可失之。",
  ["$wzzz_v__qingyu2"] = "朱沉玉没，桂殒兰凋。",
  ["$wzzz_v__qingyu3"] = "冰清玉粹，岂可有污！",
}

wzzz_v__qingyu:addEffect(fk.DetermineDamageInflicted, {
  can_trigger = function(self, event, target, player, data)
    if target ~= player or not player:hasSkill(wzzz_v__qingyu.name) then return false end
    return #table.filter(player:getCardIds("he"), function(id)
      return not player:prohibitDiscard(id)
    end) > 1
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:broadcastSkillInvoke(wzzz_v__qingyu.name, 3)
    room:notifySkillInvoked(player, wzzz_v__qingyu.name, "defensive")
    room:askToDiscard(player, {
      min_num = 2,
      max_num = 2,
      include_equip = true,
      skill_name = wzzz_v__qingyu.name,
      cancelable = false,
      prompt = "#wzzz_v__qingyu-discard",
    })
    data:preventDamage()
  end,
})

return wzzz_v__qingyu
