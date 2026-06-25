local qicai = fk.CreateSkill{
  name = "wzzz_v__qicai",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__qicai"] = "奇才",
  [":wzzz_v__qicai"] = "锁定技，你使用锦囊牌无距离限制；其他角色弃置你装备区里的防具牌时，取消之。",
}

qicai:addEffect("targetmod", {
  bypass_distances = function(self, player, skill, card)
    return player:hasSkill(qicai.name) and card and card.type == Card.TypeTrick
  end,
})

qicai:addEffect(fk.BeforeCardsMove, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(qicai.name) then return false end
    for _, move in ipairs(data) do
      if move.from == player and move.moveReason == fk.ReasonDiscard and
        move.proposer and move.proposer ~= player then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerEquip and Fk:getCardById(info.cardId).sub_type == Card.SubtypeArmor then
            return true
          end
        end
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    for _, move in ipairs(data) do
      if move.from == player and move.moveReason == fk.ReasonDiscard and
        move.proposer and move.proposer ~= player then
        local moveInfo = {}
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea ~= Card.PlayerEquip or Fk:getCardById(info.cardId).sub_type ~= Card.SubtypeArmor then
            table.insert(moveInfo, info)
          end
        end
        move.moveInfo = moveInfo
      end
    end
  end,
})

qicai:addTest(function(room, me)
  FkTest.runInRoom(function()
    room:handleAddLoseSkills(me, "wzzz_v__qicai")
  end)

  local snatch = Fk:cloneCard("supply_shortage")
  lu.assertIsTrue(table.every(room:getOtherPlayers(me, false), function (other)
    return me:canUseTo(snatch, other)
  end))
end)

return qicai
