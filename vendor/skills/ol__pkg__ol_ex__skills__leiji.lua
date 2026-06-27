local leiji = fk.CreateSkill {
  name = "wzzz_v__ol_ex__leiji",
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__leiji"] = "雷击",
  [":wzzz_v__ol_ex__leiji"] = "当你使用或打出【闪】，或使用【闪电】时，你可以进行判定。当你的判定牌生效后，若结果为：黑桃，你可以对一名角色造成2点雷电伤害；梅花，你回复1点体力并可以对一名角色造成1点雷电伤害。",

  ["#wzzz_v__ol_ex__leiji-choose"] = "雷击：你可以对一名角色造成%arg点雷电伤害",

  ["$wzzz_v__ol_ex__leiji1"] = "疾雷迅电，不可趋避！",
  ["$wzzz_v__ol_ex__leiji2"] = "雷霆之诛，灭军毁城！",
}

local judge_data = {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(leiji.name) and
      (data.card.trueName == "jink" or data.card.trueName == "lightning")
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local judge = {
      who = player,
      reason = leiji.name,
      pattern = ".|.|spade,club"
    }
    room:judge(judge)
  end,
}

leiji:addEffect(fk.CardUsing, judge_data)
leiji:addEffect(fk.CardResponding, judge_data)
leiji:addEffect(fk.FinishJudge, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(leiji.name) and data.reason == leiji.name and data.card.color == Card.Black
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local x = 2
    if data.card.suit == Card.Club then
      x = 1
      if player:isWounded() then
        room:recover({
          who = player,
          num = 1,
          recoverBy = player,
          skillName = leiji.name,
        })
      end
      if player.dead then return false end
    end
    local to = room:askToChoosePlayers(player, {
      targets = room.alive_players,
      min_num = 1,
      max_num = 1,
      prompt = "#wzzz_v__ol_ex__leiji-choose:::" .. x,
      skill_name = leiji.name,
      cancelable = true,
    })
    if #to > 0 then
      room:damage{
        from = player,
        to = to[1],
        damage = x,
        damageType = fk.ThunderDamage,
        skillName = leiji.name,
      }
    end
  end,
})

return leiji
