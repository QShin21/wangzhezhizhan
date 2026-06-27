local cuorui = fk.CreateSkill{
  name = "wzzz_v__ol__cuorui",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__ol__cuorui"] = "挫锐",
  [":wzzz_v__ol__cuorui"] = "限定技，准备阶段，你可以将手牌摸至X张并跳过本回合判定阶段（X为场上手牌数最多角色的手牌数，至多摸五张牌）。",

  ["$wzzz_v__ol__cuorui1"] = "敌锐气正盛，吾欲挫之。",
  ["$wzzz_v__ol__cuorui2"] = "锐气受挫，则未敢恋战。",
}

cuorui:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(cuorui.name) and player.phase == Player.Start and
      player:usedSkillTimes(cuorui.name, Player.HistoryGame) == 0
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, { skill_name = cuorui.name })
  end,
  on_use = function(self, event, target, player, data)
    local x = 0
    for _, p in ipairs(player.room.alive_players) do
      x = math.max(x, p:getHandcardNum())
    end
    x = math.min(5, x)
    if player:getHandcardNum() < x then
      player:drawCards(x - player:getHandcardNum(), cuorui.name)
    end
    if not player.dead then
      player:skip(Player.Judge)
    end
  end,
})

return cuorui
