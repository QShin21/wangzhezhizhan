local yaoming = fk.CreateSkill {
  name = "wzzz_v__ol__yaoming",
}

Fk:loadTranslationTable{
  ["wzzz_v__ol__yaoming"] = "邀名",
  [":wzzz_v__ol__yaoming"] = "出牌阶段各限一次，或当你受到1点伤害后，你可以选择一项：1.弃置一名手牌数不小于你的其他角色的一张牌；2.令一名手牌数不大于你的其他角色摸一张牌。",

  ["#wzzz_v__ol__yaoming"] = "邀名：弃置一名手牌数不小于你的其他角色一张牌，或令一名手牌数不大于你的其他角色摸牌",
  ["#wzzz_v__ol__yaoming-choose"] = "邀名：选择一项并选择一名其他角色",
  ["#wzzz_v__ol__yaoming-discard"] = "邀名：请选择 %dest 的一张牌弃置",
  ["wzzz_v__ol__yaoming_discard"] = "弃牌",
  ["wzzz_v__ol__yaoming_draw"] = "摸牌",

  ["$wzzz_v__ol__yaoming1"] = "民食足，则国安。",
  ["$wzzz_v__ol__yaoming2"] = "惜得手中米，安得众人心。",
}

local function yaomingChoices(player, phase)
  local choices = {}
  if (not phase or player:getMark("wzzz_v__ol__yaoming_discard-phase") == 0) and
    table.find(player.room:getOtherPlayers(player, false), function(p)
      return p:getHandcardNum() >= player:getHandcardNum() and not p:isNude()
    end) then
    table.insert(choices, "wzzz_v__ol__yaoming_discard")
  end
  if (not phase or player:getMark("wzzz_v__ol__yaoming_draw-phase") == 0) and
    table.find(player.room:getOtherPlayers(player, false), function(p)
      return p:getHandcardNum() <= player:getHandcardNum()
    end) then
    table.insert(choices, "wzzz_v__ol__yaoming_draw")
  end
  return choices
end

local function doYaoming(room, player, choice, to)
  if choice == "wzzz_v__ol__yaoming_discard" then
    local id = room:askToChooseCard(player, {
      target = to,
      flag = "he",
      skill_name = yaoming.name,
      prompt = "#wzzz_v__ol__yaoming-discard::" .. to.id,
    })
    room:throwCard(id, yaoming.name, to, player)
  else
    to:drawCards(1, yaoming.name)
  end
end

yaoming:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__ol__yaoming",
  card_num = 0,
  target_num = 1,
  interaction = function(self, player)
    local choices = yaomingChoices(player, true)
    if #choices == 0 then return end
    return UI.ComboBox { choices = choices }
  end,
  can_use = function(self, player)
    return player.phase == Player.Play and #yaomingChoices(player, true) > 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    if #selected > 0 or not self.interaction.data or to_select == player then return false end
    if self.interaction.data == "wzzz_v__ol__yaoming_discard" then
      return to_select:getHandcardNum() >= player:getHandcardNum() and not to_select:isNude()
    else
      return to_select:getHandcardNum() <= player:getHandcardNum()
    end
  end,
  target_tip = function(self, player, to_select, selected, selected_cards, card, selectable)
    if selectable and self.interaction.data then
      return self.interaction.data
    end
  end,
  on_use = function(self, room, effect)
    local choice = self.interaction.data
    room:addPlayerMark(effect.from, choice.."-phase", 1)
    doYaoming(room, effect.from, choice, effect.tos[1])
  end,
})

yaoming:addEffect(fk.Damaged, {
  anim_type = "control",
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yaoming.name) and data.damage > 0 and #yaomingChoices(player, false) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = yaomingChoices(player, false)
    if #choices == 0 then return false end
    table.insert(choices, "Cancel")
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = yaoming.name,
      prompt = "#wzzz_v__ol__yaoming-choose",
    })
    if choice == "Cancel" then return false end
    local targets = table.filter(room:getOtherPlayers(player, false), function(p)
      if choice == "wzzz_v__ol__yaoming_discard" then
        return p:getHandcardNum() >= player:getHandcardNum() and not p:isNude()
      else
        return p:getHandcardNum() <= player:getHandcardNum()
      end
    end)
    local tos = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      skill_name = yaoming.name,
      prompt = "#wzzz_v__ol__yaoming-choose",
      cancelable = false,
    })
    event:setCostData(self, {tos = tos, choice = choice})
    return true
  end,
  on_use = function(self, event, target, player, data)
    local cost = event:getCostData(self)
    doYaoming(player.room, player, cost.choice, cost.tos[1])
  end,
})

Fk:addTargetTip({
  name = "#wzzz_v__ol__yaoming-tip",
  target_tip = function(self, player, to_select, selected, selected_cards, card, selectable)
    if not selectable then return end
    if to_select:getHandcardNum() >= player:getHandcardNum() and not to_select:isNude() then
      return "wzzz_v__ol__yaoming_discard"
    elseif to_select:getHandcardNum() <= player:getHandcardNum() then
      return "wzzz_v__ol__yaoming_draw"
    end
  end,
})

return yaoming
