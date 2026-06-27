local duoshi = fk.CreateSkill {
  name = "wzzz_v__m_heg__duoshi",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_heg__duoshi"] = "度势",
  [":wzzz_v__m_heg__duoshi"] = "出牌阶段限一次，你可以将一张牌交给一名除你外手牌数最多的角色，然后对其造成1点伤害。若其因此死亡，你可以令一名角色将手牌摸至四张。",

  ["#wzzz_v__m_heg__duoshi"] = "度势：交给手牌数最多的一名其他角色一张牌，然后对其造成1点伤害",
  ["#wzzz_v__m_heg__duoshi-choose"] = "度势：你可以令一名角色将手牌摸至四张",

  ["$wzzz_v__m_heg__duoshi1"] = "以今日之大势，当行此计。",
  ["$wzzz_v__m_heg__duoshi2"] = "国之大计，审势为先。",
}

duoshi:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__m_heg__duoshi",
  card_num = 1,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(duoshi.name, Player.HistoryPhase) == 0 and not player:isNude()
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  target_filter = function (self, player, to_select, selected)
    if #selected == 0 and to_select ~= player then
      local n = 0
      for _, p in ipairs(Fk:currentRoom().alive_players) do
        if p ~= player and p:getHandcardNum() > n then
          n = p:getHandcardNum()
        end
      end
      return to_select:getHandcardNum() == n
    end
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    room:obtainCard(target, effect.cards[1], true, fk.ReasonGive, player, duoshi.name)
    local event_id = room.logic:getCurrentEvent().id
    room:damage{
      from = player,
      to = target,
      damage = 1,
      skillName = duoshi.name,
    }
    if target.dead and not player.dead and #room.logic:getActualDamageEvents(1, function(e)
      return e.data.from == player and e.data.to == target and e.data.skillName == duoshi.name
    end, nil, event_id) > 0 then
      local targets = table.filter(room.alive_players, function(p)
        return p:getHandcardNum() < 4
      end)
      if #targets == 0 then return end
      local to = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = duoshi.name,
        prompt = "#wzzz_v__m_heg__duoshi-choose",
        cancelable = true,
      })
      if #to > 0 then
        to[1]:drawCards(4 - to[1]:getHandcardNum(), duoshi.name)
      end
    end
  end,
})

return duoshi
