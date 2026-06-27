local kuizhuActive = fk.CreateSkill {
  name = "wzzz_v__kuizhu_active",
}

Fk:loadTranslationTable {
  ["wzzz_v__kuizhu_active"] = "溃诛",
  ["#kuizhu-invoke"] = "溃诛：选择一项并指定目标",
  ["wzzz_v__ol__kuizhu_draw"] = "令角色摸牌",
  ["wzzz_v__ol__kuizhu_damage"] = "造成伤害",
}

local function kuizhuNum(self)
  return (self.extra_data or {}).num or 0
end

local function selectedHp(selected)
  local n = 0
  for _, p in ipairs(selected) do
    n = n + p.hp
  end
  return n
end

kuizhuActive:addEffect("active", {
  anim_type = "control",
  card_num = 0,
  min_target_num = 1,
  max_target_num = function(self, player)
    if self.interaction.data == nil or self.interaction.data == "wzzz_v__ol__kuizhu_draw" then
      return math.min(kuizhuNum(self), #Fk:currentRoom().alive_players)
    end
    return #Fk:currentRoom().alive_players
  end,
  interaction = UI.ComboBox { choices = { "wzzz_v__ol__kuizhu_draw", "wzzz_v__ol__kuizhu_damage" } },
  card_filter = Util.FalseFunc,
  target_filter = function(self, player, to_select, selected, selected_cards)
    local n = kuizhuNum(self)
    if self.interaction.data == nil or self.interaction.data == "wzzz_v__ol__kuizhu_draw" then
      return #selected < n
    end
    return selectedHp(selected) + to_select.hp <= n
  end,
})

return kuizhuActive
