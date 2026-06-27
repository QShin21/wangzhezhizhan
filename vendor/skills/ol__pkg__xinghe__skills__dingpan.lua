local dingpan = fk.CreateSkill{
  name = "wzzz_v__dingpan",
}

Fk:loadTranslationTable{
  ["wzzz_v__dingpan"] = "定叛",
  [":wzzz_v__dingpan"] = "出牌阶段限X次（X为存活角色最多阵营的存活角色数且至多为3），你可以令一名装备区里有牌的角色摸一张牌，然后其选择一项：1.令你弃置其一至两张牌；"..
  "2.获得装备区里的所有牌，然后你对其造成1点伤害。",

  ["#wzzz_v__dingpan"] = "定叛：令一名装备区里有牌的角色摸一张牌，然后其选择弃牌或收回装备并受到你造成的伤害",
  ["wzzz_v__dingpan_discard"] = "%src弃置你的一至两张牌",
  ["wzzz_v__dingpan_damage"] = "收回所有装备，%src对你造成1点伤害",

  ["$wzzz_v__dingpan1"] = "从孙者生，从刘者死！",
  ["$wzzz_v__dingpan2"] = "多行不义必自毙！",
}

local function maxRoleCount(room)
  local counts = {}
  for _, p in ipairs(room.alive_players) do
    counts[p.role] = (counts[p.role] or 0) + 1
  end
  local n = 0
  for _, count in pairs(counts) do
    n = math.max(n, count)
  end
  return math.min(3, n)
end

dingpan:addEffect("active", {
  anim_type = "offensive",
  prompt = "#wzzz_v__dingpan",
  card_num = 0,
  target_num = 1,
  times = function(self, player)
    return player.phase == Player.Play and
      maxRoleCount(Fk:currentRoom()) - player:usedSkillTimes(dingpan.name, Player.HistoryPhase) or -1
  end,
  can_use = function(self, player)
    return player:usedSkillTimes(dingpan.name, Player.HistoryPhase) < maxRoleCount(Fk:currentRoom())
  end,
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0 and #to_select:getCardIds("e") > 0
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local target = effect.tos[1]
    target:drawCards(1, dingpan.name)
    if target.dead then return end
    local choices = {"wzzz_v__dingpan_damage:"..player.id}
    if not target:isNude() and not player.dead then
      table.insert(choices, 1, "wzzz_v__dingpan_discard:"..player.id)
    end
    local choice = room:askToChoice(target, {
      choices = choices,
      skill_name = dingpan.name,
    })
    if choice:startsWith("wzzz_v__dingpan_discard") then
      local cards = room:askToChooseCards(player, {
        target = target,
        min = 1,
        max = 2,
        flag = "he",
        skill_name = dingpan.name,
      })
      room:throwCard(cards, dingpan.name, target, player)
    else
      room:moveCardTo(target:getCardIds("e"), Card.PlayerHand, target, fk.ReasonJustMove, dingpan.name, nil, true, target)
      if not target.dead then
        room:damage{
          from = player,
          to = target,
          damage = 1,
          skillName = dingpan.name,
        }
      end
    end
  end,
})

return dingpan
