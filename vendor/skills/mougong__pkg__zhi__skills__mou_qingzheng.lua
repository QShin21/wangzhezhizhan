local mouQingzheng = fk.CreateSkill({
  name = "wzzz_v__mou__qingzheng",
})

Fk:loadTranslationTable{
  ["wzzz_v__mou__qingzheng"] = "清正",
  [":wzzz_v__mou__qingzheng"] = "出牌阶段开始时，你可以弃置你手牌中一种花色的所有牌并选择一名其他角色观看你的手牌，然后你观看其手牌并弃置其中一种花色的所有牌；若其被弃置的牌数小于你弃置的牌数，你对其造成1点伤害。",

  ["#wzzz_v__mou__qingzheng-card"] = "清正：你可弃置一种花色的所有手牌",
  ["#wzzz_v__mou__qingzheng-choose"] = "清正：选择一名其他角色，其观看你的手牌，然后你观看并弃置其一种花色的手牌",
  ["#wzzz_v__mou__qingzheng-throw"] = "清正：弃置 %dest 一种花色的手牌，若弃置张数小于 %arg，对其造成伤害",

  ["$wzzz_v__mou__qingzheng1"] = "立威行严法，肃佞正国纲！",
  ["$wzzz_v__mou__qingzheng2"] = "悬杖分五色，治法扬清名。",
}

local U = require "packages.wangzhezhizhan.vendor.modules.utility.utility"

local suitNames = { "log_spade", "log_club", "log_heart", "log_diamond" }
local suitIndex = {
  [Card.Spade] = 1,
  [Card.Club] = 2,
  [Card.Heart] = 3,
  [Card.Diamond] = 4,
}

local function getSuitCardLists(player, discardable)
  local listCards = { {}, {}, {}, {} }
  for _, id in ipairs(player:getCardIds("h")) do
    local suit = Fk:getCardById(id).suit
    local index = suitIndex[suit]
    if index and (not discardable or not player:prohibitDiscard(id)) then
      table.insertIfNeed(listCards[index], id)
    end
  end
  return listCards
end

mouQingzheng:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return
      target == player and
      player:hasSkill(mouQingzheng.name) and
      player.phase == Player.Play and
      table.find(player.room:getOtherPlayers(player, false), function() return true end) and
      table.find(player:getCardIds("h"), function(id)
        local suit = Fk:getCardById(id).suit
        return suitIndex[suit] and not player:prohibitDiscard(id)
      end)
  end,
  on_cost = function(self, event, target, player, data)
    ---@type string
    local skillName = mouQingzheng.name
    local room = player.room
    local targets = room:getOtherPlayers(player, false)
    local choices = U.askForChooseCardList(room, player, suitNames, getSuitCardLists(player, true), 1, 1, skillName, "#wzzz_v__mou__qingzheng-card")
    if #choices == 1 then
      local to = room:askToChoosePlayers(
        player,
        {
          targets = targets,
          min_num = 1,
          max_num = 1,
          prompt = "#wzzz_v__mou__qingzheng-choose",
          skill_name = skillName
        }
      )
      if #to > 0 then
        event:setCostData(self, { choices[1], to[1] })
        return true
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    ---@type string
    local skillName = mouQingzheng.name
    local room = player.room
    local costData = event:getCostData(self)
    local choice = costData[1]
    local to = costData[2]

    local my_throw = table.filter(player:getCardIds("h"), function (id)
      return not player:prohibitDiscard(id) and Fk:getCardById(id):getSuitString(true) == choice
    end)
    room:throwCard(my_throw, skillName, player, player)
    if player.dead or to.dead then return end
    room:doIndicate(player.id, { to.id })
    if not player:isKongcheng() then
      room:viewCards(to, { cards = player:getCardIds("h"), skill_name = skillName, prompt = "$ViewCardsFrom:" .. player.id })
    end
    local to_throw = {}
    if not to:isKongcheng() then
      room:viewCards(player, { cards = to:getCardIds("h"), skill_name = skillName, prompt = "$ViewCardsFrom:" .. to.id })
      local listCards = getSuitCardLists(to, true)
      local choice = U.askForChooseCardList(
        room,
        player,
        suitNames,
        listCards,
        1,
        1,
        skillName,
        "#wzzz_v__mou__qingzheng-throw::" .. to.id .. ":" .. #my_throw,
        false,
        false
      )
      if #choice == 1 then
        to_throw = table.filter(to:getCardIds("h"), function(id)
          return Fk:getCardById(id):getSuitString(true) == choice[1] and not to:prohibitDiscard(id)
        end)
      end
    end
    if #to_throw > 0 then
      room:throwCard(to_throw, skillName, to, player)
    end
    if #my_throw > #to_throw then
      if not to.dead then
        room:damage{ from = player, to = to, damage = 1, skillName = skillName }
      end
    end
  end,
})

return mouQingzheng
