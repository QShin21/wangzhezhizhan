local mouLuanwu = fk.CreateSkill({
  name = "wzzz_v__mou__luanwu",
  tags = { Skill.Limited },
})

Fk:loadTranslationTable{
  ["wzzz_v__mou__luanwu"] = "乱武",
  [":wzzz_v__mou__luanwu"] = "限定技，出牌阶段，你可以令所有其他角色依次选择一项：1.失去1点体力；2.对其距离最近的一名角色使用一张【杀】。结算完成后，你可以视为使用一张无距离次数限制的【杀】。",
  ["#wzzz_v__mou__luanwu"] = "令所有其他角色选择失去体力或对最近角色出杀",
  ["#wzzz_v__mou__luanwu-slash"] = "乱武：你可以视为使用一张无距离次数限制的【杀】",
  ["#wzzz_v__mou__luanwu_delay"] = "乱武",

  ["$wzzz_v__mou__luanwu1"] = "降则任人鱼肉，竭战或可保生！",
  ["$wzzz_v__mou__luanwu2"] = "一将功成需万骨，何妨多添此一城！",
  ["$wzzz_v__mou__luanwu3"] = "人之道，损不足以奉有余。",
  ["$wzzz_v__mou__luanwu4"] = "寒烟起于朽木，白骨亦可生花。",
}

mouLuanwu:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__mou__luanwu",
  card_num = 0,
  target_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(mouLuanwu.name, Player.HistoryGame) == 0
  end,
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    ---@type string
    local skillName = mouLuanwu.name
    local player = effect.from
    local targets = room:getOtherPlayers(player)
    room:doIndicate(player, table.map(targets, Util.IdMapper))
    for _, target in ipairs(targets) do
      if target:isAlive() then
        local other_players = table.filter(room:getOtherPlayers(target, false), function(p)
          return not p:isRemoved() and p ~= player
        end)
        local luanwu_targets = table.map(table.filter(other_players, function(p2)
          return table.every(other_players, function(p1)
            return target:distanceTo(p1) >= target:distanceTo(p2)
          end)
        end), Util.IdMapper)
        local use = room:askToUseCard(
          target,
          {
            pattern = "slash",
            skill_name = skillName,
            prompt = "#luanwu-use",
            extra_data = { include_targets = luanwu_targets, bypass_times = true }
          }
        )
        if use then
          use.extraUse = true
          room:useCard(use)
        else
          room:loseHp(target, 1, skillName)
        end
      end
    end
    if not player.dead then
      room:askToUseVirtualCard(player, {
        name = "slash",
        skill_name = skillName,
        prompt = "#wzzz_v__mou__luanwu-slash",
        cancelable = true,
        extra_data = {
          bypass_distances = true,
          bypass_times = true,
          extraUse = true,
        },
      })
    end
  end,
})

return mouLuanwu
