local chongjian = fk.CreateSkill {
  name = "wzzz_v__ofl__chongjian",
  tags = { Skill.Limited },
}

Fk:loadTranslationTable{
  ["wzzz_v__ofl__chongjian"] = "冲坚",
  [":wzzz_v__ofl__chongjian"] = "限定技，出牌阶段，你可以减1点体力上限，将一张装备牌当【酒】或无视防具的任意一种【杀】使用。",

  ["#wzzz_v__ofl__chongjian"] = "冲坚：减1点体力上限，将装备牌当【酒】或无视防具的【杀】使用",
}

chongjian:addEffect("viewas", {
  anim_type = "offensive",
  pattern = "slash,analeptic",
  prompt = "#wzzz_v__ofl__chongjian",
  interaction = function (self, player)
    local all_names = {"slash", "analeptic"}
    local names = player:getViewAsCardNames(chongjian.name, all_names)
    if #names == 0 then return end
    return UI.CardNameBox { choices = names, all_choices = all_names }
  end,
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).type == Card.TypeEquip
  end,
  view_as = function(self, player, cards)
    if #cards ~= 1 or not self.interaction.data then return end
    local card = Fk:cloneCard(self.interaction.data)
    card:addSubcard(cards[1])
    card.skillName = chongjian.name
    return card
  end,
  before_use = function(self, player, use)
    local room = player.room
    room:changeMaxHp(player, -1)
    if use.card and use.card.trueName == "slash" then
      for _, to in ipairs(use.tos or {}) do
        room:addTableMark(player, MarkEnum.MarkArmorInvalidTo .. "-turn", to.id)
      end
    end
  end,
  enabled_at_play = function(self, player)
    return player:usedSkillTimes(chongjian.name, Player.HistoryGame) == 0
  end,
  enabled_at_response = function(self, player, response)
    return false
  end,
})

chongjian:addAI(nil, "vs_skill")

return chongjian
