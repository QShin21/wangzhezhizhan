local WZ_GENERALS_PACKAGE = "wangzhezhizhanwujiang"
local CHOOSE_TIMEOUT = 60
local LORD_CANDIDATE_COUNT = 4
local NON_LORD_CANDIDATE_COUNT = 6
local LORD_EXTRA_COUNT = 3

local function same_title_general(a, b)
  local ga, gb = Fk.generals[a], Fk.generals[b]
  if not ga or not gb then return a == b end
  return (ga.trueName or ga.name) == (gb.trueName or gb.name) and (ga.title or "") == (gb.title or "")
end

local function is_wangzhe_general(name)
  local g = Fk.generals[name]
  if not g then return false end
  local pkg = g.package or g.packageName or (g.package and g.package.name)
  if type(pkg) == "table" then pkg = pkg.name end
  return pkg == WZ_GENERALS_PACKAGE or string.find(name, "^wz__") ~= nil or string.find(name, "^wangzhe__") ~= nil
end

local function is_lord_general(name)
  local g = Fk.generals[name]
  if not g then return false end
  if table.contains(Fk.lords or {}, name) then return true end
  return table.find(g.skills or {}, function(s) return s:hasTag(Skill.Lord) end) ~= nil or
    table.find(g.other_skills or {}, function(s) return Fk.skills[s] and Fk.skills[s]:hasTag(Skill.Lord) end) ~= nil
end

local function pick_unique(room, source, n, excludes)
  local picked, pool = {}, table.simpleClone(source)
  room:shuffleTable(pool)
  for _, name in ipairs(pool) do
    if #picked >= n then break end
    local duplicated = table.find(picked, function(p) return same_title_general(p, name) end) or
      table.find(excludes or {}, function(p) return same_title_general(p, name) end)
    if not duplicated then table.insert(picked, name) end
  end
  return picked
end

local function wangzhe_getlogic()
  local logic = GameLogic:subclass("wangzhe_role_logic")

  function logic:initialize(room)
    GameLogic.initialize(self, room)
    self.role_table[6] = { "lord", "loyalist", "rebel", "rebel", "rebel", "renegade" }
    self.role_table[8] = { "lord", "loyalist", "loyalist", "rebel", "rebel", "rebel", "rebel", "renegade" }
  end

  function logic:chooseGenerals()
    local room = self.room
    local n = room:getSettings('enableDeputy') and 2 or 1
    local lord = room:getLord()
    local old_timeout = room.settings.generalTimeout
    room.settings.generalTimeout = CHOOSE_TIMEOUT

    local all = room:findGenerals(function(name) return is_wangzhe_general(name) end, 9999)
    local lord_pool = table.filter(all, is_lord_general)
    local non_lord_pool = table.filter(all, function(name) return not is_lord_general(name) end)

    if lord then
      room:setCurrent(lord)
      local lord_candidates = pick_unique(room, lord_pool, LORD_CANDIDATE_COUNT, {})
      local extra_candidates = pick_unique(room, non_lord_pool, LORD_EXTRA_COUNT, lord_candidates)
      local generals = table.connect(lord_candidates, extra_candidates)
      local chosen = room:askToChooseGeneral(lord, {
        generals = generals,
        n = n,
        no_convert = true,
        prompt = "#wangzhe_choose_lord",
        extra_data = { lord_count = LORD_CANDIDATE_COUNT, upper = lord_candidates, lower = extra_candidates },
      })
      local lord_general, deputy = type(chosen) == "table" and chosen[1] or chosen, type(chosen) == "table" and chosen[2] or nil
      room:prepareGeneral(lord, lord_general, deputy, true)
      room:askToChooseKingdom({ lord })
      room:broadcastProperty(lord, "kingdom")
    end

    local lord_general = lord and lord.general
    local nonlord = room:getOtherPlayers(lord, true)
    local req = Request:new(nonlord, "AskForGeneral")
    req.timeout = CHOOSE_TIMEOUT
    for _, p in ipairs(nonlord) do
      local generals = pick_unique(room, non_lord_pool, NON_LORD_CANDIDATE_COUNT, lord_general and { lord_general } or {})
      req:setData(p, { generals, n, true, false, "askForGeneralsChosen", "#wangzhe_choose_nonlord", { n = n } })
      req:setDefaultReply(p, room:tableRandomPick(generals, n))
    end
    for _, p in ipairs(nonlord) do
      local result = req:getResult(p)
      local general, deputy = result[1], result[2]
      room:prepareGeneral(p, general, deputy)
    end
    room:askToChooseKingdom(nonlord)
    room.settings.generalTimeout = old_timeout
  end

  return logic
end

local rule = fk.CreateSkill { name = "#wangzhe_role_rule&" }

local function rebels_all_dead(room)
  return not table.find(room.players, function(p) return not p.dead and (p.role == "rebel" or p.role == "rebel_chief") end)
end

