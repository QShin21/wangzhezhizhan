local xuanfeng = fk.CreateSkill {
  name = "wzzz_v__m_ex__xuanfeng",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_ex__xuanfeng"] = "旋风",
  [":wzzz_v__m_ex__xuanfeng"] = "当你于弃牌阶段弃置过至少两张牌，或当你失去装备区里的牌后，你可以依次弃置至多两名其他角色共计两张牌。",

  ["#wzzz_v__m_ex__xuanfeng-discard"] = "旋风：你可以选择一名角色，弃置其一张牌",

  ["$wzzz_v__m_ex__xuanfeng1"] = "短兵相接，让敌人丢盔弃甲！",
  ["$wzzz_v__m_ex__xuanfeng2"] = "攻敌不备，看他们闻风而逃！",
}

---@param self TriggerSkill
---@param event TriggerEvent
---@param player ServerPlayer
local xuanfengCost = function(self, event, _, player, _)
  local room = player.room
  local tos = room:askToChoosePlayers(player, {
    min_num = 1,
    max_num = 1,
    targets = table.filter(room.alive_players, function (p)
      return p ~= player and not p:isNude()
    end),
    skill_name = xuanfeng.name,
    prompt = "#wzzz_v__m_ex__xuanfeng-discard",
    cancelable = true,
  })
  if #tos > 0 then
    event:setCostData(self, {tos = tos})
    return true
  end
end

---@param self TriggerSkill
---@param event TriggerEvent
---@param player ServerPlayer
local xuanfengUse = function(self, event, _, player, _)
  local room = player.room
  local dat = event:getCostData(self)
  local to = dat.tos[1]
  local card = room:askToChooseCard(player, {
    target = to,
    flag = "he",
    skill_name = xuanfeng.name,
  })
  room:throwCard(card, xuanfeng.name, to, player)
  if player.dead then return false end
  local tos = table.filter(room.alive_players, function (p)
    return p ~= player and not p:isNude()
  end)
  if #tos == 0 then return false end
  tos = room:askToChoosePlayers(player, {
    min_num = 1,
    max_num = 1,
    targets = tos,
    skill_name = xuanfeng.name,
    prompt = "#wzzz_v__m_ex__xuanfeng-discard",
    cancelable = true,
  })
  if #tos == 0 then return false end
  to = tos[1]
  card = room:askToChooseCard(player, {
    target = to,
    flag = "he",
    skill_name = xuanfeng.name,
  })
  room:throwCard(card, xuanfeng.name, to, player)
end

xuanfeng:addEffect(fk.AfterCardsMove, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(xuanfeng.name) or table.every(player.room.alive_players, function (p)
      return p == player or p:isNude()
    end) then return false end
    for _, move in ipairs(data) do
      if move.from == player then
        for _, info in ipairs(move.moveInfo) do
          if info.fromArea == Card.PlayerEquip then
            return true
          end
        end
      end
    end
  end,
  on_cost = xuanfengCost,
  on_use = xuanfengUse,
})

xuanfeng:addEffect(fk.EventPhaseEnd, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if target == player and player.phase == Player.Discard and player:hasSkill(xuanfeng.name) and
    not table.every(player.room.alive_players, function (p)
      return p == player or p:isNude()
    end) then
      local x = 0
      local logic = player.room.logic
      logic:getEventsOfScope(GameEvent.MoveCards, 1, function (e)
        for _, move in ipairs(e.data) do
          if move.from == player and move.moveReason == fk.ReasonDiscard and move.skillName == "phase_discard" then
            x = x + #move.moveInfo
            if x > 1 then return true end
          end
        end
        return false
      end, Player.HistoryTurn)
      return x > 1
    end
  end,
  on_cost = xuanfengCost,
  on_use = xuanfengUse,
})

return xuanfeng
