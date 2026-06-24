local WZ_GENERALS_PACKAGES = {
  wangzhezhizhan = true,
  wzzz_lords = true,
  wzzz_generals = true,
}
local CHOOSE_TIMEOUT = 60
local LORD_CANDIDATE_COUNT = 4
local NON_LORD_CANDIDATE_COUNT = 6
local LORD_EXTRA_COUNT = 3

local RULE_SKILL = "#wangzhe_role_rule&"
local SUZAKU_SKILL = "wangzhe_suzaku_skill"
local XUANWU_SKILL = "wangzhe_xuanwu_skill"
local QINGLONG_SKILL = "wangzhe_qinglong_skill"
local BAIHU_SKILL = "wangzhe_baihu_skill"
local LEGACY_SIXIANG_SKILL = "wangzhe_sixiang_skill"
local AOZHAN_INVALID_MARK = "@@wangzhe_aozhan_invalid"

local SIXIANG_MARKS = {
  "@wangzhe_suzaku",
  "@wangzhe_xuanwu",
  "@wangzhe_qinglong",
  "@wangzhe_baihu",
}

local SIXIANG_CARD_MARK = {
  peach = "@wangzhe_xuanwu",
  nullification = "@wangzhe_qinglong",
  slash = "@wangzhe_baihu",
  jink = "@wangzhe_baihu",
}

local SIXIANG_MARK_SKILL = {
  ["@wangzhe_suzaku"] = SUZAKU_SKILL,
  ["@wangzhe_xuanwu"] = XUANWU_SKILL,
  ["@wangzhe_qinglong"] = QINGLONG_SKILL,
  ["@wangzhe_baihu"] = BAIHU_SKILL,
}

local function same_title_general(a, b)
  if not a or not b then return false end
  local ga, gb = Fk.generals[a], Fk.generals[b]
  if not ga or not gb then return a == b end
  return (ga.trueName or ga.name) == (gb.trueName or gb.name) and (ga.title or "") == (gb.title or "")
end

local function contains_same_general(list, name)
  if not name then return false end
  return table.find(list or {}, function(g) return same_title_general(g, name) end) ~= nil
end

local function get_skill_name(skill)
  if type(skill) == "string" then return skill end
  if not skill then return nil end
  local skel = skill.getSkeleton and skill:getSkeleton()
  return skel and skel.name or skill.name
end

local function is_player_owned_skill(player, skill)
  local name = get_skill_name(skill)
  if not name then return false end
  return player:hasSkill(name, true, true)
end

local function is_wangzhe_general(name)
  local g = Fk.generals[name]
  if not g then return false end
  local pkg = g.package or g.packageName
  if type(pkg) == "table" then pkg = pkg.name end
  return WZ_GENERALS_PACKAGES[pkg] == true or
    string.find(name, "^wzzz__") ~= nil or
    string.find(name, "^wzzz_lord__") ~= nil or
    string.find(name, "^wz__") ~= nil or
    string.find(name, "^wangzhe__") ~= nil
end

local function is_lord_general(name)
  local g = Fk.generals[name]
  if not g then return false end
  local pkg = g.package or g.packageName
  if type(pkg) == "table" then pkg = pkg.name end
  return pkg == "wzzz_lords" or string.find(name, "^wzzz_lord__") ~= nil
end

local function pick_unique(room, source, n, excludes)
  local picked, pool = {}, table.simpleClone(source or {})
  room:shuffleTable(pool)
  for _, name in ipairs(pool) do
    if #picked >= n then break end
    if not contains_same_general(picked, name) and not contains_same_general(excludes, name) then
      table.insert(picked, name)
    end
  end
  return picked
end

local function normalize_choice(choice)
  if type(choice) == "table" then return choice end
  if choice then return { choice } end
  return {}
end

