
local qinwang = fk.CreateSkill {
  name = "wzzz_v__qinwang",
}

Fk:loadTranslationTable{
  ["wzzz_v__qinwang"] = "勤王",
  [":wzzz_v__qinwang"] = "主公技，当你需要使用或打出【杀】时，你可以弃置一张牌，然后令其他蜀势力角色选择是否打出一张【杀】（视为由你使用或打出）。"..
  "若有角色响应，该角色摸一张牌。",

  ["#wzzz_v__qinwang"] = "勤王：你可以弃置一张牌发动“激将”",
  ["#wzzz_v__qinwang-ask"] = "勤王：你可以替 %src 打出一张【杀】，然后摸一张牌",

  ["$wzzz_v__qinwang1"] = "大厦倾危，谁堪栋梁！",
  ["$wzzz_v__qinwang2"] = "国有危难，哪位将军请战？",
}

Fk:loadTranslationTable{
  ["wzzz_v__qinwang"] = "勤王",
  [":wzzz_v__qinwang"] = "每回合限一次，当你需要打出【杀】时，你可以弃置一张牌，然后令其他角色依次选择是否打出【杀】（视为由你打出），响应的角色摸一张牌。",
  ["#wzzz_v__qinwang"] = "勤王：弃置一张牌，令其他角色依次选择是否替你打出【杀】",
  ["#wzzz_v__qinwang-ask"] = "勤王：你可以替 %src 打出一张【杀】，然后摸一张牌",
}

qinwang:addEffect("viewas", {
  anim_type = "defensive",
  pattern = "slash",
  prompt = "#wzzz_v__qinwang",
  filter_pattern = {
    min_num = 1,
    max_num = 1,
    pattern = ".",
  },
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and not player:prohibitDiscard(to_select)
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 then return end
    local card = Fk:cloneCard("slash")
    card.skillName = qinwang.name
    card:addFakeSubcards(cards)
    return card
  end,
  before_use = function(self, player, use)
    local room = player.room
    room:throwCard(use.card.fake_subcards, qinwang.name, player, player)
    for _, p in ipairs(room:getOtherPlayers(player)) do
      local respond = room:askToResponse(p, {
        skill_name = qinwang.name,
        pattern = "slash",
        prompt = "#wzzz_v__qinwang-ask:"..player.id,
        cancelable = true,
      })
      if respond then
        respond.skipDrop = true
        room:responseCard(respond)
        use.card = respond.card
        use.extra_data = use.extra_data or {}
        use.extra_data.qinwang = p
        return
      end
    end
    return ""
  end,
  after_use = function(self, player, use)
    if use.extra_data and use.extra_data.qinwang then
      if not use.extra_data.qinwang.dead then
        use.extra_data.qinwang:drawCards(1, qinwang.name)
      end
    end
  end,
  enabled_at_play = function(self, player)
    return false
  end,
  enabled_at_response = function(self, player)
    return player:usedSkillTimes(qinwang.name, Player.HistoryTurn) == 0 and not player:isNude() and
      table.find(Fk:currentRoom().alive_players, function(p)
        return p ~= player
      end)
  end,
})

qinwang:addAI(nil, "vs_skill")

return qinwang
