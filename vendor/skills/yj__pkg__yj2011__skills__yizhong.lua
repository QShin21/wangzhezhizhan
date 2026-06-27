
local yizhong = fk.CreateSkill {
  name = "wzzz_v__yizhong",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__yizhong"] = "毅重",
  [":wzzz_v__yizhong"] = "锁定技，若你装备区里没有防具牌，则梅花【杀】对你无效。",

  ["$wzzz_v__yizhong1"] = "不先为备，何以待敌？",
  ["$wzzz_v__yizhong2"] = "稳重行军，百战不殆！",
}

yizhong:addEffect(fk.PreCardEffect, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(yizhong.name) and data.card.trueName == "slash" and data.to == player and
      data.card.suit == Card.Club and #player:getEquipments(Card.SubtypeArmor) == 0
  end,
  on_use = function (self, event, target, player, data)
    player.room:broadcastPlaySound("./packages/standard_cards/audio/card/nioh_shield")
    player.room:setEmotion(player, "./packages/standard_cards/image/anim/nioh_shield")
    data.nullified = true
  end,
})

return yizhong
