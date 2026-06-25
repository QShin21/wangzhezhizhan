local wzzz_v__renshi = fk.CreateSkill {
  name = "wzzz_v__renshi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__renshi"] = "仁释",
  [":wzzz_v__renshi"] = "锁定技，当你受到【杀】造成的伤害时，若你已受伤，你防止此伤害，获得此【杀】并减1点体力上限。",

  ["$wzzz_v__renshi1"] = "巾帼于乱世，只能飘零如尘。",
  ["$wzzz_v__renshi2"] = "还望您可以手下留情！",
}

wzzz_v__renshi:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(wzzz_v__renshi.name) and
      data.card and
      data.card.trueName == "slash" and
      player:isWounded()
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    data:preventDamage()

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

return wzzz_v__renshi
