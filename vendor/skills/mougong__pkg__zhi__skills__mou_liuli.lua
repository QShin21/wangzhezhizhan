local mouLiuli = fk.CreateSkill({
  name = "wzzz_v__mou__liuli",
})

Fk:loadTranslationTable{
  ["wzzz_v__mou__liuli"] = "流离",
  [":wzzz_v__mou__liuli"] = "当你成为【杀】的目标时，你可以弃置一张牌并选择你攻击范围内的一名其他角色，然后将此【杀】转移给该角色。",
  ["#wzzz_v__mou__liuli-target"] = "流离：你可以弃置一张牌，将【杀】的目标转移给一名其他角色",

  ["$wzzz_v__mou__liuli1"] = "无论何时何地，我都在你身边。",
  ["$wzzz_v__mou__liuli2"] = "辗转流离，只为此刻与君相遇。",
}

mouLiuli:addEffect(fk.TargetConfirming, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    local ret = target == player and player:hasSkill(mouLiuli.name) and data.card.trueName == "slash" and not data.cancelled
    if ret then
      for _, p in ipairs(player.room.alive_players) do
        if p ~= player and player:inMyAttackRange(p) and not data.from:isProhibited(p, data.card) then
          return true
        end
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    ---@type string
    local skillName = mouLiuli.name
    local room = player.room
    local prompt = "#wzzz_v__mou__liuli-target"
    local targets = {}
    local from = data.from
    for _, p in ipairs(room.alive_players) do
      if p ~= player and player:inMyAttackRange(p) and not from:isProhibited(p, data.card) then
        table.insert(targets, p)
      end
    end
    if #targets == 0 then return false end
    local plist, cid = room:askToChooseCardsAndPlayers(
      player,
      {
        targets = targets,
        min_num = 1,
        max_num = 1,
        min_card_num = 1,
        max_card_num = 1,
        prompt = prompt,
        skill_name = skillName,
        will_throw = true,
      }
    )
    if #plist > 0 and #cid > 0 then
      event:setCostData(self, { plist[1], cid[1] })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    ---@type string
    local skillName = mouLiuli.name
    local room = player.room
    local costData = event:getCostData(self)
    local to = costData[1]
    room:doIndicate(player.id, { to })
    room:throwCard(costData[2], skillName, player, player)

    if data:cancelCurrentTarget() then
      data:addTarget(to)
    end
    return true
  end,
})

return mouLiuli
