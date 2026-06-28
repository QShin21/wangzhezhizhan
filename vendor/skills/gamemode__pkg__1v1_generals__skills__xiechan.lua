local xiechan = fk.CreateSkill {
  name = "wzzz_v__v11__xiechan",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__v11__xiechan"] = "挟缠",
  [":wzzz_v__v11__xiechan"] = "限定技，出牌阶段，你可以与一名其他角色拼点，若你赢，你视为对其使用一张【决斗】；若你没赢，其视为对你使用一张【决斗】。",

  ["#wzzz_v__v11__xiechan"] = "挟缠：与一名其他角色拼点，若赢视为对其使用【决斗】，否则其对你使用【决斗】",

  ["$wzzz_v__v11__xiechan1"] = "休走，你我今日定要分个胜负！",
  ["$wzzz_v__v11__xiechan2"] = "不是你死，便是我亡！",
}

xiechan:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__v11__xiechan",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player.phase == Player.Play and not player:isKongcheng() and
      player:usedSkillTimes(xiechan.name, Player.HistoryGame) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and player:canPindian(to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local to = effect.tos[1]
    local pindian = player:pindian({to}, xiechan.name)
    local user = (pindian.results[to].winner == player) and {player, to} or {to, player}
    room:useVirtualCard("duel", nil, user[1], user[2], xiechan.name)
  end,
})

return xiechan
