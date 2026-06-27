
local tuxi = fk.CreateSkill {
  name = "wzzz_v__tuxi",
}

Fk:loadTranslationTable{
  ["wzzz_v__tuxi"] = "突袭",
  [":wzzz_v__tuxi"] = "你的回合内限两次，当你不以此法获得牌后，你可以弃置至多X张手牌，然后获得至多等量名其他角色各一张手牌（X为你获得的牌数且至多为2，若为本回合第二次发动则改为至多为1）。",
  ["#wzzz_v__tuxi-discard"] = "突袭：你可以弃置至多%arg张手牌，然后获得至多等量名其他角色各一张手牌",
  ["#wzzz_v__tuxi-choose"] = "突袭：获得至多%arg名其他角色各一张手牌",
}

local function gainedNum(player, data)
  local n = 0
  for _, move in ipairs(data) do
    if move.to == player and move.toArea == Card.PlayerHand and move.skillName ~= tuxi.name then
      n = n + #move.moveInfo
    end
  end
  return n
end

tuxi:addEffect(fk.AfterCardsMove, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(tuxi.name) and player.room.current == player and
      player:usedSkillTimes(tuxi.name, Player.HistoryTurn) < 2 and gainedNum(player, data) > 0 and
      not player:isKongcheng() and
      table.find(player.room:getOtherPlayers(player, false), function(p)
        return not p:isKongcheng()
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local n = math.min(gainedNum(player, data), player:usedSkillTimes(tuxi.name, Player.HistoryTurn) == 0 and 2 or 1)
    local cards = room:askToCards(player, {
      min_num = 1,
      max_num = n,
      include_equip = false,
      skill_name = tuxi.name,
      prompt = "#wzzz_v__tuxi-discard:::"..n,
      cancelable = true,
    })
    if #cards == 0 then return false end
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      return not p:isKongcheng()
    end)
    local tos = room:askToChoosePlayers(player, {
      targets = targets,
      min_num = 1,
      max_num = #cards,
      prompt = "#wzzz_v__tuxi-choose:::"..#cards,
      skill_name = tuxi.name,
      cancelable = false,
    })
    if #tos > 0 then
      room:sortByAction(tos)
      event:setCostData(self, { tos = tos, cards = cards })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:throwCard(event:getCostData(self).cards, tuxi.name, player, player)
    for _, p in ipairs(event:getCostData(self).tos) do
      if player.dead then break end
      if not p.dead and not p:isKongcheng() then
        local c = room:askToChooseCard(player, {
          target = p,
          flag = "h",
          skill_name = tuxi.name,
        })
        room:obtainCard(player, c, false, fk.ReasonPrey, player, tuxi.name)
      end
    end
  end,
})

tuxi:addAI(Fk.Ltk.AI.newChoosePlayersStrategy{
  choose_players = function(self, ai)
    return ai:askToChoosePlayers({
      targets = ai:getEnabledTargets(),
      min_num = 0,
      max_num = 2,
      skill_name = tuxi.name,
      benefit_func = function (logic, p)
        local ret, _ = ai:askToChooseCards({
          cards = p:getCardIds("h"),
          skill_name = tuxi.name,
          data = {
            to_place = Card.PlayerHand,
            target = ai.player,
            reason = fk.ReasonPrey,
            proposer = ai.player,
          }
        })
        logic:obtainCard(ai.player, ret, false, fk.ReasonPrey, ai.player, tuxi.name)
      end,
      basic_benefit = -ai:getBenefitOfEvents(function(logic)
        logic:drawCards(ai.player, 2, "phase_draw")
      end),
    })
  end,
})

return tuxi
