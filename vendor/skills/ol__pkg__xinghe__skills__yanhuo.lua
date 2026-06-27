local yanhuo = fk.CreateSkill{
  name = "wzzz_v__ol__yanhuo",
  mode_skill = true,
}

Fk:loadTranslationTable{
  ["wzzz_v__ol__yanhuo"] = "延祸",
  [":wzzz_v__ol__yanhuo"] = "当你死亡时，你可以选择一项：1.令本局游戏【杀】造成的伤害+1；2.令伤害来源弃置至多X张牌（X为你的牌数）。",

  ["wzzz_v__ol__yanhuo_slash"] = "本局游戏【杀】造成的伤害+1",
  ["wzzz_v__ol__yanhuo_discard"] = "令伤害来源弃置至多X张牌",
  ["#wzzz_v__ol__yanhuo-invoke"] = "延祸：你可以选择一项",
  ["#wzzz_v__ol__yanhuo-discard"] = "延祸：弃置 %dest 至多%arg张牌",

  ["$wzzz_v__ol__yanhuo1"] = "是谁，泄露了我的计划？",
  ["$wzzz_v__ol__yanhuo2"] = "战斗还没结束呢！",
}

yanhuo:addEffect(fk.Death, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(yanhuo.name, false, true)
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local choices = { "wzzz_v__ol__yanhuo_slash" }
    if not player:isNude() and data.killer and not data.killer.dead and not data.killer:isNude() then
      table.insert(choices, "wzzz_v__ol__yanhuo_discard")
    end
    table.insert(choices, "Cancel")
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = yanhuo.name,
      prompt = "#wzzz_v__ol__yanhuo-invoke",
    })
    if choice ~= "Cancel" then
      if choice == "wzzz_v__ol__yanhuo_discard" then
        event:setCostData(self, {tos = {data.killer}, choice = choice})
      else
        event:setCostData(self, {choice = choice})
      end
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if event:getCostData(self).choice == "wzzz_v__ol__yanhuo_slash" then
      room:setTag("wzzz_v__ol__yanhuo_slash_plus", true)
    else
      local n = #player:getCardIds("he")
      local cards = room:askToChooseCards(player, {
        target = data.killer,
        min = 1,
        max = n,
        flag = "he",
        skill_name = yanhuo.name,
        prompt = "#wzzz_v__ol__yanhuo-discard::"..data.killer.id..":"..n,
      })
      room:throwCard(cards, yanhuo.name, data.killer, player)
    end
  end,
})

yanhuo:addEffect(fk.DamageCaused, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return player.room:getTag("wzzz_v__ol__yanhuo_slash_plus") and
      target == player and data.card and data.card.trueName == "slash" and player.room.logic:damageByCardEffect()
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
})

return yanhuo
