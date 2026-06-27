local pingcai = fk.CreateSkill {
  name = "wzzz_v__pingcai",
}

Fk:loadTranslationTable{
  ["wzzz_v__pingcai"] = "评才",
  [":wzzz_v__pingcai"] = "出牌阶段限一次，你可以展示一张手牌，若此牌为：方块，你对一名角色造成1点火焰伤害；红桃，你令一名角色摸一张牌并回复1点体力；黑桃，你移动场上的一张装备牌；梅花，你令至多三名角色横置。",

  ["#wzzz_v__pingcai"] = "评才：展示一张手牌，并根据花色执行效果",
  ["#wzzz_v__pingcai-damage"] = "评才：对一名角色造成1点火焰伤害",
  ["#wzzz_v__pingcai-recover"] = "评才：令一名角色摸一张牌并回复1点体力",
  ["#wzzz_v__pingcai-move"] = "评才：移动场上的一张装备牌",
  ["#wzzz_v__pingcai-chain"] = "评才：令至多三名角色横置",

  ["$wzzz_v__pingcai1"] = "吾有众好友，分为卧龙、凤雏、水镜、元直。",
  ["$wzzz_v__pingcai2"] = "孔明能借天火之势。",
}

pingcai:addEffect("active", {
  anim_type = "control",
  card_num = 1,
  target_num = 0,
  prompt = "#wzzz_v__pingcai",
  can_use = function(self, player)
    return player:usedSkillTimes(pingcai.name, Player.HistoryPhase) == 0 and not player:isKongcheng()
  end,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and table.contains(player:getCardIds("h"), to_select)
  end,
  target_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    local id = effect.cards[1]
    local card = Fk:getCardById(id)
    player:showCards({ id })
    if player.dead then return end

    if card.suit == Card.Diamond then
      local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room.alive_players,
        skill_name = pingcai.name,
        prompt = "#wzzz_v__pingcai-damage",
        cancelable = false,
      })
      local to = tos[1]
      if to and not to.dead then
        room:damage{
          from = player,
          to = to,
          damage = 1,
          damageType = fk.FireDamage,
          skillName = pingcai.name,
        }
      end
    elseif card.suit == Card.Heart then
      local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = room.alive_players,
        skill_name = pingcai.name,
        prompt = "#wzzz_v__pingcai-recover",
        cancelable = false,
      })
      local to = tos[1]
      if to and not to.dead then
        to:drawCards(1, pingcai.name)
        if not to.dead and to:isWounded() then
          room:recover{
            who = to,
            num = 1,
            recoverBy = player,
            skillName = pingcai.name,
          }
        end
      end
    elseif card.suit == Card.Spade then
      local targets = room:askToChooseToMoveCardInBoard(player, {
        prompt = "#wzzz_v__pingcai-move",
        skill_name = pingcai.name,
        no_indicate = true,
        flag = "e",
        cancelable = true,
      })
      if #targets > 0 then
        room:askToMoveCardInBoard(player, {
          target_one = targets[1],
          target_two = targets[2],
          skill_name = pingcai.name,
        })
      end
    elseif card.suit == Card.Club then
      local targets = table.filter(room.alive_players, function(p)
        return not p.chained
      end)
      if #targets == 0 then return end
      local tos = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 3,
        targets = targets,
        skill_name = pingcai.name,
        prompt = "#wzzz_v__pingcai-chain",
        cancelable = false,
      })
      room:sortByAction(tos)
      for _, p in ipairs(tos) do
        if not p.dead and not p.chained then
          p:setChainState(true)
        end
      end
    end
  end,
})

return pingcai