local function choose_legal_generals(room, raw_choice, candidates, n, used)
  local chosen = {}
  for _, name in ipairs(normalize_choice(raw_choice)) do
    if Fk.generals[name] and table.contains(candidates, name) and
      not contains_same_general(used, name) and not contains_same_general(chosen, name) then
      table.insert(chosen, name)
      if #chosen >= n then break end
    end
  end

  if #chosen < n then
    local fallback = pick_unique(room, candidates, n - #chosen, table.connect(used or {}, chosen))
    table.insertTable(chosen, fallback)
  end

  return chosen[1], chosen[2], chosen
end

local function send_no_enough_general_log(room, required, actual)
  room:sendLog{
    type = "#NoEnoughGeneralDraw",
    arg = actual,
    arg2 = required,
    toast = true,
  }
  room:gameOver("")
end

local function sync_sixiang_skills(room, player)
  local changes = {}
  for mark, skill_name in pairs(SIXIANG_MARK_SKILL) do
    table.insert(changes, player:getMark(mark) > 0 and skill_name or "-" .. skill_name)
  end
  table.insert(changes, "-" .. LEGACY_SIXIANG_SKILL)
  room:handleAddLoseSkills(player, table.concat(changes, "|"), nil, false, true)
end

local function clear_sixiang_marks(room, player)
  for _, mark in ipairs(SIXIANG_MARKS) do
    if player:getMark(mark) > 0 then room:setPlayerMark(player, mark, 0) end
  end
  sync_sixiang_skills(room, player)
end

local function normalize_random_pick(picked)
  if picked == nil then return {} end
  if type(picked) == "table" then return picked end
  return { picked }
end

local function draw_sixiang_marks(room, source, n)
  local pool = table.simpleClone(source or {})
  if #pool == 0 or n <= 0 then return {} end
  return normalize_random_pick(room:tableRandomPick(pool, math.min(n, #pool)))
end

local function grant_sixiang_mark(room, player, mark, log_type)
  if not mark or mark == "" then return end
  room:addPlayerMark(player, mark, 1)
  room:sendLog{
    type = log_type or "#wangzhe_sixiang_log",
    from = player.id,
    arg = mark,
  }
  sync_sixiang_skills(room, player)
end

local function remove_sixiang_mark_for_card(room, player, card)
  if not card then return end
  local mark = SIXIANG_CARD_MARK[card.trueName] or SIXIANG_CARD_MARK[card.name]
  if mark and player:getMark(mark) > 0 then
    room:setPlayerMark(player, mark, 0)
    sync_sixiang_skills(room, player)
  end
end

local function available_sixiang_card_names(player, skill_name, names)
  if type(player.getViewAsCardNames) == "function" then
    return player:getViewAsCardNames(skill_name, names)
  end
  return names
end

local function translate_general_key(key)
  if not key or key == "" then return Fk:translate("wangzhe_none") end
  local names = key:split("/")
  return table.concat(table.map(names, function(name)
    return Fk:translate(name)
  end), "/")
end

local function translate_general_list(list)
  if type(list) ~= "table" or #list == 0 then return Fk:translate("wangzhe_none") end
  return table.concat(table.map(list, translate_general_key), "、")
end

local function is_lord_side(role)
  return role == "lord" or role == "loyalist"
end

local function is_rebel_side(role)
  return role == "rebel" or role == "rebel_chief"
end

local function winner_side(winner)
  if not winner or winner == "" then return "draw" end
  local roles = winner:split("+")
  if table.contains(roles, "renegade") then return "renegade" end
  if table.contains(roles, "rebel") or table.contains(roles, "rebel_chief") then return "rebel" end
  if table.contains(roles, "lord") or table.contains(roles, "loyalist") then return "lord" end
  return "draw"
end

local function count_players(room, pred)
  local n = 0
  for _, p in ipairs(room.players) do
    if pred(p) then n = n + 1 end
  end
  return n
end

local function general_text_key(player)
  if not player then return "" end
  local ret = player.general or ""
  if player.deputyGeneral and player.deputyGeneral ~= "" then
    ret = ret .. "/" .. player.deputyGeneral
  end
  return ret
end

local function update_renegade_bonus_state(room)
  local alive = room:getAlivePlayers()
  local lord, renegade, rebel = 0, 0, 0
  for _, p in ipairs(alive) do
    if p.role == "lord" then
      lord = lord + 1
    elseif p.role == "renegade" then
      renegade = renegade + 1
    elseif is_rebel_side(p.role) then
      rebel = rebel + 1
    end
  end

  if #alive == 2 and lord == 1 and renegade == 1 then
    room:setTag("wangzhe_entered_duel", true)
  elseif #alive == 3 and lord == 1 and renegade == 1 and rebel == 1 then
    room:setTag("wangzhe_entered_lord_renegade_rebel", true)
  end
end

local function collect_death_info(room)
  local death_source, kill_targets = {}, {}
  local renegade_rebel_kills = 0

  room.logic:getEventsOfScope(GameEvent.Death, 999, function(e)
    local death = e.data
    local victim, killer = death.who, death.killer
    if victim and victim.seat then
      death_source[victim.seat] = general_text_key(killer)
    end
    if killer and killer.seat and victim then
      kill_targets[killer.seat] = kill_targets[killer.seat] or {}
      table.insert(kill_targets[killer.seat], general_text_key(victim))
      if killer.role == "renegade" and is_rebel_side(victim.role) then
        renegade_rebel_kills = renegade_rebel_kills + 1
      end
    end
    return false
  end, Player.HistoryGame)

  return death_source, kill_targets, renegade_rebel_kills
end

local function calculate_wangzhe_score(room, player, winner, renegade_rebel_kills)
  local n = #room.players
  local side = winner_side(winner)
  local loyalist_dead = count_players(room, function(p) return p.role == "loyalist" and p.dead end)
  local rebel_dead = count_players(room, function(p) return is_rebel_side(p.role) and p.dead end)
  local lord_side_alive = count_players(room, function(p) return is_lord_side(p.role) and not p.dead end)
  local rebel_alive = count_players(room, function(p) return is_rebel_side(p.role) and not p.dead end)

  if is_lord_side(player.role) then
    if side == "lord" then
      if n == 6 then
        return lord_side_alive >= 2 and 54 or 48
      end
      if lord_side_alive >= 3 then return 57 end
      if lord_side_alive == 2 then return 53 end
      return 49
    elseif side == "rebel" then
      return rebel_dead * (n == 6 and 5 or 4)
    elseif side == "renegade" then
      return n == 6 and 18 or 20
    end
  elseif is_rebel_side(player.role) then
    if side == "rebel" then
      if n == 6 then
        if rebel_alive >= 3 then return 49 end
        if rebel_alive == 2 then return 45 end
        return 41
      end
      if rebel_alive >= 4 then return 51 end
      if rebel_alive == 3 then return 48 end
      if rebel_alive == 2 then return 45 end
      return 43
    elseif side == "lord" or side == "renegade" then
      if n == 6 then
        return loyalist_dead > 0 and 9 or 0
      end
      return loyalist_dead * 5
    end
  elseif player.role == "renegade" then
    if side == "renegade" then
      return n == 6 and 85 or 95
    elseif side == "lord" then
      local score = n == 6 and 8 or 9
      local loyalist_dead_when_renegade_died =
        room:getTag("wangzhe_renegade_death_loyalist_dead") or loyalist_dead
      if n == 6 then
        if loyalist_dead_when_renegade_died > 0 then score = score + 4 end
        if room:getTag("wangzhe_entered_duel") then score = score + 14 end
      else
        score = score + loyalist_dead_when_renegade_died * 5
        if room:getTag("wangzhe_entered_duel") then score = score + 15 end
      end
      return score
    elseif side == "rebel" then
      local score = n == 6 and 8 or 9
      score = score + renegade_rebel_kills * 5
      if room:getTag("wangzhe_entered_lord_renegade_rebel") then
        score = score + 15
      end
      return score
    end
  end

  return 0
end

local function wangzhe_result_overview(room, winner)
  local side = winner_side(winner)
  local loyalist_dead = count_players(room, function(p) return p.role == "loyalist" and p.dead end)
  local rebel_dead = count_players(room, function(p) return is_rebel_side(p.role) and p.dead end)
  local winner_text = side == "lord" and "主忠" or side == "rebel" and "反贼" or
    side == "renegade" and "内奸" or "平局"
  return string.format("%d忠臣阵亡，%d反贼阵亡，%s获胜", loyalist_dead, rebel_dead, winner_text)
end

local function apply_wangzhe_score_summary(room, winner, summary)
  if room:getTag("wangzhe_score_finalized") then return end
  room:setTag("wangzhe_score_finalized", true)

  local has_summary = type(summary) == "table"
  local death_source, kill_targets, renegade_rebel_kills = collect_death_info(room)
  local overview = wangzhe_result_overview(room, winner)

  for _, p in ipairs(room.players) do
    local score = calculate_wangzhe_score(room, p, winner, renegade_rebel_kills)
    if has_summary then
      local row = summary[p.seat]
      if row then
        row.wangzhe_score = score
        row.wangzhe_kill_targets = kill_targets[p.seat] or {}
        row.wangzhe_death_source = death_source[p.seat] or ""
        if p.seat == 1 then row.wangzhe_overview = overview end
      end
    end

    room:sendLog{
      type = "#wangzhe_score_detail",
      from = p.id,
      arg = tostring(score),
      arg2 = Fk:translate("wangzhe_kill_targets") .. "：" .. translate_general_list(kill_targets[p.seat]) ..
        "；" .. Fk:translate("wangzhe_death_source") .. "：" .. translate_general_key(death_source[p.seat]),
    }
  end

  room:sendLog{
    type = "#wangzhe_score_overview",
    arg = overview,
    toast = true,
  }
end

local function install_wangzhe_summary_hooks(room)
  if room.__wangzhe_summary_hooks_installed then return end
  room.__wangzhe_summary_hooks_installed = true

  if type(room.gameOver) == "function" then
    local old_game_over = room.gameOver
    room.gameOver = function(self, winner, ...)
      self:setTag("wangzhe_pending_winner", winner or "")
      local ret = old_game_over(self, winner, ...)
      self:setTag("wangzhe_pending_winner", nil)
      return ret
    end
  end

  if type(room.getGameSummary) == "function" then
    local old_get_game_summary = room.getGameSummary
    room.getGameSummary = function(self, ...)
      local summary = old_get_game_summary(self, ...)
      if self:getSettings("gameMode") == "wangzhe_role_mode" then
        local winner = self:getTag("wangzhe_pending_winner")
        if winner ~= nil then
          apply_wangzhe_score_summary(self, winner, summary)
        end
      end
      return summary
    end
  end
end

local function wangzhe_getlogic()
  local logic = GameLogic:subclass("wangzhe_role_logic")

  function logic:initialize(room)
    GameLogic.initialize(self, room)
    install_wangzhe_summary_hooks(room)
    self.role_table[6] = { "lord", "loyalist", "rebel", "rebel", "rebel", "renegade" }
    self.role_table[8] = { "lord", "loyalist", "loyalist", "rebel", "rebel", "rebel", "rebel", "renegade" }
  end

  function logic:chooseGenerals()
    local room = self.room
    local n = room:getSettings("enableDeputy") and 2 or 1
    local lord = room:getLord()
    local old_timeout = room:getSettings("generalTimeout")

    room.settings.generalTimeout = CHOOSE_TIMEOUT

    local all = room:findGenerals(function(name) return is_wangzhe_general(name) end, 9999)
    local lord_pool = table.filter(all, is_lord_general)
    local non_lord_pool = table.filter(all, function(name) return not is_lord_general(name) end)
    local used_generals = {}

    if #lord_pool < LORD_CANDIDATE_COUNT or #non_lord_pool == 0 or #all < #room.players * n then
      send_no_enough_general_log(room, #room.players * n, #all)
      room.settings.generalTimeout = old_timeout
      room:returnToGeneralPile(all)
      return
    end

    if lord then
      room:setCurrent(lord)
      local lord_candidates = pick_unique(room, lord_pool, LORD_CANDIDATE_COUNT, {})
      local extra_candidates = pick_unique(room, non_lord_pool, LORD_EXTRA_COUNT, lord_candidates)
      local generals = table.connect(lord_candidates, extra_candidates)
      if #lord_candidates < LORD_CANDIDATE_COUNT or #extra_candidates < LORD_EXTRA_COUNT or #generals < n then
        send_no_enough_general_log(room, LORD_CANDIDATE_COUNT + LORD_EXTRA_COUNT, #generals)
        room.settings.generalTimeout = old_timeout
        room:returnToGeneralPile(all)
        return
      end

      local chosen = room:askToChooseGeneral(lord, {
        generals = generals,
        n = n,
        no_convert = true,
        prompt = "#wangzhe_choose_lord",
        extra_data = {
          lord_count = #lord_candidates,
          upper = lord_candidates,
          lower = extra_candidates,
        },
      })
      local lord_general, deputy, selected = choose_legal_generals(room, chosen, generals, n, used_generals)
      if not lord_general then
        send_no_enough_general_log(room, n, #generals)
        room.settings.generalTimeout = old_timeout
        room:returnToGeneralPile(all)
        return
      end

      table.insertTable(used_generals, selected)
      room:prepareGeneral(lord, lord_general, deputy, true)
      room:askToChooseKingdom({ lord })
      room:broadcastProperty(lord, "kingdom")
    end

    local nonlord = room:getOtherPlayers(lord, true)
    local candidate_map = {}
    local dealt = table.simpleClone(used_generals)
    local req = Request:new(nonlord, "AskForGeneral")
    req.timeout = CHOOSE_TIMEOUT

    for _, p in ipairs(nonlord) do
      local excludes = table.connect(used_generals, dealt)
      local generals = pick_unique(room, non_lord_pool, NON_LORD_CANDIDATE_COUNT, excludes)
      if #generals < math.min(NON_LORD_CANDIDATE_COUNT, n) then
        generals = pick_unique(room, non_lord_pool, NON_LORD_CANDIDATE_COUNT, used_generals)
      end
      if #generals < n then
        send_no_enough_general_log(room, n, #generals)
        room.settings.generalTimeout = old_timeout
        room:returnToGeneralPile(all)
        return
      end

      candidate_map[p] = generals
      table.insertTable(dealt, generals)
      req:setData(p, { generals, n, true, false, "askForGeneralsChosen", "#wangzhe_choose_nonlord", { n = n } })
      req:setDefaultReply(p, room:tableRandomPick(generals, n))
    end

    for _, p in ipairs(nonlord) do
      local general, deputy, selected = choose_legal_generals(room, req:getResult(p), candidate_map[p], n, used_generals)
      if not general then
        send_no_enough_general_log(room, n, #(candidate_map[p] or {}))
        room.settings.generalTimeout = old_timeout
        room:returnToGeneralPile(all)
        return
      end
      table.insertTable(used_generals, selected)
      room:prepareGeneral(p, general, deputy)
    end

    room:askToChooseKingdom(nonlord)

    local unused = table.filter(all, function(name) return not contains_same_general(used_generals, name) end)
    room:returnToGeneralPile(unused)
    room.settings.generalTimeout = old_timeout
  end

  return logic
end

local rule = fk.CreateSkill { name = RULE_SKILL, mode_skill = true }

local function rebels_all_dead(room)
  return not table.find(room.players, function(p)
    return not p.dead and (p.role == "rebel" or p.role == "rebel_chief")
  end)
end

local function throw_aozhan_cards(room, player, n, allow_less)
  local cards = player:getCardIds("he")
  if #cards == 0 then return false end

  local discard
  if allow_less and #cards <= n then
    discard = cards
  else
    discard = room:askToCards(player, {
      min_num = n,
      max_num = n,
      include_equip = true,
      cancelable = false,
      skill_name = rule.name,
      pattern = ".",
      prompt = "#wangzhe_aozhan-discard",
    })
  end

  if #discard > 0 then
    room:throwCard(discard, rule.name, player, player)
    return true
  end
  return false
end

rule:addEffect(fk.GameStart, {
  priority = 100,
  can_refresh = function(self, event, target, player)
    return player.role == "lord"
  end,
  on_refresh = function(self, event, target, player)
    local room = player.room
    room:setTag("wangzhe_entered_duel", false)
    room:setTag("wangzhe_entered_lord_renegade_rebel", false)
    room:setTag("wangzhe_renegade_death_loyalist_dead", nil)
    room:setTag("wangzhe_aozhan_started", false)
    room:setTag("wangzhe_score_finalized", false)
    room:setTag("wangzhe_pending_winner", nil)
    room:setBanner("@[:]wangzhe_stage", "wangzhe_stage_normal")

    for _, p in ipairs(room.players) do
      clear_sixiang_marks(room, p)
    end

    local choice = draw_sixiang_marks(room, SIXIANG_MARKS, 1)[1]
    grant_sixiang_mark(room, player, choice)
    room:setTag("wangzhe_sixiang", choice)
    room:setTag("wangzhe_sixiang_left", table.filter(SIXIANG_MARKS, function(mark) return mark ~= choice end))
  end,
})

rule:addEffect(fk.RoundStart, {
  can_refresh = function(self, event, target, player)
    local room = player.room
    local round = room:getBanner("RoundCount") or 0
    local threshold = #room.players == 6 and 5 or 4
    return player.seat == 1 and not room:getTag("wangzhe_aozhan_started") and round >= threshold
  end,
  on_refresh = function(self, event, target, player)
    local room = player.room
    room:setTag("wangzhe_aozhan_started", true)
    room:setBanner("@[:]wangzhe_stage", "wangzhe_stage_aozhan")
    room:sendLog{ type = "#wangzhe_aozhan_start", toast = true }
  end,
})

rule:addEffect(fk.TurnEnd, {
  priority = -1000,
  can_trigger = function(self, event, target, player)
    if target ~= player or player.dead then return false end
    local room = player.room
    return room:getTag("wangzhe_aozhan_started") == true
  end,
  on_use = function(self, event, target, player)
    local room = player.room
    room:setPlayerMark(player, AOZHAN_INVALID_MARK, 1)

    local cards = player:getCardIds("he")
    if player:hasSkill("wzzz_v__os__zhuiting", true) then
      throw_aozhan_cards(room, player, 2, true)
    elseif player:hasSkill("wzzz_v__weizhong", true) or player:hasSkill("wzzz_v__ty_ex__weizhong", true) then
      room:loseHp(player, 1, rule.name)
    elseif #cards >= 2 then
      local choice = room:askToChoice(player, {
        choices = { "wangzhe_aozhan_discard", "wangzhe_aozhan_losehp" },
        skill_name = rule.name,
        prompt = "#wangzhe_aozhan",
        cancelable = false,
      })
      if choice == "wangzhe_aozhan_discard" then
        if not throw_aozhan_cards(room, player, 2, false) then
          room:loseHp(player, 1, rule.name)
        end
      else
        room:loseHp(player, 1, rule.name)
      end
    else
      room:loseHp(player, 1, rule.name)
    end

    room:setPlayerMark(player, AOZHAN_INVALID_MARK, 0)
  end,
})

rule:addEffect(fk.EnterDying, {
  priority = 20,
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark(AOZHAN_INVALID_MARK) > 0
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:setPlayerMark(player, AOZHAN_INVALID_MARK, 0)
  end,
})

rule:addEffect(fk.BeforeGameOverJudge, {
  can_refresh = function(self, event, target, player, data)
    return target == player
  end,
  on_refresh = function(self, event, target, player, data)
    local room = player.room
    if player.role == "renegade" and not room:getTag("wangzhe_renegade_death_loyalist_dead") then
      room:setTag("wangzhe_renegade_death_loyalist_dead",
        count_players(room, function(p) return p.role == "loyalist" and p.dead end))
    end
    update_renegade_bonus_state(room)
  end,
})

rule:addEffect(fk.TurnEnd, {
  priority = -1100,
  can_trigger = function(self, event, target, player)
    return target == player and rebels_all_dead(player.room)
  end,
  on_use = function(self, event, target, player)
    for _, p in ipairs(player.room.players) do
      clear_sixiang_marks(player.room, p)
    end
  end,
})

rule:addEffect("invalidity", {
  invalidity_func = function(self, from, skill)
    return from and from:getMark(AOZHAN_INVALID_MARK) > 0 and is_player_owned_skill(from, skill)
  end,
})

local suzaku = fk.CreateSkill { name = SUZAKU_SKILL }

suzaku:addEffect("active", {
  prompt = "#wangzhe_suzaku",
  min_card_num = 1,
  max_card_num = 1,
  target_num = 1,
  include_equip = true,
  can_use = function(self, player)
    return player.phase == Player.Play and player:getMark("@wangzhe_suzaku") > 0
  end,
  card_filter = function(self, player, to_select, selected)
    local card = Fk:getCardById(to_select)
    return #selected == 0 and card.type ~= Card.TypeBasic and not player:prohibitDiscard(to_select)
  end,
  target_filter = function(self, player, to_select, selected)
    return #selected == 0
  end,
  on_use = function(self, room, effect)
    local player, target = effect.from, effect.tos[1]
    room:setPlayerMark(player, "@wangzhe_suzaku", 0)
    sync_sixiang_skills(room, player)
    room:throwCard(effect.cards, suzaku.name, player, player)
    if target and not target.dead then
      room:damage{
        from = player,
        to = target,
        damage = 1,
        skillName = suzaku.name,
        extra_data = { skip_reward_punish = true },
      }
    end
  end,
})

local function create_sixiang_viewas_skill(skill_name, mark, card_names, card_num, prompt)
  local skill = fk.CreateSkill { name = skill_name }

  skill:addEffect("viewas", {
    pattern = table.concat(card_names, ","),
    prompt = prompt,
    include_equip = true,
    interaction = function(self, player)
      if #card_names == 1 then return end
      local choices = available_sixiang_card_names(player, skill_name, card_names)
      if #choices == 0 then return end
      return UI.CardNameBox {
        choices = choices,
        all_choices = card_names,
      }
    end,
    filter_pattern = {
      min_num = card_num,
      max_num = card_num,
      pattern = ".",
    },
    view_as = function(self, player, cards)
      local name = #card_names == 1 and card_names[1] or (self.interaction and self.interaction.data)
      if not name or not table.contains(card_names, name) or #cards ~= card_num then return end
      if player:getMark(mark) <= 0 then return end

      local card = Fk:cloneCard(name)
      card.skillName = skill.name
      card:addSubcards(cards)
      return card
    end,
    before_use = function(self, player, use)
      remove_sixiang_mark_for_card(player.room, player, use.card)
    end,
    enabled_at_play = function(self, player)
      return player:getMark(mark) > 0 and #player:getCardIds("he") >= card_num and
        #available_sixiang_card_names(player, skill_name, card_names) > 0
    end,
    enabled_at_response = function(self, player)
      return player:getMark(mark) > 0 and #player:getCardIds("he") >= card_num and
        #available_sixiang_card_names(player, skill_name, card_names) > 0
    end,
    enabled_at_nullification = function(self, player)
      return skill_name == QINGLONG_SKILL and player:getMark(mark) > 0 and #player:getCardIds("he") >= card_num
    end,
  })

  skill:addEffect(fk.CardResponding, {
    can_refresh = function(self, event, target, player, data)
      return target == player and data.card and
        (data.card.skillName == skill.name or table.contains(data.card.skillNames or {}, skill.name))
    end,
    on_refresh = function(self, event, target, player, data)
      remove_sixiang_mark_for_card(player.room, player, data.card)
    end,
  })

  return skill
end

local xuanwu = create_sixiang_viewas_skill(
  XUANWU_SKILL, "@wangzhe_xuanwu", { "peach" }, 1, "#wangzhe_xuanwu_viewas"
)
local qinglong = create_sixiang_viewas_skill(
  QINGLONG_SKILL, "@wangzhe_qinglong", { "nullification" }, 2, "#wangzhe_qinglong_viewas"
)
local baihu = create_sixiang_viewas_skill(
  BAIHU_SKILL, "@wangzhe_baihu", { "slash", "jink" }, 1, "#wangzhe_baihu_viewas"
)

local mode = fk.CreateGameMode{
  name = "wangzhe_role_mode",
  minPlayer = 6,
  maxPlayer = 8,
  logic = wangzhe_getlogic,
  main_mode = "role_mode",
  rule = RULE_SKILL,
  whitelist = function(self, pkg)
    return WZ_GENERALS_PACKAGES[pkg.name] == true or
      pkg.name == "standard_cards" or pkg.name == "standard" or pkg.name == "maneuvering"
  end,
  feasible = function(self, settings)
    return settings.playerNum == 6 or settings.playerNum == 8
  end,
  is_counted = function(self, room) return true end,
  reward_punish = function(self, victim, killer)
    if not killer or killer.dead then return end
    if victim.role == "rebel" or victim.role == "rebel_chief" then
      local current_event = victim.room.logic:getCurrentEvent()
      local death_event = current_event and current_event:findParent(GameEvent.Death, true)
      local damage = death_event and death_event.data and death_event.data.damage
      if damage and (damage.skillName == SUZAKU_SKILL or
        (damage.extra_data and damage.extra_data.skip_reward_punish)) then
        return
      end
      killer:drawCards(3, "kill")
    elseif victim.role == "loyalist" and killer.role == "lord" then
      killer:throwAllCards("he")
    end
  end,
}

return {
  mode = mode,
  skills = { rule, suzaku, xuanwu, qinglong, baihu },
}
