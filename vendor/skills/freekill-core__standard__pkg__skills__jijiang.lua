local jijiang = fk.CreateSkill {
  name = "wzzz_v__jijiang",
  tags = { Skill.Lord },
}

Fk:loadTranslationTable {
  ["wzzz_v__jijiang"] = "激将",
  [":wzzz_v__jijiang"] = "主公技，你可以令其他蜀势力角色在你需要使用或打出【杀】时，依次选择是否打出一张【杀】（视为由你使用或打出），然后其可以令你摸一张牌（每回合限一次）。",
  ["#wzzz_v__jijiang-ask"] = "激将：你可以替 %src 打出一张【杀】",
  ["#wzzz_v__jijiang-invoke"] = "激将：是否令 %src 摸一张牌？",
  ["wzzz_v__jijiang_failed-phase"] = "激将失败",
}

local function askJijiangDraw(helper, lord)
  local room = lord.room
  if helper.dead or lord.dead or room.current == helper or helper:getMark("wzzz_v__jijiang_draw-turn") > 0 then return end
  if room:askToSkillInvoke(helper, {
    skill_name = jijiang.name,
    prompt = "#wzzz_v__jijiang-invoke:" .. lord.id,
  }) then
    room:doIndicate(helper.id, { lord.id })
    room:addPlayerMark(helper, "wzzz_v__jijiang_draw-turn")
    lord:drawCards(1, jijiang.name)
  end
end

local function makeJijiangCard(room, respond)
  local card = Fk:cloneCard(respond.card.name, respond.card.suit, respond.card.number)
  card.skillName = jijiang.name
  card:addSubcards(room:getSubcardsByRule(respond.card, { Card.Processing }))
  return card
end

jijiang:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "slash",
  card_filter = Util.FalseFunc,
  view_as = function(self, player, cards)
    if #cards ~= 0 then return end
    local c = Fk:cloneCard("slash")
    c.skillName = jijiang.name
    return c
  end,
  before_use = function(self, player, use)
    local room = player.room
    if use.tos then
      room:doIndicate(player.id, table.map(use.tos, Util.IdMapper))
    end

    for _, p in ipairs(room:getOtherPlayers(player)) do
      if p.kingdom == "shu" then
        local respond = room:askToResponse(p, {
          skill_name = jijiang.name,
          pattern = "slash",
          prompt = "#wzzz_v__jijiang-ask:"..player.id,
          cancelable = true,
        })
        if respond then
          respond.skipDrop = true
          room:responseCard(respond)
          askJijiangDraw(p, player)

          use.card = makeJijiangCard(room, respond)
          return
        end
      end
    end

    room:setPlayerMark(player, "wzzz_v__jijiang_failed-phase", 1)
    return jijiang.name
  end,
  enabled_at_play = function(self, player)
    return player:getMark("wzzz_v__jijiang_failed-phase") == 0 and
      table.find(Fk:currentRoom().alive_players, function(p)
        return p.kingdom == "shu" and p ~= player
      end)
  end,
  enabled_at_response = function(self, player)
    return table.find(Fk:currentRoom().alive_players, function(p)
      return p.kingdom == "shu" and p ~= player
    end)
  end,
})

return jijiang
