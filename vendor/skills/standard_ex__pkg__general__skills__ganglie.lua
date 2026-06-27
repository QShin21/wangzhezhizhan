Fk:loadTranslationTable{
  ["wzzz_v__ex__ganglie"] = "刚烈",
  [":wzzz_v__ex__ganglie"] = "当你受到1点伤害后，你可以选择一名其他角色并进行判定，若结果为：红色，你对其造成1点伤害；黑色，你弃置其一张牌。",

  ["#wzzz_v__ex__ganglie-invoke"] = "刚烈：选择一名其他角色并判定，红色对其造成伤害，黑色弃置其牌",

  ["$wzzz_v__ex__ganglie1"] = "哪个敢动我！",
  ["$wzzz_v__ex__ganglie2"] = "伤我者，十倍奉还！",
}

local ganglie = fk.CreateSkill{
  name = "wzzz_v__ex__ganglie",
}

ganglie:addEffect(fk.Damaged, {
  anim_type = "masochism",
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(ganglie.name) and #player.room:getOtherPlayers(player, false) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = room:getOtherPlayers(player, false)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = ganglie.name,
      prompt = "#wzzz_v__ex__ganglie-invoke",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local judge = {
      who = player,
      reason = ganglie.name,
      pattern = ".|.|^nosuit",
    }
    room:judge(judge)
    local to = event:getCostData(self).tos[1]
    if to.dead then return false end
    if judge.card.color == Card.Red then
      room:damage{
        from = player,
        to = to,
        damage = 1,
        skillName = ganglie.name,
      }
    elseif judge.card.color == Card.Black and not to:isNude() and not player.dead then
      local cid = room:askToChooseCard(player, {
        target = to,
        flag = "he",
        skill_name = ganglie.name
      })
      room:throwCard(cid, ganglie.name, to, player)
    end
  end
})

return ganglie
