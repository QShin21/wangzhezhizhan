local zhitian = fk.CreateSkill{
  name = "wzzz_v__zhitian",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__zhitian"] = "知天",
  [":wzzz_v__zhitian"] = "限定技，出牌阶段，你可以获得所有“星”，然后可以弃置你装备区里的武器牌，若“星”数星不小于X，则本回合当你装备区没有武器牌时，你视为装备【诸葛连弩】。（X为5，角色数为2时改为3）",

  ["#wzzz_v__zhitian"] = "知天：获得所有“星”",
  ["#wzzz_v__zhitian-discard"] = "知天：你可以弃置装备区里的武器牌",
  ["@@wzzz_v__zhitian_crossbow-turn"] = "知天",

  ["$wzzz_v__zhitian1"] = "天火熊熊，再兴炎汉国祚！",
  ["$wzzz_v__zhitian2"] = "地火愔愔，燎尽不臣之贼！",
}

local function zhitianNum(room)
  return #room.alive_players == 2 and 3 or 5
end

zhitian:addEffect("active", {
  anim_type = "control",
  prompt = "#wzzz_v__zhitian",
  card_num = 0,
  target_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(zhitian.name, Player.HistoryGame) == 0 and
      #player:getPile("wzzz_v__ex__guanxing_star") > 0
  end,
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    local stars = player:getPile("wzzz_v__ex__guanxing_star")
    local n = #stars
    room:setPlayerMark(player, "wzzz_v__zhitian_used-turn", 1)
    if player:getMark("wzzz_v__ex__guanxing_extra-turn") == 2 then
      room:setPlayerMark(player, "wzzz_v__ex__guanxing_extra-turn", 0)
    end
    room:obtainCard(player, stars, true, fk.ReasonJustMove, player, zhitian.name)
    if player.dead then return end

    local weapons = player:getEquipments(Card.SubtypeWeapon)
    if #weapons > 0 and room:askToSkillInvoke(player, {
      skill_name = zhitian.name,
      prompt = "#wzzz_v__zhitian-discard",
    }) then
      room:throwCard(weapons[1], zhitian.name, player, player)
    end

    if not player.dead and n >= zhitianNum(room) then
      room:addPlayerMark(player, "@@wzzz_v__zhitian_crossbow-turn")
    end
  end,
})

zhitian:addEffect("targetmod", {
  bypass_times = function(self, player, skill, scope, card)
    return player:hasSkill(zhitian.name) and player:getMark("@@wzzz_v__zhitian_crossbow-turn") > 0 and
      #player:getEquipments(Card.SubtypeWeapon) == 0 and card and skill.trueName == "slash_skill" and
      scope == Player.HistoryPhase
  end,
})

return zhitian
