local wzzz_v__yishe = fk.CreateSkill{
  name = "wzzz_v__yishe",
  derived_piles = "zhanglu_mi",
}

Fk:loadTranslationTable{
  ["wzzz_v__yishe"] = "义舍",
  [":wzzz_v__yishe"] = "游戏开始时或结束阶段，若“米”数量小于3，你可以摸两张牌，然后将两张牌置于武将牌上，称为“米”；当你移去最后一张“米”时，你可以回复1点体力。",

  ["zhanglu_mi"] = "米",
  ["#wzzz_v__yishe-ask"] = "义舍：将两张牌置为“米”",
  ["#wzzz_v__yishe-recover"] = "义舍：你可以回复1点体力",

  ["$wzzz_v__yishe1"] = "行大义之举，须有向道之心。",
  ["$wzzz_v__yishe2"] = "你有你的权谋，我，哼，自有我的道义。",
}

local function addMi(player)
  local room = player.room
  player:drawCards(2, wzzz_v__yishe.name)
  if player.dead or #player:getCardIds("he") < 2 then return end
  local cards = room:askToCards(player, {
    min_num = 2,
    max_num = 2,
    include_equip = true,
    skill_name = wzzz_v__yishe.name,
    prompt = "#wzzz_v__yishe-ask",
    cancelable = false,
  })
  player:addToPile("zhanglu_mi", cards, true, wzzz_v__yishe.name)
end

wzzz_v__yishe:addEffect(fk.GameStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(wzzz_v__yishe.name) and #player:getPile("zhanglu_mi") < 3 and
      not (WzzzHuashen and WzzzHuashen.shouldSkipOpeningTiming(player, wzzz_v__yishe.name))
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    addMi(player)
  end,
})

wzzz_v__yishe:addEffect(fk.EventPhaseStart, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(wzzz_v__yishe.name) and player.phase == Player.Finish and
      #player:getPile("zhanglu_mi") < 3
  end,
  on_use = function(self, event, target, player, data)
    addMi(player)
  end,
})
wzzz_v__yishe:addEffect(fk.AfterCardsMove, {
  anim_type = "support",
  can_trigger = function(self, event, target, player, data)
    if player:hasSkill(wzzz_v__yishe.name) and #player:getPile("zhanglu_mi") == 0 and player:isWounded() then
      for _, move in ipairs(data) do
        if move.from == player then
          for _, info in ipairs(move.moveInfo) do
            if info.fromSpecialName == "zhanglu_mi" then
              return true
            end
          end
        end
      end
    end
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = wzzz_v__yishe.name,
      prompt = "#wzzz_v__yishe-recover",
    })
  end,
  on_use = function(self, event, target, player, data)
    player.room:recover{
      who = player,
      num = 1,
      recoverBy = player,
      skillName = wzzz_v__yishe.name,
    }
  end,
})

return wzzz_v__yishe
