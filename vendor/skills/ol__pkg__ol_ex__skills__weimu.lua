local weimu = fk.CreateSkill {
  name = "wzzz_v__ol_ex__weimu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__weimu"] = "帷幕",
  [":wzzz_v__ol_ex__weimu"] = "锁定技，你不是黑色锦囊牌的合法目标。当你于回合内受到伤害时，你防止此伤害，摸2X张牌（X为伤害值）。",

  ["$wzzz_v__ol_ex__weimu1"] = "此伤与我无关。",
  ["$wzzz_v__ol_ex__weimu2"] = "还是另寻他法吧。",
}

weimu:addEffect(fk.DetermineDamageInflicted, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(weimu.name) and player.room.current == player
  end,
  on_use = function(self, event, target, player, data)
    local n = data.damage
    data:preventDamage()
    player:drawCards(n * 2, weimu.name)
  end,
})

weimu:addEffect("prohibit", {
  is_prohibited = function(self, from, to, card)
    return to:hasSkill(weimu.name) and card and card.type == Card.TypeTrick and card.color == Card.Black
  end,
})

return weimu