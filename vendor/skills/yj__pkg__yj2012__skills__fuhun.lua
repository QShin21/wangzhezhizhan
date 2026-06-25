
local fuhun = fk.CreateSkill {
  name = "wzzz_v__fuhun",
}

Fk:loadTranslationTable{
  ["wzzz_v__fuhun"] = "父魂",
  [":wzzz_v__fuhun"] = "你可以将两张手牌当【杀】使用或打出；当你于出牌阶段内以此法造成伤害后，本回合获得〖武圣〗和〖咆哮〗。",

  ["#wzzz_v__fuhun"] = "父魂：将两张手牌当【杀】使用或打出",

  ["$wzzz_v__fuhun1"] = "光复汉室，重任在肩！",
  ["$wzzz_v__fuhun2"] = "将门虎子，承我父志！",
}

fuhun:addEffect("viewas", {
  prompt = "#wzzz_v__fuhun",
  pattern = "slash",
  handly_pile = true,
  filter_pattern = {
    min_num = 2,
    max_num = 2,
    pattern = ".|.|.|^equip",
  },
  view_as = function(self, player, cards)
    if #cards ~= 2 then return end
    local c = Fk:cloneCard("slash")
    c.skillName = fuhun.name
    c:addSubcards(cards)
    return c
  end,
})

fuhun:addEffect(fk.Damage, {
  mute = true,
  is_delay_effect = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(fuhun.name) and
      data.card and table.contains(data.card.skillNames, fuhun.name) and
      player.phase == Player.Play
  end,
  on_trigger = function(self, event, target, player, data)
    local room = player.room
    local skills = {}
    for _, skill_name in ipairs({"wzzz_v__wusheng", "wzzz_v__gxzb__paoxiao"}) do
      if not player:hasSkill(skill_name, true) then
        table.insert(skills, skill_name)
      end
    end
    if #skills > 0 then
      room:handleAddLoseSkills(player, table.concat(skills, "|"))
      room.logic:getCurrentEvent():findParent(GameEvent.Turn):addCleaner(function()
        room:handleAddLoseSkills(player, "-"..table.concat(skills, "|-"))
      end)
    end
  end,
})

fuhun:addAI(nil, "vs_skill")

return fuhun
