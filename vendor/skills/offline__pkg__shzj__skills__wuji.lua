local wuji = fk.CreateSkill{
  name = "wzzz_v__shzj_guansuo__wuji",
  tags = { Skill.Wake },
}

Fk:loadTranslationTable{
  ["wzzz_v__shzj_guansuo__wuji"] = "武继",
  [":wzzz_v__shzj_guansuo__wuji"] = "觉醒技，结束阶段，若你于此回合内造成过至少3点伤害，你加1点体力上限并回复1点体力，然后选择一项：1.获得“偃月”，失去“虎啸”并摸两张牌，然后可以弃置你装备区里的武器牌；2.获得“武圣”并摸一张牌。",

  ["wzzz_v__shzj_guansuo__wuji_yanyue"] = "获得“偃月”",
  ["wzzz_v__shzj_guansuo__wuji_wusheng"] = "获得“武圣”",
  ["#wzzz_v__shzj_guansuo__wuji-discard"] = "武继：你可以弃置装备区里的武器牌",

  ["$wzzz_v__shzj_guansuo__wuji1"] = "每逢佳节，报仇之心益切！",
  ["$wzzz_v__shzj_guansuo__wuji2"] = "继父之武，承父之志！",
}

wuji:addEffect(fk.EventPhaseStart, {
  anim_type = "special",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wuji.name) and player.phase == Player.Finish and
      player:usedSkillTimes(wuji.name, Player.HistoryGame) == 0
  end,
  can_wake = function(self, event, target, player, data)
    local n = 0
    player.room.logic:getActualDamageEvents(1, function(e)
      local damage = e.data
      n = n + damage.damage
      return n > 2
    end, Player.HistoryTurn)
    return n > 2
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:changeMaxHp(player, 1)
    if player.dead then return end
    if player:isWounded() then
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = wuji.name,
      }
      if player.dead then return end
    end
    local choice = room:askToChoice(player, {
      choices = {"wzzz_v__shzj_guansuo__wuji_yanyue", "wzzz_v__shzj_guansuo__wuji_wusheng"},
      skill_name = wuji.name,
    })
    if choice == "wzzz_v__shzj_guansuo__wuji_yanyue" then
      room:handleAddLoseSkills(player, "wzzz_s__5043_6708|-wzzz_v__ol__huxiao", nil, false, true)
      if player.dead then return end
      player:drawCards(2, wuji.name)
      if player.dead then return end
      local weapons = player:getEquipments(Card.SubtypeWeapon)
      if #weapons > 0 and room:askToSkillInvoke(player, {
        skill_name = wuji.name,
        prompt = "#wzzz_v__shzj_guansuo__wuji-discard",
      }) then
        room:throwCard(weapons[1], wuji.name, player, player)
      end
    else
      room:handleAddLoseSkills(player, "wzzz_v__wusheng", nil, false, true)
      if not player.dead then
        player:drawCards(1, wuji.name)
      end
    end
  end,
})

return wuji
