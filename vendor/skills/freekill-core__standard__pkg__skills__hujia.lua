local hujia = fk.CreateSkill {
  name = "wzzz_v__hujia",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable {
  ["wzzz_v__hujia"] = "护驾",
  [":wzzz_v__hujia"] = "主公技，当你需要使用或打出【闪】时，你可以令其他魏势力角色选择是否替你使用或打出【闪】（视为由你使用或打出）；其他魏势力角色于其回合外使用、打出或替你使用或打出【闪】时，其可以令你摸一张牌（每回合限一次）。",
  ["#wzzz_v__hujia-ask"] = "护驾：你可以替 %src 打出一张【闪】",
  ["#wzzz_v__hujia-invoke"] = "护驾：是否令 %src 摸一张牌？",
}

local function askHujiaDraw(helper, lord)
  local room = lord.room
  if helper.dead or lord.dead or room.current == helper or helper:getMark("wzzz_v__hujia_draw-turn") > 0 then return end
  if room:askToSkillInvoke(helper, {
    skill_name = hujia.name,
    prompt = "#wzzz_v__hujia-invoke:" .. lord.id,
  }) then
    room:doIndicate(helper.id, { lord.id })
    room:addPlayerMark(helper, "wzzz_v__hujia_draw-turn")
    lord:drawCards(1, hujia.name)
  end
end

local hujia_spec = {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(hujia.name) and
        Exppattern:Parse(data.pattern):matchExp("jink") and
        (data.extraData == {} or (data.extraData.hujia_ask == nil and data.extraData.not_passive ~= true)) and
        not table.every(player.room.alive_players, function(p)
          return p == player or p.kingdom ~= "wei"
        end)
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    for _, p in ipairs(room:getOtherPlayers(player)) do
      if p:isAlive() and p.kingdom == "wei" then
        local params = { ---@type AskToUseCardParams
          skill_name = "jink",
          pattern = "jink",
          prompt = "#wzzz_v__hujia-ask:" .. player.id,
          cancelable = true,
          extra_data = { hujia_ask = true }
        }
        local respond = room:askToResponse(p, params)
        if respond then
          respond.skipDrop = true
          room:responseCard(respond)
          askHujiaDraw(p, player)

          local new_card = Fk:cloneCard('jink')
          new_card.skillName = hujia.name
          new_card:addSubcards(room:getSubcardsByRule(respond.card, { Card.Processing }))
          local result = {
            from = player,
            card = new_card,
          }
          if event == fk.AskForCardUse then
            result.tos = {}
          end
          data.result = result
          return true
        end
      end
    end
  end,
}

hujia:addEffect(fk.AskForCardUse, hujia_spec)
hujia:addEffect(fk.AskForCardResponse, hujia_spec)

local hujia_draw_spec = {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(hujia.name) and target ~= player and not target.dead and target.kingdom == "wei" and
      player.room.current ~= target and target:getMark("wzzz_v__hujia_draw-turn") == 0 and
      data.card and data.card.trueName == "jink"
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(target, {
      skill_name = hujia.name,
      prompt = "#wzzz_v__hujia-invoke:" .. player.id,
    }) then
      player.room:doIndicate(target.id, { player.id })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:addPlayerMark(target, "wzzz_v__hujia_draw-turn")
    player:drawCards(1, hujia.name)
  end,
}

hujia:addEffect(fk.CardUsing, hujia_draw_spec)
hujia:addEffect(fk.CardResponding, hujia_draw_spec)

hujia:addAI(Fk.Ltk.AI.newInvokeStrategy {
  think = function(self, ai)
    for _, p in ipairs(ai.player.room.alive_players) do
      if ai:isFriend(p) and p.kingdom == "wei" and
          (p:hasSkill("#eight_diagram_skill") or #table.filter(ai.player:getHandlyIds(), function(cid)
            return Fk:getCardById(cid).trueName == "jink"
          end) <= 1) then
        return true
      end
    end
    return false
  end,
})

return hujia
