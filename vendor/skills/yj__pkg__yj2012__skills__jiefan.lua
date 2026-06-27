local jiefan = fk.CreateSkill {
  name = "wzzz_v__jiefan",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__jiefan"] = "解烦",
  [":wzzz_v__jiefan"] = "限定技，出牌阶段，你可以选择一名角色，令攻击范围内包含其的角色选择一项：1.弃置一张武器牌；2.令其摸一张牌。若此时为第一轮游戏，回合结束时，此技能视为未发动过。",

  ["#wzzz_v__jiefan"] = "解烦：指定一名角色，攻击范围内含有其的角色选择弃一张牌武器牌或令目标摸一张牌",
  ["wzzz_v__jiefan_target"] = "解烦目标",
  ["wzzz_v__jiefan_tos"] = "被解烦",
  ["#wzzz_v__jiefan-discard"] = "解烦：弃置一张武器牌，否则 %dest 摸一张牌",

  ["$wzzz_v__jiefan1"] = "公且放心，这里有我。",
  ["$wzzz_v__jiefan2"] = "排愁消烦忧，祛害避凶邪。",
}

jiefan:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__jiefan",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(jiefan.name, Player.HistoryGame) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  target_tip = function (self, player, to_select, selected, selected_cards, card, selectable, extra_data)
    if #selected == 0 then return end
    if to_select == selected[1] then
      return "wzzz_v__jiefan_target"
    else
      if to_select:inMyAttackRange(selected[1]) then
        return { {content = "wzzz_v__jiefan_tos", type = "warning"} }
      end
    end
  end,
  on_use = function(self, room, effect)
    local target = effect.tos[1]
    for _, p in ipairs(room:getOtherPlayers(target)) do
    if p:inMyAttackRange(target) and not p.dead then
      if #room:askToDiscard(p, {
        skill_name = jiefan.name,
        min_num = 1,
        max_num = 1,
        include_equip = true,
        cancelable = not target.dead,
        pattern = ".|.|.|.|.|weapon",
        prompt = "#wzzz_v__jiefan-discard::"..target.id
        }) == 0 then
          target:drawCards(1, jiefan.name)
        end
      end
    end
  end,
})

jiefan:addEffect(fk.TurnEnd, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(jiefan.name, true) and
      (player.room:getBanner("RoundCount") or 0) == 1 and
      player:usedSkillTimes(jiefan.name, Player.HistoryGame) > 0
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    player:setSkillUseHistory(jiefan.name, 0, Player.HistoryGame)
  end,
})

return jiefan
