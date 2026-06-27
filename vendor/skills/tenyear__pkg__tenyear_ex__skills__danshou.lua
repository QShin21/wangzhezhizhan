local danshou = fk.CreateSkill {
  name = "wzzz_v__ty_ex__danshou",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__danshou"] = "胆守",
  [":wzzz_v__ty_ex__danshou"] = "每名其他角色的回合限一次，当你成为基本牌或普通锦囊牌的目标后，你可以摸一张牌；一名角色的结束阶段，若你本回合未以此法摸牌，你可以弃置X+1张牌，对其造成1点伤害。（X为其手牌数）",

  ["#wzzz_v__ty_ex__danshou-draw"] = "胆守：你可以摸一张牌",
  ["#wzzz_v__ty_ex__danshou-invoke"] = "胆守：你可以对 %dest 造成1点伤害",
  ["#wzzz_v__ty_ex__danshou-discard"] = "胆守：你可以弃置%arg张牌，对 %dest 造成1点伤害",

  ["$wzzz_v__ty_ex__danshou1"] = "胆识过人而劲勇，则见敌无所畏惧",
  ["$wzzz_v__ty_ex__danshou2"] = "胆守有余，可堪大任！"
}

danshou:addEffect(fk.TargetConfirmed, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(danshou.name) and player.room.current ~= player and
      (data.card.type == Card.TypeBasic or data.card:isCommonTrick()) and
      player:usedSkillTimes(danshou.name, Player.HistoryTurn) == 0 and
      data.from and data.from ~= player
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = danshou.name,
      prompt = "#wzzz_v__ty_ex__danshou-draw",
    })
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, danshou.name)
  end,
})

danshou:addEffect(fk.EventPhaseStart, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(danshou.name) and target.phase == Player.Finish and
      player:usedSkillTimes(danshou.name, Player.HistoryTurn) == 0 and not target.dead and
      #player:getCardIds("he") >= target:getHandcardNum() + 1
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local n = target:getHandcardNum() + 1
    local cards = room:askToDiscard(player, {
      min_num = n,
      max_num = n,
      include_equip = true,
      skill_name = danshou.name,
      cancelable = true,
      prompt = "#wzzz_v__ty_ex__danshou-discard::"..target.id..":" .. n,
      skip = true
    })
    if #cards == n then
      event:setCostData(self, {tos = {target}, cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local cards = event:getCostData(self).cards
    if cards then
      room:throwCard(cards, danshou.name, player, player)
    end
    if not target.dead then
      room:damage{
        from = player,
        to = target,
        damage = 1,
        skillName = danshou.name,
      }
    end
  end,
})

return danshou