rule:addEffect(fk.GameStart, {
  priority = 10,
  can_trigger = function(self, event, target, player) return target == player and player.role == "lord" end,
  on_use = function(self, event, target, player)
    local room = player.room
    local marks = { "@wangzhe_suzaku", "@wangzhe_xuanwu", "@wangzhe_qinglong", "@wangzhe_baihu" }
    local choice = room:askToChoice(player, { choices = marks, skill_name = rule.name, prompt = "#wangzhe_sixiang_choose" }) or marks[math.random(#marks)]
    room:setPlayerMark(player, choice, 1)
    room:setTag("wangzhe_sixiang", choice)
  end,
})

rule:addEffect(fk.TurnEnd, {
  priority = -10,
  can_trigger = function(self, event, target, player)
    local room = player.room
    return target == player and room:getBanner("RoundCount") and
      room:getBanner("RoundCount") > (#room.players == 6 and 4 or 3)
  end,
  on_use = function(self, event, target, player)
    local room = player.room
    room:setPlayerMark(player, "@@wangzhe_aozhan_invalid", 1)
    local cards = player:getCardIds("he")
    if #cards >= 2 then
      local choices = { "wangzhe_aozhan_discard", "wangzhe_aozhan_losehp" }
      local choice = room:askToChoice(player, { choices = choices, skill_name = rule.name, prompt = "#wangzhe_aozhan" })
      if choice == "wangzhe_aozhan_discard" then
        local ids = room:askToCards(player, { min_num = 2, max_num = 2, include_equip = true, skill_name = rule.name, pattern = ".", prompt = "#wangzhe_aozhan-discard" })
        if #ids == 2 then room:throwCard(ids, rule.name, player, player) else room:loseHp(player, 1, rule.name) end
      else
        room:loseHp(player, 1, rule.name)
      end
    else
      room:loseHp(player, 1, rule.name)
    end
    room:setPlayerMark(player, "@@wangzhe_aozhan_invalid", 0)
  end,
})

rule:addEffect(fk.TurnEnd, {
  priority = -20,
  can_trigger = function(self, event, target, player) return target == player and rebels_all_dead(player.room) end,
  on_use = function(self, event, target, player)
    for _, p in ipairs(player.room.players) do
      for _, m in ipairs({ "@wangzhe_suzaku", "@wangzhe_xuanwu", "@wangzhe_qinglong", "@wangzhe_baihu" }) do
        if p:getMark(m) > 0 then player.room:setPlayerMark(p, m, 0) end
      end
    end
  end,
})

rule:addEffect("invalidity", {
  invalidity_func = function(self, from, skill)
    return from:getMark("@@wangzhe_aozhan_invalid") > 0 and skill.name ~= rule.name
  end,
})

rule:addEffect("active", {
  prompt = "#wangzhe_suzaku",
  min_card_num = 1,
  max_card_num = 1,
  target_num = 1,
  can_use = function(self, player) return player.phase == Player.Play and player:getMark("@wangzhe_suzaku") > 0 end,
  card_filter = function(self, player, to_select) return Fk:getCardById(to_select).type ~= Card.TypeBasic and not player:prohibitDiscard(to_select) end,
  target_filter = function(self, player, to_select, selected) return #selected == 0 and to_select ~= player end,
  on_use = function(self, room, effect)
    local player, target = effect.from, effect.tos[1]
    room:setPlayerMark(player, "@wangzhe_suzaku", 0)
    room:throwCard(effect.cards, rule.name, player, player)
    if not target.dead then room:damage{ from = player, to = target, damage = 1, skillName = rule.name, extra_data = { skip_reward_punish = true } } end
  end,
})

rule:addEffect("viewas", {
  pattern = "peach,nullification,slash,jink",
  prompt = "#wangzhe_sixiang_viewas",
  card_filter = function(self, player, to_select, selected)
    local data = self.interaction and self.interaction.data
    local need = data == "nullification" and 2 or 1
    return #selected < need
  end,
  interaction = function(self, player)
    local choices = {}
    if player:getMark("@wangzhe_xuanwu") > 0 then table.insert(choices, "peach") end
    if player:getMark("@wangzhe_qinglong") > 0 then table.insert(choices, "nullification") end
    if player:getMark("@wangzhe_baihu") > 0 then table.insertTable(choices, { "slash", "jink" }) end
    if #choices == 0 then return end
    return UI.CardNameBox { choices = choices, all_choices = { "peach", "nullification", "slash", "jink" } }
  end,
  view_as = function(self, player, cards)
    local name = self.interaction and self.interaction.data
    if not name then return end
    if name == "nullification" and #cards ~= 2 then return end
    if name ~= "nullification" and #cards ~= 1 then return end
    local card = Fk:cloneCard(name)
    card.skillName = rule.name
    card:addSubcards(cards)
    return card
  end,
  before_use = function(self, player, use)
    local mark = ({ peach = "@wangzhe_xuanwu", nullification = "@wangzhe_qinglong", slash = "@wangzhe_baihu", jink = "@wangzhe_baihu" })[use.card.name]
    if mark then player.room:setPlayerMark(player, mark, 0) end
  end,
})

local mode = fk.CreateGameMode{
  name = "wangzhe_role_mode",
  minPlayer = 6,
  maxPlayer = 8,
  logic = wangzhe_getlogic,
  main_mode = "role_mode",
  rule = "#wangzhe_role_rule&",
  whitelist = function(self, pkg) return pkg.name == WZ_GENERALS_PACKAGE or pkg.name == "standard_cards" or pkg.name == "standard" end,
  feasible = function(self, settings) return settings.playerNum == 6 or settings.playerNum == 8 end,
  is_counted = function() return true end,
}

function mode:deathRewardAndPunish(victim, killer)
  if not killer or killer.dead then return end
  if victim.role == "rebel" or victim.role == "rebel_chief" then
    local current_event = victim.room.logic:getCurrentEvent()
    local death_event = current_event and current_event:findParent(GameEvent.Death, true)
    local damage = death_event and death_event.data and death_event.data.damage
    if damage and damage.skillName == rule.name then return end
    killer:drawCards(3, "kill")
  elseif victim.role == "loyalist" and killer.role == "lord" then
    killer:throwAllCards("he")
  end
end

return mode
