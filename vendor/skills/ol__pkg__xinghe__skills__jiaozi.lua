local jiaozi = fk.CreateSkill{
  name = "wzzz_v__jiaozi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__jiaozi"] = "骄恣",
  [":wzzz_v__jiaozi"] = "锁定技，当你造成伤害时，若你的手牌数最多，此伤害+1。",

  ["$wzzz_v__jiaozi1"] = "数战之功，吾应得此赏！",
  ["$wzzz_v__jiaozi2"] = "无我出力，怎会连胜？",
}

local jiaozi_spec = { ---@type TrigSkelSpec<fun(self: TriggerSkill, event: DamageEvent, target: ServerPlayer, player: ServerPlayer, data: DamageData):any>
  anim_type = "offensive",
  can_trigger = function(self, event, target, player, data)
    if target == player and player:hasSkill(jiaozi.name) and
      table.every(player.room:getOtherPlayers(player, false), function(p)
        return player:getHandcardNum() >= p:getHandcardNum()
      end) then
      event:setCostData(self, { tos = { data.to } })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    data:changeDamage(1)
  end,
}

jiaozi:addEffect(fk.DamageCaused, jiaozi_spec)

return jiaozi
