local baonue = fk.CreateSkill{
  name = "wzzz_v__ol_ex__baonue",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable{
  ["wzzz_v__ol_ex__baonue"] = "暴虐",
  [":wzzz_v__ol_ex__baonue"] = "主公技，当其他群势力角色造成伤害后，你可以进行判定，若结果为黑桃，你回复1点体力并获得此判定牌。游戏开始时，若场上没有其他群势力角色，则你可以令一名其他角色变更势力至“群”。",
  ["#wzzz_v__ol_ex__baonue-change"] = "暴虐：场上没有其他群势力角色，你可以选择一名非群势力角色，将其势力改为“群”",

  ["$wzzz_v__ol_ex__baonue1"] = "吾乃人屠，当以兵为贡。",
  ["$wzzz_v__ol_ex__baonue2"] = "天下群雄，唯我独尊！",
}

local function isHuashenZuoci(player)
  return player and player:hasSkill("wzzz_v__huashen", true)
end

baonue:addEffect(fk.GameStart, {
  can_trigger = function(self, event, target, player, data)
    if not player:hasSkill(baonue.name) then return false end
    local room = player.room
    return not table.find(room:getOtherPlayers(player, false), function(p)
      return p.kingdom == "qun" and not isHuashenZuoci(p)
    end) and table.find(room:getOtherPlayers(player, false), function(p)
      return p.kingdom ~= "qun" and not isHuashenZuoci(p)
    end)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      return p.kingdom ~= "qun" and not isHuashenZuoci(p)
    end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = baonue.name,
      prompt = "#wzzz_v__ol_ex__baonue-change",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    to.kingdom = "qun"
    room:broadcastProperty(to, "kingdom")
  end,
})

baonue:addEffect(fk.Damage, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(baonue.name) and target and player ~= target and target.kingdom == "qun"
  end,
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = baonue.name,
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local judge = {
      who = player,
      reason = baonue.name,
      pattern = ".|.|spade",
    }
    room:judge(judge)
    if judge:matchPattern() and player:isWounded() and not player.dead then
      room:recover({
        who = player,
        num = 1,
        recoverBy = target,
        skillName = baonue.name,
      })
    end
  end
})

baonue:addEffect(fk.FinishJudge, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and data.card.suit == Card.Spade and data.reason == baonue.name
      and player.room:getCardArea(data.card.id) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    player.room:obtainCard(player, data.card, true, fk.ReasonJustMove, player, baonue.name)
  end,
})

return baonue
