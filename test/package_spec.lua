-- Package-level regression entry point.
-- Run from the FreeKill root with:
--   FreeKill.exe --testfile packages/wangzhezhizhan/test/package_spec.lua

local function keep_test_table(name)
  return name == "TestWangzhePackage" or name == "Test#wangzhe_role_rule&" or
    string.find(name, "^Testwzzz_") ~= nil or string.find(name, "^Testwangzhe_") ~= nil
end

for name in pairs(_G) do
  if type(name) == "string" and string.find(name, "^Test") and not keep_test_table(name) then
    _G[name] = nil
  end
end

local function read_json(path)
  local file, err = fk.io.open(path, "rb")
  if not file then error(err) end
  local content = file:read("*a")
  file:close()
  return json.decode(content)
end

local roster = read_json("packages/wangzhezhizhan/data/roster.json")

TestWangzhePackage = {}

function TestWangzhePackage:testPackageRegistration()
  local generals = Fk.packages["wzzz_generals"]
  local lords = Fk.packages["wzzz_lords"]
  local cards = Fk.packages["wzzz_cards"]

  lu.assertNotNil(generals)
  lu.assertNotNil(lords)
  lu.assertNotNil(cards)
  lu.assertEquals(generals.extensionName, "wangzhezhizhan")
  lu.assertEquals(lords.extensionName, "wangzhezhizhan")
  lu.assertEquals(#generals.generals, 168)
  lu.assertEquals(#lords.generals, 16)
  lu.assertEquals(#cards.card_specs, 108)
end

function TestWangzhePackage:testRosterAndSkillRegistration()
  lu.assertEquals(#roster, 184)

  local association_count = 0
  local unique_skills = {}
  for _, entry in ipairs(roster) do
    local general = Fk.generals[entry.code_name]
    lu.assertNotNil(general, "missing general: " .. entry.code_name)
    lu.assertEquals(general.package.name, entry.package)
    lu.assertNotEquals(Fk:translate(entry.code_name), entry.code_name,
      "missing general translation: " .. entry.code_name)

    local declared = {}
    for _, item in ipairs(general.all_skills) do
      declared[item[1]] = true
    end

    for _, skill in ipairs(entry.skills) do
      association_count = association_count + 1
      unique_skills[skill.id] = true
      lu.assertNotNil(Fk.skill_skels[skill.id], "missing skill: " .. skill.id)
      lu.assertTrue(declared[skill.id] == true,
        string.format("%s does not declare %s", entry.code_name, skill.id))
      lu.assertNotEquals(Fk:translate(skill.id), skill.id,
        "missing skill name translation: " .. skill.id)
      local description_key = ":" .. skill.id
      lu.assertNotEquals(Fk:translate(description_key), description_key,
        "missing skill description translation: " .. skill.id)
    end
  end

  lu.assertEquals(association_count, 443)
  local unique_count = 0
  for _ in pairs(unique_skills) do unique_count = unique_count + 1 end
  lu.assertEquals(unique_count, 406)
end

function TestWangzhePackage:testSkillMetadataContracts()
  local checked = {}
  for _, entry in ipairs(roster) do
    for _, item in ipairs(entry.skills) do
      if not checked[item.id] then
        checked[item.id] = true
        local skill = Fk.skills[item.id]
        local skeleton = Fk.skill_skels[item.id]
        lu.assertNotNil(skill, "missing runtime skill: " .. item.id)
        lu.assertNotNil(skeleton, "missing runtime skeleton: " .. item.id)
        lu.assertTrue(#skeleton.effect_names > 0, "skill has no effects: " .. item.id)

        local description = item.description
        if string.find(description, "^锁定技") or string.find(description, "^主公技，锁定技") then
          lu.assertTrue(skill:hasTag(Skill.Compulsory), "missing compulsory tag: " .. item.id)
        end
        if string.find(description, "^限定技") or string.find(description, "^主公技，限定技") then
          lu.assertTrue(skill:hasTag(Skill.Limited), "missing limited tag: " .. item.id)
        end
        if string.find(description, "^觉醒技") or string.find(description, "^主公技，觉醒技") then
          lu.assertTrue(skill:hasTag(Skill.Wake), "missing wake tag: " .. item.id)
        end
        if string.find(description, "^主公技") then
          lu.assertTrue(skill:hasTag(Skill.Lord), "missing lord tag: " .. item.id)
        end

        for _, related in ipairs(skeleton.related_skills) do
          lu.assertNotNil(Fk.skills[related],
            string.format("%s has missing related skill %s", item.id, related))
        end
        if skeleton.attached_skill_name then
          lu.assertNotNil(Fk.skills[skeleton.attached_skill_name],
            string.format("%s has missing attached skill %s", item.id, skeleton.attached_skill_name))
        end
        for _, added in ipairs(skeleton.add_skills) do
          lu.assertNotNil(Fk.skills[added],
            string.format("%s has missing add-skill dependency %s", item.id, added))
        end
      end
    end
  end
end

function TestWangzhePackage:testCardAndModeRegistration()
  local cards = Fk.packages["wzzz_cards"]
  local distribution = {}
  for _, spec in ipairs(cards.card_specs) do
    distribution[spec[1]] = (distribution[spec[1]] or 0) + 1
    lu.assertNotNil(Fk.all_card_types[spec[1]], "missing card type: " .. spec[1])
  end
  lu.assertEquals(distribution.slash, 20)
  lu.assertEquals(distribution.thunder__slash, 7)
  lu.assertEquals(distribution.fire__slash, 4)
  lu.assertEquals(distribution.jink, 15)
  lu.assertEquals(distribution.peach, 8)
  lu.assertEquals(distribution.analeptic, 3)

  local mode = Fk.game_modes["wangzhe_role_mode"]
  lu.assertNotNil(mode)
  lu.assertEquals(mode.minPlayer, 6)
  lu.assertEquals(mode.maxPlayer, 8)
  lu.assertTrue(mode:feasible { playerNum = 6 })
  lu.assertTrue(mode:feasible { playerNum = 8 })
  lu.assertFalse(mode:feasible { playerNum = 7 })
  lu.assertEquals(mode.rule, "#wangzhe_role_rule&")
end

function TestWangzhePackage:testSummaryTranslationIsolation()
  local previous_client = ClientInstance
  local ok, err = pcall(function()
    local summary = {
      { wangzhe_score = 54, wangzhe_overview = "王者摘要" },
    }
    ClientInstance = {
      getBanner = function(self, name)
        return name == "GameSummary" and summary or nil
      end,
    }
    lu.assertEquals(Fk:translate("Turn"), "积分")
    lu.assertEquals(Fk:translate("Recover"), "死亡来源")
    lu.assertEquals(Fk:translate("Damage"), "击杀对象")
    lu.assertEquals(Fk:translate("Game Win"), "王者摘要")

    ClientInstance = {
      getBanner = function() return nil end,
    }
    lu.assertNotEquals(Fk:translate("Turn"), "积分")
    lu.assertNotEquals(Fk:translate("Game Win"), "王者摘要")
  end)
  ClientInstance = previous_client
  if not ok then error(err) end
end
