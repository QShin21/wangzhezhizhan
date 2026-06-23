local zili = fk.CreateSkill {
  name = "wzzz_v__zili",
  tags = { Skill.Wake },
}

Fk:loadTranslationTable{
  ["wzzz_v__zili"] = "自立",
  [":wzzz_v__zili"] = "觉醒技，准备阶段，若“权”的数量不小于3，你减1点体力上限并获得技能〖排异〗，然后回复1点体力或摸两张牌。然后你修改〖权计〗。",

  ["$wzzz_v__zili1"] = "时机已到，今日起兵！",
  ["$wzzz_v__zili2"] = "欲取天下，当在此时！"
}

zili:addEffect(fk.EventPhaseStart, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zili.name) and
      player.phase == Player.Start and
      player:usedSkillTimes(zili.name, Player.HistoryGame) == 0
  end,
  can_wake = function(self, event, target, player, data)
    return #player:getPile("m_ex__zhonghui_power") > 2
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:changeMaxHp(player, -1)
    if player.dead then return end
    local choices = {"draw2"}
    if player:isWounded() then
      table.insert(choices, "recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = zili.name
    })
    if choice == "draw2" then
      player:drawCards(2, zili.name)
    else
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = zili.name,
      }
    end
    if player.dead then return end
    room:handleAddLoseSkills(player, "wzzz_v__m_ex__paiyi")
  end,
})

return zili
