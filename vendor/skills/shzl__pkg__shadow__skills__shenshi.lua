local wzzz_v__shenshi = fk.CreateSkill {
  name = "wzzz_v__shenshi",
}

Fk:loadTranslationTable{
  ["wzzz_v__shenshi"] = "审时",
  [":wzzz_v__shenshi"] = "当你受到其他角色造成的伤害后，你可以观看其手牌，然后交给其一张牌并展示之（本回合明置于其手牌区），当前回合结束时，若其未失去此牌，你将手牌摸至四张。",
  ["#wzzz_v__shenshi-invoke"] = "审时：你可以观看 %dest 的手牌并交给其一张牌",
  ["#wzzz_v__shenshi-give"] = "审时：交给 %dest 一张牌，若本回合结束阶段仍属于其，你将手牌摸至四张",

  ["$wzzz_v__shenshi1"] = "深中足智，鉴时审情。",
  ["$wzzz_v__shenshi2"] = "数语之言，审时度势。",
}

wzzz_v__shenshi:addEffect(fk.Damaged, {
  anim_type = "masochism",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__shenshi.name) and
      data.from and data.from ~= player and not data.from.dead and not data.from:isKongcheng()
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = wzzz_v__shenshi.name,
      prompt = "#wzzz_v__shenshi-invoke::"..data.from.id,
    }) then
      event:setCostData(self, {tos = {data.from}})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    if not data.from:isKongcheng() then
      room:viewCards(player, { cards = data.from:getCardIds("h"), skill_name = wzzz_v__shenshi.name, prompt = "$ViewCardsFrom:"..data.from.id })
    end
    if player:isNude() then return end
    local card = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      include_equip = true,
      skill_name = wzzz_v__shenshi.name,
      prompt = "#wzzz_v__shenshi-give::"..data.from.id,
      cancelable = false,
    })
    room:addTableMark(player, "wzzz_v__shenshi-turn", {data.from.id, card[1]})
    player:showCards(card)
    room:obtainCard(data.from, card, true, fk.ReasonGive, player, wzzz_v__shenshi.name)
  end,
})
wzzz_v__shenshi:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    if target.phase == Player.Finish and player:getMark("wzzz_v__shenshi-turn") ~= 0 and player:getHandcardNum() < 4 then
      for _, t in ipairs(player:getMark("wzzz_v__shenshi-turn")) do
        local p = player.room:getPlayerById(t[1])
        if p and table.contains(p:getCardIds("he"), t[2]) then
          return true
        end
      end
    end
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(4 - player:getHandcardNum(), wzzz_v__shenshi.name)
  end,
})

return wzzz_v__shenshi
