local xinsheng = fk.CreateSkill {
  name = "wzzz_v__xinsheng",
}

Fk:loadTranslationTable{
  ["wzzz_v__xinsheng"] = "新生",
  [":wzzz_v__xinsheng"] = "当你受到1点伤害后，你可以将一张未加入游戏的武将牌扣置为“化身”。",

  ["$wzzz_v__xinsheng1"] = "幻幻无穷，生生不息。",
  ["$wzzz_v__xinsheng2"] = "吐故纳新，师法天地。",
}

local U = require "packages.wangzhezhizhan.vendor.modules.utility.utility"

xinsheng:addEffect(fk.Damaged, {
  anim_type = "masochism",
  can_trigger = function(self, event, target, player, data)
    local huashen = WzzzHuashen
    return target == player and player:hasSkill(xinsheng.name) and huashen and
      #huashen.getAvailableGenerals(player) > 0
  end,
  trigger_times = function(self, event, target, player, data)
    return data.damage
  end,
  on_cost = function(self, event, target, player, data)
    if player.room:askToSkillInvoke(player, {
      skill_name = xinsheng.name,
    }) then
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local generals = U.getPrivateMark(player, "&huanshen")
    local huashen = WzzzHuashen
    local picked = huashen and huashen.drawGenerals(player, 1) or {}
    if #picked == 0 then return end
    table.insert(generals, picked[1])
    U.setPrivateMark(player, "&huanshen", generals)
  end,
})

return xinsheng
