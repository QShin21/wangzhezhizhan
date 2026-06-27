local cunsi = fk.CreateSkill {
  name = "wzzz_v__ty__cunsi",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__ty__cunsi"] = "存嗣",
  [":wzzz_v__ty__cunsi"] = "限定技，出牌阶段，你可以回复1点体力，然后失去“清玉”并令一名角色获得“勇决”，若不为你，其摸两张牌。",

  ["#wzzz_v__ty__cunsi"] = "存嗣：回复1点体力，失去“清玉”并令一名角色获得“勇决”",

  ["$wzzz_v__ty__cunsi1"] = "存汉室之嗣，留汉室之本。",
  ["$wzzz_v__ty__cunsi2"] = "一切，便托付将军了！",
}

cunsi:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__ty__cunsi",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(cunsi.name, Player.HistoryGame) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    return #selected == 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    if player:isWounded() then
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = cunsi.name,
      }
      if player.dead then return end
    end
    room:handleAddLoseSkills(player, "-wzzz_v__qingyu", nil, false, true)
    if player.dead or target.dead then return end
    room:handleAddLoseSkills(target, "wzzz_v__ty__yongjue", nil, false, true)
    if target ~= player then
      target:drawCards(2, cunsi.name)
    end
  end,
})

return cunsi
