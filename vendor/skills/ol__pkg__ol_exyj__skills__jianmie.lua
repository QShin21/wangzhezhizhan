
local jianmie = fk.CreateSkill{
  name = "wzzz_v__jianmie",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__jianmie"] = "翦灭",
  [":wzzz_v__jianmie"] = "限定技，出牌阶段，你可以令一名其他角色选择一种颜色，然后你选择一种颜色，你与其展示所有手牌并弃置各自所选颜色的全部手牌（没有该颜色则不弃），然后弃置牌较多的角色视为对另一名角色使用一张【决斗】。",

  ["#wzzz_v__jianmie"] = "翦灭：令一名其他角色选择一种颜色，然后你选择一种颜色，双方展示手牌并弃置对应颜色手牌",
  ["#wzzz_v__jianmie-choice"] = "翦灭：选择一种颜色的手牌弃置，弃牌多的角色视为对对方使用【决斗】！",
  ["#wzzz_v__jianmie-target-choice"] = "翦灭：请先选择一种颜色的手牌弃置",

  ["$wzzz_v__jianmie1"] = "莫说是你，天潢贵胄亦可杀得！",
  ["$wzzz_v__jianmie2"] = "你我不到黄泉，不复相见！",
}

jianmie:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__jianmie",
  card_num = 0,
  target_num = 1,
  can_use = function(self, player)
    return player:usedSkillTimes(jianmie.name, Player.HistoryGame) == 0
  end,
  card_filter = Util.FalseFunc,
  target_filter = function (self, player, to_select, selected, selected_cards)
    return #selected == 0 and to_select ~= player
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    local target_choice = room:askToChoice(target, {
      choices = {"red", "black"},
      skill_name = jianmie.name,
      prompt = "#wzzz_v__jianmie-target-choice",
    })
    local player_choice = room:askToChoice(player, {
      choices = {"red", "black"},
      skill_name = jianmie.name,
      prompt = "#wzzz_v__jianmie-choice",
    })
    player:showCards(player:getCardIds("h"))
    if not target.dead then
      target:showCards(target:getCardIds("h"))
    end
    local cards1 = table.filter(player:getCardIds("h"), function (id)
      return Fk:getCardById(id):getColorString() == player_choice and
        not player:prohibitDiscard(id)
    end)
    local cards2 = table.filter(target:getCardIds("h"), function (id)
      return Fk:getCardById(id):getColorString() == target_choice and
        not target:prohibitDiscard(id)
    end)
    local moves = {}
    if #cards1 > 0 then
      table.insert(moves, {
        ids = cards1,
        from = player,
        toArea = Card.DiscardPile,
        moveReason = fk.ReasonDiscard,
        proposer = player,
        skillName = jianmie.name,
      })
    end
    if #cards2 > 0 then
      table.insert(moves, {
        ids = cards2,
        from = target,
        toArea = Card.DiscardPile,
        moveReason = fk.ReasonDiscard,
        proposer = target,
        skillName = jianmie.name,
      })
    end
    if #moves > 0 then
      room:moveCards(table.unpack(moves))
    end
    local src, to = player, player
    if #cards1 > #cards2 then
      src, to = player, target
    elseif #cards1 < #cards2 then
      src, to = target, player
    end
    if src ~= to and not to.dead then
      room:useVirtualCard("duel", nil, src, to, jianmie.name)
    end
  end,
})

return jianmie
