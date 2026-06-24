local weidi = fk.CreateSkill {
  name = "wzzz_v__weidi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__weidi"] = "伪帝",
  [":wzzz_v__weidi"] = "锁定技，游戏开始时，你选择一项：1.获得主公的一个主公技并随机获得一张剩余四象标记；2.随机获得两张剩余四象标记。",
  ["wzzz_v__weidi_skill"] = "获得主公技并抽取一张四象",
  ["wzzz_v__weidi_sixiang"] = "抽取两张四象",
  ["#wzzz_v__weidi-skill"] = "伪帝：选择获得主公的一个主公技",
  ["#wzzz_v__weidi_log"] = "%from 因“伪帝”获得了 %arg",

  ["$wzzz_v__weidi1"] = "你们都得听我的号令！",
  ["$wzzz_v__weidi2"] = "我才是皇帝！",
}

local LEGACY_SIXIANG_SKILL = "wangzhe_sixiang_skill"

local SIXIANG_MARK_SKILL = {
  ["@wangzhe_suzaku"] = "wangzhe_suzaku_skill",
  ["@wangzhe_xuanwu"] = "wangzhe_xuanwu_skill",
  ["@wangzhe_qinglong"] = "wangzhe_qinglong_skill",
  ["@wangzhe_baihu"] = "wangzhe_baihu_skill",
}

local function sync_sixiang_skills(room, player)
  local changes = {}
  for mark, skill_name in pairs(SIXIANG_MARK_SKILL) do
    table.insert(changes, player:getMark(mark) > 0 and skill_name or "-" .. skill_name)
  end
  table.insert(changes, "-" .. LEGACY_SIXIANG_SKILL)
  room:handleAddLoseSkills(player, table.concat(changes, "|"), nil, false, true)
end

local function get_lord_skills(room, player)
  local skills = {}
  local lord = room:getLord()
  if not lord then return skills end
  for _, s in ipairs(lord:getSkillNameList()) do
    if Fk.skills[s] and Fk.skills[s]:hasTag(Skill.Lord) and not player:hasSkill(s, true) then
      table.insert(skills, s)
    end
  end
  return skills
end

local function take_sixiang_marks(room, player, n)
  local marks = room:getTag("wangzhe_sixiang_left")
  if type(marks) ~= "table" or #marks == 0 then return end

  local picked = room:tableRandomPick(marks, math.min(n, #marks))
  if type(picked) == "string" then picked = { picked } end
  for _, mark in ipairs(picked) do
    table.removeOne(marks, mark)
    room:addPlayerMark(player, mark, 1)
    room:sendLog{
      type = "#wzzz_v__weidi_log",
      from = player.id,
      arg = mark,
    }
  end
  room:setTag("wangzhe_sixiang_left", marks)
  sync_sixiang_skills(room, player)
end

local spec = {
  priority = 90,
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(weidi.name) and player.room:getSettings("gameMode") == "wangzhe_role_mode"
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local lord_skills = get_lord_skills(room, player)
    local mark_count = #(room:getTag("wangzhe_sixiang_left") or {})
    if #lord_skills == 0 and mark_count == 0 then return end

    local choices = {}
    if #lord_skills > 0 and mark_count > 0 then
      table.insert(choices, "wzzz_v__weidi_skill")
    end
    if mark_count > 0 then
      table.insert(choices, "wzzz_v__weidi_sixiang")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = weidi.name,
      all_choices = { "wzzz_v__weidi_skill", "wzzz_v__weidi_sixiang" },
    })

    if choice == "wzzz_v__weidi_skill" then
      local skill = room:askToChoice(player, {
        choices = lord_skills,
        skill_name = weidi.name,
        prompt = "#wzzz_v__weidi-skill",
      })
      if skill and skill ~= "" then
        room:handleAddLoseSkills(player, skill, nil, false, true)
      end
      take_sixiang_marks(room, player, 1)
    else
      take_sixiang_marks(room, player, 2)
    end
  end,
}

weidi:addEffect(fk.GameStart, spec)

return weidi
