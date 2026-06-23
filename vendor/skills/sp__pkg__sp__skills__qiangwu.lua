
local qiangwu = fk.CreateSkill {
  name = "wzzz_v__qiangwu",
}

Fk:loadTranslationTable{
  ["wzzz_v__qiangwu"] = "枪舞",
  [":wzzz_v__qiangwu"] = "出牌阶段限一次，你可以进行一次判定，若如此做，直到回合结束，你使用点数小于判定牌的【杀】无距离限制，"..
  "你使用点数大于判定牌的【杀】无次数限制。",

  ["#wzzz_v__qiangwu"] = "枪舞：进行判定，根据点数本回合使用【杀】获得增益",
  ["@wzzz_v__qiangwu-turn"] = "枪舞",

  ["$wzzz_v__qiangwu1"] = "父亲未尽之业，由我继续！",
  ["$wzzz_v__qiangwu2"] = "咆哮沙场，万夫不敌！",
}

qiangwu:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__qiangwu",
  card_num = 0,
  target_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(qiangwu.name) == 0
  end,
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    local judge = {
      who = player,
      reason = qiangwu.name,
      pattern = ".",
    }
    room:judge(judge)
    room:setPlayerMark(player, "@wzzz_v__qiangwu-turn", judge.card.number)
  end,
})

qiangwu:addEffect(fk.PreCardUse, {
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark("@wzzz_v__qiangwu-turn") > 0 and
      data.card.trueName == "slash" and data.card.number > player:getMark("@wzzz_v__qiangwu-turn")
  end,
  on_refresh = function(self, event, target, player, data)
    data.extraUse = true
  end,
})

qiangwu:addEffect("targetmod", {
  bypass_times = function (self, player, skill, scope, card)
    local number = player:getMark("@wzzz_v__qiangwu-turn")
    if number ~= 0 then
      return card:matchVSPattern("slash|" .. tostring(number) .. "~13")
    end
  end,
  bypass_distances = function (self, player, skill, card)
    local number = player:getMark("@wzzz_v__qiangwu-turn")
    if number ~= 0 then
      return card:matchVSPattern("slash|1~" .. tostring(number))
    end
  end
})

return qiangwu
