local shunshi = fk.CreateSkill { name = "wzzz__shunshi" }

Fk:loadTranslationTable {
  ["wzzz__shunshi"] = "顺势",
  [":wzzz__shunshi"] = "（团队模式中失去此技能）当你于回合外因“连营”而获得非基本牌时，你可以展示之并摸一张牌。",
}

shunshi:addEffect(fk.AfterCardsMove, {
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(shunshi.name) or player.phase ~= Player.NotActive then return false end
    for _, move in ipairs(data) do
      if move.to == player and move.toArea == Card.PlayerHand and move.skillName == "lianying" then
        for _, info in ipairs(move.moveInfo) do
          if Fk:getCardById(info.cardId).type ~= Card.TypeBasic then return true end
        end
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, { skill_name = shunshi.name })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, shunshi.name)
  end,
})

return shunshi
