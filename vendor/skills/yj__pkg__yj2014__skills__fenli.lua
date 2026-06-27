local fenli = fk.CreateSkill {
  name = "wzzz_v__fenli"
}

Fk:loadTranslationTable{
  ["wzzz_v__fenli"] = "奋励",
  [":wzzz_v__fenli"] = "判定阶段开始前，若你的手牌数为场上最多，你可以跳过此阶段和本回合的下个摸牌阶段；出牌阶段开始前，若你的体力值为场上最高，你可以跳过此阶段；弃牌阶段开始前，若你装备区里的牌数为场上最多（至少0张），你可以跳过此阶段。",

  ["#wzzz_v__fenli-invoke"] = "奋励：你可以跳过%arg",

  ["$wzzz_v__fenli1"] = "以逸待劳，坐收渔利。",
  ["$wzzz_v__fenli2"] = "以主制客，占尽优势。",
}

fenli:addEffect(fk.EventPhaseChanging, {
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(fenli.name) and not data.skipped then
      if data.phase == Player.Judge then
        return table.every(player.room:getOtherPlayers(player), function (p)
          return p:getHandcardNum() <= player:getHandcardNum()
        end)
      elseif data.phase == Player.Play then
        return table.every(player.room:getOtherPlayers(player), function (p)
          return p.hp <= player.hp
        end)
      elseif data.phase == Player.Discard then
        return table.every(player.room:getOtherPlayers(player), function (p)
          return #p:getCardIds("e") <= #player:getCardIds("e")
        end)
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    local phases = {
      [Player.Judge] = "phase_judge",
      [Player.Play] = "phase_play",
      [Player.Discard] = "phase_discard",
    }
    return player.room:askToSkillInvoke(player, {
      skill_name = fenli.name,
      prompt = "#wzzz_v__fenli-invoke:::"..phases[data.phase],
    })
  end,
  on_use = function(self, event, target, player, data)
    player:skip(data.phase)
    if data.phase == Player.Judge then
      player:skip(Player.Draw)
    end
    data.skipped = true
  end,
})

return fenli
