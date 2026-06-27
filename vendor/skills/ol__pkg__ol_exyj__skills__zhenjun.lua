local zhenjun = fk.CreateSkill {
  name = "wzzz_v__ol_ex__zhenjun",
}

Fk:loadTranslationTable{
  ["wzzz_v__ol_ex__zhenjun"] = "镇军",
  [":wzzz_v__ol_ex__zhenjun"] = "准备阶段和结束阶段，你可以弃置一名角色的X张牌（X为其手牌数减体力值且至少为1），然后选择一项："..
  "1.你弃置等同于其中非装备牌数的牌；2.该角色摸等同于其中非装备牌数的牌。",

  ["#wzzz_v__ol_ex__zhenjun-choose"] = "镇军：选择一名角色，弃置其手牌数减体力值张牌（至少一张）",
  ["#wzzz_v__ol_ex__zhenjun-card"] = "镇军：弃置 %dest %arg张牌，然后选择弃牌或令其摸牌",
  ["#wzzz_v__ol_ex__zhenjun-discard"] = "镇军：弃置%arg张牌，或点“取消”令 %dest 摸%arg张牌",

  ["$wzzz_v__ol_ex__zhenjun1"] = "奉令无犯，当敌制决，靡有遗失！",
  ["$wzzz_v__ol_ex__zhenjun2"] = "军令在此，围而后降者皆不赦。",
}

zhenjun:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhenjun.name) and
      (player.phase == Player.Start or player.phase == Player.Finish) and
      table.find(player.room.alive_players, function(p)
        return not p:isNude()
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room.alive_players, function(p)
      return not p:isNude()
    end)
    if table.contains(targets, player) and
      not table.find(player:getCardIds("he"), function (id)
        return not player:prohibitDiscard(id)
      end) then
      table.removeOne(targets, player)
    end

    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = zhenjun.name,
      prompt = "#wzzz_v__ol_ex__zhenjun-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local num = math.min(math.max(1, to:getHandcardNum() - to.hp), #to:getCardIds("he"))
    local cards
    if to == player then
      cards = room:askToDiscard(player, {
        min_num = num,
        max_num = num,
        include_equip = true,
        skill_name = zhenjun.name,
        cancelable = false,
        prompt = "#wzzz_v__ol_ex__zhenjun-card::"..to.id..":"..num,
        skip = true,
      })
    else
      cards = room:askToChooseCards(player, {
        target = to,
        min = num,
        max = num,
        flag = "he",
        skill_name = zhenjun.name,
        prompt = "#wzzz_v__ol_ex__zhenjun-card::"..to.id..":"..num
      })
    end
    num = #table.filter(cards, function(id)
      return Fk:getCardById(id).type ~= Card.TypeEquip
    end)
    room:throwCard(cards, zhenjun.name, to, player)
    if player.dead or num == 0 then return end
    if player:isNude() or
      #room:askToDiscard(player, {
        min_num = num,
        max_num = num,
        include_equip = true,
        skill_name = zhenjun.name,
        prompt = "#wzzz_v__ol_ex__zhenjun-discard::"..to.id..":"..num,
      }) == 0 then
      to:drawCards(num, zhenjun.name)
    end
  end,
})

return zhenjun
