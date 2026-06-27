local baobian = fk.CreateSkill {
  name = "wzzz_v__ty__baobian",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__baobian"] = "豹变",
  [":wzzz_v__ty__baobian"] = "锁定技，当你受到伤害后，你依次获得以下技能：“挑衅”“咆哮”“神速”。",

  ["$wzzz_v__ty__baobian1"] = "豹变分奇略，虎视肃戎威！",
  ["$wzzz_v__ty__baobian2"] = "穷通须豹变，撄搏笑狼狞！",
}

baobian:addEffect(fk.Damaged, {
  anim_type = "masochism",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(baobian.name) and
      table.find({"wzzz_v__ol_ex__tiaoxin", "wzzz_v__xiahouba__paoxiao", "wzzz_v__shensu"}, function(s)
        return not player:hasSkill(s, true)
      end)
  end,
  on_use = function(self, event, target, player, data)
    for _, s in ipairs({"wzzz_v__ol_ex__tiaoxin", "wzzz_v__xiahouba__paoxiao", "wzzz_v__shensu"}) do
      if not player:hasSkill(s, true) then
        player.room:handleAddLoseSkills(player, s)
        return
      end
    end
  end,
})

return baobian
