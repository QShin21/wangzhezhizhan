local wzzz_v__kangrui = fk.CreateSkill{
  name = "wzzz_v__kangrui",
}

Fk:loadTranslationTable{
  ["wzzz_v__kangrui"] = "亢锐",
  [":wzzz_v__kangrui"] = "当一名角色于其回合内首次受到伤害后，你可以摸一张牌并令其：1.回复1点体力；2.本回合下次造成的伤害+1。然后当其造成伤害时，"..
  "其此回合手牌上限改为0。",

  ["#wzzz_v__kangrui-invoke"] = "亢锐：你可以摸一张牌，令 %dest 回复1点体力或本回合下次造成伤害+1",
  ["wzzz_v__kangrui_damage"] = "本回合下次造成伤害+1",
  ["#wzzz_v__kangrui-choice"] = "亢锐：选择令 %dest 执行的一项",
  ["@wzzz_v__kangrui-turn"] = "亢锐",
  ["wzzz_v__kangrui_adddamage"] = "加伤害",

  ["$wzzz_v__kangrui1"] = "尔等魍魉，愿试吾剑之利乎？",
  ["$wzzz_v__kangrui2"] = "诸君鼓力，克复中原指日可待！",
}

wzzz_v__kangrui:addEffect(fk.Damaged, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(wzzz_v__kangrui.name) and not target.dead then
      local room = player.room
      if room.current ~= target then return false end
      local damage_event = room.logic:getCurrentEvent():findParent(GameEvent.Damage, true)
      if damage_event == nil then return false end
      local x = target:getMark("wzzz_v__kangrui_record-turn")
      if x == 0 then
        room.logic:getActualDamageEvents(1, function (e)
          if e.data.to == target then
            x = e.id
            room:setPlayerMark(target, "wzzz_v__kangrui_record-turn", x)
            return true
          end
          return false
        end)
      end
      return x == damage_event.id
    end
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    if room:askToSkillInvoke(player, {
      skill_name = wzzz_v__kangrui.name,
      prompt = "#wzzz_v__kangrui-invoke::"..target.id,
    }) then
      event:setCostData(self, {tos = {target}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    player:drawCards(1, wzzz_v__kangrui.name)
    if player.dead or target.dead then return false end
    local choices = {"wzzz_v__kangrui_damage"}
    if target:isWounded() then
      table.insert(choices, 1, "recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = wzzz_v__kangrui.name,
      prompt = "#wzzz_v__kangrui-choice::"..target.id,
      all_choices = {"recover", "wzzz_v__kangrui_damage"},
    })
    if choice == "recover" then
      room:recover{
        who = target,
        num = 1,
        recoverBy = player,
        skillName = wzzz_v__kangrui.name,
      }
      if target.dead then return false end
      room:setPlayerMark(target, "@wzzz_v__kangrui-turn", "")
    else
      room:setPlayerMark(target, "@wzzz_v__kangrui-turn", "wzzz_v__kangrui_adddamage")
    end
  end,
})
wzzz_v__kangrui:addEffect(fk.DamageCaused, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:getMark("@wzzz_v__kangrui-turn") ~= 0
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if player:getMark("@wzzz_v__kangrui-turn") == "wzzz_v__kangrui_adddamage" then
      if player:hasSkill(wzzz_v__kangrui.name, true) then
        room:notifySkillInvoked(player, wzzz_v__kangrui.name, "offensive")
        player:broadcastSkillInvoke(wzzz_v__kangrui.name)
      end
      data:changeDamage(1)
    end
    room:setPlayerMark(player, "@wzzz_v__kangrui-turn", 0)
    room:setPlayerMark(player, "wzzz_v__kangrui_minus-turn", 1)
  end,
})
wzzz_v__kangrui:addEffect("maxcards", {
  fixed_func = function(self, player)
    if player:getMark("wzzz_v__kangrui_minus-turn") > 0 then
      return 0
    end
  end,
})

return wzzz_v__kangrui
