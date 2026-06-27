
local fenji = fk.CreateSkill{
  name = "wzzz_v__m_ex__fenji",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__fenji"] = "奋激",
  [":wzzz_v__m_ex__fenji"] = "当一名角色的手牌被另一名角色弃置或获得时，你可以失去1点体力，然后令失去手牌的角色摸两张牌；一名角色的结束阶段，若其没有手牌，你可以失去1点体力，然后令其摸两张牌。",

  ["#wzzz_v__m_ex__fenji-invoke"] = "奋激：是否令 %dest 摸两张牌，你失去1点体力？",

  ["$wzzz_v__m_ex__fenji1"] = "先过我这关！",
  ["$wzzz_v__m_ex__fenji2"] = "浴血奋战，至死方休！",
}

fenji:addEffect(fk.AfterCardsMove, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(fenji.name) or player.hp < 1 then return false end
    local targets = {}
    for _, move in ipairs(data) do
      if move.from and not move.from.dead then
        local byOtherDiscard = move.moveReason == fk.ReasonDiscard and move.proposer and move.proposer ~= move.from
        local byOtherPrey = move.to and move.to ~= move.from and move.toArea == Card.PlayerHand
        if byOtherDiscard or byOtherPrey then
          for _, info in ipairs(move.moveInfo) do
            if info.fromArea == Card.PlayerHand then
              table.insertIfNeed(targets, move.from)
              break
            end
          end
        end
      end
    end
    if #targets > 0 then
      event:setCostData(self, {tos = targets})
      return true
    end
  end,
  on_cost = function(self, event, target, player, data)
    local tos = event:getCostData(self).tos
    if #tos > 1 then
      tos = player.room:askToChoosePlayers(player, {
        targets = tos,
        min_num = 1,
        max_num = 1,
        prompt = "#wzzz_v__m_ex__fenji-invoke",
        skill_name = fenji.name,
        cancelable = true,
      })
    elseif not player.room:askToSkillInvoke(player, {
      skill_name = fenji.name,
      prompt = "#wzzz_v__m_ex__fenji-invoke::"..tos[1].id,
    }) then
      return false
    end
    if #tos > 0 then
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local to = event:getCostData(self).tos[1]
    player.room:loseHp(player, 1, fenji.name)
    if not player.dead and not to.dead then
      to:drawCards(2, fenji.name)
    end
  end,
})

fenji:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(fenji.name) and target.phase == Player.Finish and
      target:isKongcheng() and not target.dead
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = fenji.name,
      prompt = "#wzzz_v__m_ex__fenji-invoke::"..target.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:loseHp(player, 1, fenji.name)
    if not player.dead then
      target:drawCards(2, fenji.name)
    end
  end,
})

return fenji
