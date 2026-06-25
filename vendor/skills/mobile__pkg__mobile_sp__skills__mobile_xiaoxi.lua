local mobileXiaoxi = fk.CreateSkill {
  name = "wzzz_v__mobile__xiaoxi",
}

Fk:loadTranslationTable{
  ["wzzz_v__mobile__xiaoxi"] = "骁袭",
  [":wzzz_v__mobile__xiaoxi"] = "体力值大于你的角色的结束阶段，若其本回合使用过【杀】，你可以将一张黑色牌当【杀】对其使用（有距离限制）。",

  ["#wzzz_v__mobile__xiaoxi"] = "骁袭：你可以将一张黑色牌当【杀】对 %dest 使用",

  ["$wzzz_v__mobile__xiaoxi1"] = "看你如何躲过！",
  ["$wzzz_v__mobile__xiaoxi2"] = "小贼受死！",
}

mobileXiaoxi:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "slash",
  prompt = "#wzzz_v__mobile__xiaoxi",
  handly_pile = true,
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".|.|black",
  },
  view_as = function(self, player, cards)
    if #cards ~= 1 then return nil end
    local c = Fk:cloneCard("slash")
    c.skillName = mobileXiaoxi.name
    c:addSubcard(cards[1])
    return c
  end,
  enabled_at_play = Util.FalseFunc,
  enabled_at_response = Util.FalseFunc,
  enabled_at_nullification = Util.FalseFunc,
})

mobileXiaoxi:addEffect(fk.EventPhaseStart, {
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if target == player or not player:hasSkill(mobileXiaoxi.name) or target.phase ~= Player.Finish or
      target.hp <= player.hp then
      return false
    end
    local room = player.room
    local slash = Fk:cloneCard("slash")
    slash.skillName = mobileXiaoxi.name
    return player:canUseTo(slash, target) and
      table.find(player:getHandlyIds(), function(id) return Fk:getCardById(id).color == Card.Black end) and
      #room.logic:getEventsOfScope(GameEvent.UseCard, 1, function(e)
        local use = e.data
        return use.from == target and use.card and use.card.trueName == "slash"
      end, Player.HistoryTurn) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local tos, cards = player.room:askToChooseCardsAndPlayers(player, {
      min_card_num = 1,
      max_card_num = 1,
      min_num = 1,
      max_num = 1,
      targets = { target },
      pattern = ".|.|black",
      skill_name = mobileXiaoxi.name,
      prompt = "#wzzz_v__mobile__xiaoxi::" .. target.id,
      will_throw = true,
      cancelable = true,
    })
    if #tos > 0 and #cards > 0 then
      event:setCostData(self, { tos = tos, cards = cards })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:useVirtualCard("slash", event:getCostData(self).cards, player, target, mobileXiaoxi.name, false)
  end,
})

return mobileXiaoxi
