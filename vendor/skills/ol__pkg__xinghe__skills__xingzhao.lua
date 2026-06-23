local xingzhao = fk.CreateSkill{
  name = "wzzz_v__xingzhao",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__xingzhao"] = "兴棹",
  [":wzzz_v__xingzhao"] = "锁定技，场上受伤的角色为：1个或以上，你拥有技能〖恂恂〗；2个或以上，你使用装备牌时摸一张牌；3个或以上，你跳过弃牌阶段。",

  ["$wzzz_v__xingzhao1"] = "精挑细选，方能成百年之计。",
  ["$wzzz_v__xingzhao2"] = "拿些上好的木料来。",
}

xingzhao:addEffect(fk.CardUsing, {
  anim_type = "drawcard",
  can_trigger = function (self, event, target, player, data)
    return target == player and player:hasSkill(xingzhao.name) and data.card.type == Card.TypeEquip and
      #table.filter(player.room.alive_players, function(p)
        return p:isWounded()
      end) > 1
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, xingzhao.name)
  end,
})
xingzhao:addEffect(fk.EventPhaseChanging, {
  anim_type = "defensive",
  can_trigger = function (self, event, target, player, data)
    return target == player and player:hasSkill(xingzhao.name) and data.phase == Player.Discard and
      #table.filter(player.room.alive_players, function(p)
        return p:isWounded()
      end) > 2 and
      not data.skipped
  end,
  on_use = function(self, event, target, player, data)
    data.skipped = true
  end,
})

local xingzhao_spec = {
  can_refresh = function (self, event, target, player, data)
    return player:hasSkill(xingzhao.name, true) and
      ((player:hasSkill("wzzz_v__xunxun", true) and not table.find(player.room.alive_players, function(p)
        return p:isWounded()
      end)) or
      (not player:hasSkill("wzzz_v__xunxun", true) and table.find(player.room.alive_players, function(p)
        return p:isWounded()
      end)))
  end,
  on_refresh = function(self, event, target, player, data)
    if player:hasSkill("wzzz_v__xunxun", true) then
      player.room:handleAddLoseSkills(player, "-wzzz_v__xunxun")
    else
      player.room:handleAddLoseSkills(player, "wzzz_v__xunxun")
    end
  end,
}

xingzhao:addEffect(fk.HpChanged, xingzhao_spec)
xingzhao:addEffect(fk.MaxHpChanged, xingzhao_spec)

return xingzhao
