local jianji = fk.CreateSkill{
  name = "wzzz_v__jianji",
}

Fk:loadTranslationTable{
  ["wzzz_v__jianji"] = "谏计",
  [":wzzz_v__jianji"] = "出牌阶段限一次，你可以令一名其他角色摸一张牌并展示之，然后其可以使用此牌（可转化使用）。",

  ["#wzzz_v__jianji"] = "谏计：令一名其他角色摸一张牌，其可以使用之",
  ["#wzzz_v__jianji-use"] = "谏计：你可以使用这张牌",

  ["$wzzz_v__jianji1"] = "锦上添花，不如雪中送炭。",
  ["$wzzz_v__jianji2"] = "密计交于将军，可解燃眉之困。",
}

jianji:addEffect("active", {
  anim_type = "support",
  prompt = "#wzzz_v__jianji",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(jianji.name, Player.HistoryPhase) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player
  end,
  on_use = function(self, room, effect)
    local target = effect.tos[1]
    local id = target:drawCards(1, jianji.name)[1]
    if not target.dead and table.contains(target:getCardIds("h"), id) then
      target:showCards(id)
      room:askToUseRealCard(target, {
        pattern = {id},
        skill_name = jianji.name,
        prompt = "#wzzz_v__jianji-use",
        extra_data = {
          bypass_times = true,
          extraUse = true,
          expand_pile = {id},
        }
      })
    end
  end,
})

return jianji
