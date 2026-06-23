local gundamGongxin = fk.CreateSkill {
  name = "wzzz_v__gundam__gongxin",
}

Fk:loadTranslationTable{
  ["wzzz_v__gundam__gongxin"] = "攻心",
  [":wzzz_v__gundam__gongxin"] = "出牌阶段限一次，你可观看一名其他角色的手牌，然后你可展示其中一张牌并选择一项：" ..
  "1. 你弃置其此牌；2. 将此牌置于牌堆顶。然后若其手牌中花色数因此减少，你可令其本回合无法使用或打出一种颜色的牌。",

  ["wzzz_v__gundam__gongxin_discard"] = "弃置所选牌",
  ["wzzz_v__gundam__gongxin_put"] = "将所选牌置于牌堆顶",
  ["#wzzz_v__gundam__gongxin-ask"] = "攻心：观看%dest的手牌，可展示其中一张牌并选择一项",
  ["#wzzz_v__gundam__gongxin-dis"] = "攻心：你可令 %dest 本回合无法使用或打出一种颜色的牌",
  ["@wzzz_v__gundam__gongxin-turn"] = "攻心",

  ["$wzzz_v__gundam__gongxin1"] = "敌将虽有破军之勇，然未必有弑神之心。",
  ["$wzzz_v__gundam__gongxin2"] = "知敌所欲为，则此战已尽在掌握。",
}

local U = require "packages.wangzhezhizhan.vendor.modules.utility.utility"

gundamGongxin:addEffect("active", {
  anim_type = "control",
  can_use = function(self, player)
    return player:usedSkillTimes(gundamGongxin.name, Player.HistoryPhase) < 1
  end,
  card_num = 0,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and to_select ~= player and not to_select:isKongcheng()
  end,
  target_num = 1,
  on_use = function(self, room, effect)
    ---@type string
    local skillName = gundamGongxin.name
    local player = effect.from
    local target = effect.tos[1]
    local cids = target:getCardIds("h")
    local card_suits = {}
    table.forEach(cids, function(id)
      table.insertIfNeed(card_suits, Fk:getCardById(id).suit)
    end)
    local num = #card_suits
    local cards, choice = U.askforChooseCardsAndChoice(
      player,
      cids,
      { "wzzz_v__gundam__gongxin_discard", "wzzz_v__gundam__gongxin_put" },
      skillName,
      "#os__gongxin-ask::" .. target.id,
      { "Cancel" }
    )
    if #cards == 0 then
      return false
    end

    target:showCards(cards)
    if choice == "wzzz_v__gundam__gongxin_discard" then
      room:throwCard(cards, skillName, target, player)
    else
      room:moveCardTo(cards, Card.DrawPile, nil, fk.ReasonPut, skillName, nil, false, player)
    end
    card_suits = {}
    cids = target:getCardIds("h")
    table.forEach(cids, function(id)
      table.insertIfNeed(card_suits, Fk:getCardById(id).suit)
    end)
    local num2 = #card_suits
    if num > num2 and player:isAlive() and target:isAlive() then
      choice = room:askToChoice(
        player,
        {
          choices = { "red", "black" },
          skill_name = skillName,
          prompt = "#wzzz_v__gundam__gongxin-dis::" .. target.id,
        }
      )
      if choice ~= "Cancel" then
        room:addTableMarkIfNeed(target, "@wzzz_v__gundam__gongxin-turn", choice)
      end
    end
  end,
})

gundamGongxin:addEffect("prohibit", {
  prohibit_use = function(self, player, card)
    if player:getMark("@wzzz_v__gundam__gongxin-turn") ~= 0 then
      return table.contains(player:getMark("@wzzz_v__gundam__gongxin-turn"), card:getColorString())
    end
  end,
  prohibit_response = function(self, player, card)
    if player:getMark("@wzzz_v__gundam__gongxin-turn") ~= 0 then
      return table.contains(player:getMark("@wzzz_v__gundam__gongxin-turn"), card:getColorString())
    end
  end,
})

return gundamGongxin
