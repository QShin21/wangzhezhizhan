local guanxing = fk.CreateSkill{
  name = "wzzz_v__ex__guanxing",
  derived_piles = "wzzz_v__ex__guanxing_star",
}

Fk:loadTranslationTable{
  ["wzzz_v__ex__guanxing"] = "观星",
  [":wzzz_v__ex__guanxing"] = "准备阶段，你可以观看牌堆顶的X张牌，若“星”的数量小于X，你可以将其中一张牌置于武将牌上，称为“星”，然后将其余牌以任意顺序置于牌堆顶或牌堆底。若你将其余牌均置于牌堆底或你未发动“知天”时未因此法获得“星”，结束阶段，你可以再发动一次“观星”。（X为5，角色数为2时改为3）",

  ["wzzz_v__ex__guanxing_star"] = "星",
  ["#wzzz_v__ex__guanxing-star"] = "观星：你可以将其中一张牌置为“星”",

  ["$wzzz_v__ex__guanxing1"] = "天星之变，吾窥探一二。",
  ["$wzzz_v__ex__guanxing2"] = "星途莫测，细细推敲。",
}

local function guanxingNum(room)
  return #room.alive_players == 2 and 3 or 5
end

guanxing:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(guanxing.name) and
      (player.phase == Player.Start or
      (player.phase == Player.Finish and player:getMark("wzzz_v__ex__guanxing_extra-turn") > 0))
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local x = guanxingNum(room)
    local cards = room:getNCards(x)
    local gainedStar = false

    if #player:getPile("wzzz_v__ex__guanxing_star") < x then
      local chosen = room:askToChooseCards(player, {
        min = 1,
        max = 1,
        flag = { card_data = {{"Top", cards}} },
        prompt = "#wzzz_v__ex__guanxing-star",
        skill_name = guanxing.name,
        cancelable = true,
      })
      if #chosen > 0 then
        gainedStar = true
        table.removeOne(cards, chosen[1])
        player:addToPile("wzzz_v__ex__guanxing_star", chosen[1], true, guanxing.name, player)
      end
    end

    local result = room:askToGuanxing(player, { cards = cards })
    if player.phase == Player.Start then
      if #result.top == 0 then
        room:setPlayerMark(player, "wzzz_v__ex__guanxing_extra-turn", 1)
      elseif not gainedStar and player:getMark("wzzz_v__zhitian_used-turn") == 0 then
        room:setPlayerMark(player, "wzzz_v__ex__guanxing_extra-turn", 2)
      end
    end
  end,
})

return guanxing
