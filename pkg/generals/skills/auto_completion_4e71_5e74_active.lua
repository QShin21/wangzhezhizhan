local luannian_active = fk.CreateSkill {
  name = "wzzz_s__4e71_5e74_active&",
}

Fk:loadTranslationTable {
  ["wzzz_s__4e71_5e74_active&"] = "乱年",
  [":wzzz_s__4e71_5e74_active&"] = "出牌阶段限一次，你可以弃置X张牌，对“雄争”角色造成1点伤害（X为此技能本轮此前发动的次数+1）。",
  ["#wzzz_s__4e71_5e74_active"] = "乱年：弃置%arg张牌，对“雄争”角色造成1点伤害",
}

local XIONGZHENG_TARGET = "@wzzz_s__96c4_4e89-round"
local LUANNIAN_TIMES = "wzzz_s__4e71_5e74_times-round"

local function findTarget(player)
  local room = player.room
  for _, lord in ipairs(room.alive_players) do
    local id = lord:getMark(XIONGZHENG_TARGET)
    if lord:hasSkill("wzzz_s__4e71_5e74", true) and type(id) == "number" and id > 0 then
      local to = room:getPlayerById(id)
      if to and not to.dead then return lord, to end
    end
  end
end

luannian_active:addEffect("active", {
  anim_type = "offensive",
  target_num = 0,
  card_num = function(self, player)
    local lord = findTarget(player)
    return lord and lord:getMark(LUANNIAN_TIMES) + 1 or 0
  end,
  prompt = function(self, player)
    local lord = findTarget(player)
    local n = lord and lord:getMark(LUANNIAN_TIMES) + 1 or 0
    return "#wzzz_s__4e71_5e74_active:::" .. n
  end,
  can_use = function(self, player)
    local lord = findTarget(player)
    return lord and player:usedSkillTimes(luannian_active.name, Player.HistoryPhase) == 0 and
      #player:getCardIds("he") >= lord:getMark(LUANNIAN_TIMES) + 1
  end,
  card_filter = function(self, player, to_select, selected)
    local lord = findTarget(player)
    return lord and #selected < lord:getMark(LUANNIAN_TIMES) + 1 and not player:prohibitDiscard(to_select)
  end,
  on_use = function(self, room, effect)
    local player = effect.from
    local lord, to = findTarget(player)
    if not lord or not to then return end
    room:throwCard(effect.cards, luannian_active.name, player, player)
    if to.dead or player.dead then return end
    room:addPlayerMark(lord, LUANNIAN_TIMES, 1)
    room:damage {
      from = player,
      to = to,
      damage = 1,
      skillName = luannian_active.name,
    }
  end,
})

return luannian_active
