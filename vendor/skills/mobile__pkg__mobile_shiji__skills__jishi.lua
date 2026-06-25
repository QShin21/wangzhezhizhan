local wzzz_v__jishi = fk.CreateSkill {
  name = "wzzz_v__jishi",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable{
  ["wzzz_v__jishi"] = "济世",
  [":wzzz_v__jishi"] = "锁定技，你使用牌结算后，若此牌没有造成伤害，则将之置入<a href='RenPile_href'>“仁”区</a>；"..
  "当“仁”牌不因溢出而离开“仁”区后，你摸一张牌。",

  ["$wzzz_v__jishi1"] = "勤求古训，常怀济人之志。",
  ["$wzzz_v__jishi2"] = "博采众方，不随趋势之徒。",
}

local U = require "packages.wangzhezhizhan.vendor.modules.utility.utility"

wzzz_v__jishi:addEffect(fk.CardUseFinished, {
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__jishi.name) and not data.damageDealt and
      player.room:getCardArea(data.card) == Card.Processing
  end,
  on_use = function(self, event, target, player, data)
    U.AddToRenPile(player, data.card, wzzz_v__jishi.name)
  end,
})
wzzz_v__jishi:addEffect(fk.AfterCardsMove, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(wzzz_v__jishi.name) then
      for _, move in ipairs(data) do
        if move.extra_data and move.extra_data.removefromrenpile and move.skillName ~= "ren_overflow" then
          return true
        end
      end
    end
  end,
  on_use = function (self, event, target, player, data)
    player:drawCards(1, wzzz_v__jishi.name)
  end,
})

return wzzz_v__jishi
