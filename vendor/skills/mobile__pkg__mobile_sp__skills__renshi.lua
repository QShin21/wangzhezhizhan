local wzzz_v__renshi = fk.CreateSkill {
  name = "wzzz_v__renshi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__renshi"] = "仁释",
  [":wzzz_v__renshi"] = "锁定技，当你每回合第一次受到【杀】造成的伤害时，若你已受伤，你令此【杀】对你的伤害-1并获得之，然后减1点体力上限。",

  ["$wzzz_v__renshi1"] = "巾帼于乱世，只能飘零如尘。",
  ["$wzzz_v__renshi2"] = "还望您可以手下留情！",
}

local SLASH_DAMAGE_MARK = "wzzz_v__renshi_slash_damage-turn"

wzzz_v__renshi:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  can_refresh = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__renshi.name, true) and
      data.card and data.card.trueName == "slash"
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:addPlayerMark(player, SLASH_DAMAGE_MARK, 1)
  end,
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(wzzz_v__renshi.name) and
      player:getMark(SLASH_DAMAGE_MARK) == 1 and
      data.card and
      data.card.trueName == "slash" and
      player:isWounded()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:changeDamage(-1)

    if
      table.every(Card:getIdList(data.card), function(id)
        return room:getCardArea(id) == Card.Processing
      end)
    then
      room:obtainCard(player, data.card, true, fk.ReasonPrey, player, wzzz_v__renshi.name)
    end

    room:changeMaxHp(player, -1)
  end,
})

wzzz_v__renshi:addTest(function(room, me)
  local from = room.players[2]
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, wzzz_v__renshi.name)
    room:useCard { from = from, tos = { me }, card = Fk:cloneCard("slash") }
    room:useCard { from = from, tos = { me }, card = Fk:cloneCard("slash") }
  end)
  lu.assertEquals(me:getMark(SLASH_DAMAGE_MARK), 2)
  lu.assertEquals(me.hp, me.maxHp - 2)
  lu.assertEquals(me.maxHp, 4)
end)

return wzzz_v__renshi
