local wzzz_v__kuangbi = fk.CreateSkill {
  name = "wzzz_v__kuangbi",
}

Fk:loadTranslationTable{
  ["wzzz_v__kuangbi"] = "匡弼",
  [":wzzz_v__kuangbi"] = "出牌阶段限一次或游戏开始时，你可以选择一名有牌的其他角色，其将一至三张牌（游戏开始时改为一至两张牌）扣置于你的武将牌上，然后你可以令其摸等量的牌。准备阶段，你获得你武将牌上的牌。",

  ["#wzzz_v__kuangbi"] = "匡弼：令一名角色将至多三张牌置为“匡弼”牌，然后你可以令其摸等量牌",
  ["#wzzz_v__kuangbi-card"] = "匡弼：将至多三张牌置为 %src 的“匡弼”牌",
  ["#wzzz_v__kuangbi-draw"] = "匡弼：是否令 %dest 摸%arg张牌？",
  ["$wzzz_v__kuangbi"] = "匡弼",

  ["$wzzz_v__kuangbi1"] = "匡人助己，辅政弼贤。",
  ["$wzzz_v__kuangbi2"] = "兴隆大化，佐理时务。",
}

local function doKuangbi(room, player, target, n)
  local cards = room:askToCards(target, {
    skill_name = wzzz_v__kuangbi.name,
    include_equip = true,
    min_num = 1,
    max_num = n,
    prompt = "#wzzz_v__kuangbi-card:"..player.id,
    cancelable = false,
  })
  player:addToPile("$wzzz_v__kuangbi", cards, false, wzzz_v__kuangbi.name, target)
  if not player.dead and not target.dead and room:askToSkillInvoke(player, {
    skill_name = wzzz_v__kuangbi.name,
    prompt = "#wzzz_v__kuangbi-draw::"..target.id..":"..#cards,
  }) then
    target:drawCards(#cards, wzzz_v__kuangbi.name)
  end
end

wzzz_v__kuangbi:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__kuangbi",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedEffectTimes(wzzz_v__kuangbi.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0 and to_select ~= player and not to_select:isNude()
  end,
  on_use = function(self, room, effect)
    doKuangbi(room, effect.from, effect.tos[1], 3)
  end,
})

wzzz_v__kuangbi:addEffect(fk.GameStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(wzzz_v__kuangbi.name) and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, wzzz_v__kuangbi.name)) and
      table.find(player.room:getOtherPlayers(player, false), function(p)
        return not p:isNude()
      end)
  end,
  on_cost = function(self, event, target, player, data)
    local tos = player.room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = table.filter(player.room:getOtherPlayers(player, false), function(p)
        return not p:isNude()
      end),
      skill_name = wzzz_v__kuangbi.name,
      prompt = "#wzzz_v__kuangbi",
      cancelable = true,
    })
    if #tos > 0 then
      event:setCostData(self, {tos = tos})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    doKuangbi(player.room, player, event:getCostData(self).tos[1], 2)
  end,
})

wzzz_v__kuangbi:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player.phase == Player.Start and #player:getPile("$wzzz_v__kuangbi") > 0
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player, player:getPile("$wzzz_v__kuangbi"), false, fk.ReasonJustMove, player, wzzz_v__kuangbi.name)
  end,
})

return wzzz_v__kuangbi
