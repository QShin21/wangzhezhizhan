local pangtongBazhen = fk.CreateSkill {
  name = "wzzz_v__pangtong__bazhen",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz_v__pangtong__bazhen"] = "八阵",
  [":wzzz_v__pangtong__bazhen"] = "锁定技，若你的装备区里没有防具牌，你视为装备着【八卦阵】。你的【八卦阵】判定失效时，你摸一张牌。",
}

local spec = {
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:broadcastPlaySound("./packages/standard_cards/audio/card/eight_diagram")
    room:setEmotion(player, "./packages/standard_cards/image/anim/eight_diagram")
    local skill = Fk.skills["#eight_diagram_skill"]
    skill:use(event, target, player, data)
  end,
}

pangtongBazhen:addEffect(fk.AskForCardUse, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pangtongBazhen.name) and not player:isFakeSkill(self) and
      (data.pattern and Exppattern:Parse(data.pattern):matchExp("jink|0|nosuit|none")) and
      #player:getEquipments(Card.SubtypeArmor) == 0 and not player:prohibitUse(Fk:cloneCard("jink")) and
      (data.extraData == {} or data.extraData.not_passive ~= true) and
      Fk.skills["#eight_diagram_skill"] ~= nil and Fk.skills["#eight_diagram_skill"]:isEffectable(player)
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = pangtongBazhen.name,
    })
  end,
  on_use = spec.on_use,
})

pangtongBazhen:addEffect(fk.AskForCardResponse, {
  anim_type = "defensive",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pangtongBazhen.name) and not player:isFakeSkill(self) and
      Exppattern:Parse(data.pattern):matchExp("jink|0|nosuit|none") and
      not player:prohibitResponse(Fk:cloneCard("jink")) and not player:getEquipment(Card.SubtypeArmor) and
      Fk.skills["#eight_diagram_skill"] ~= nil and Fk.skills["#eight_diagram_skill"]:isEffectable(player)
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = pangtongBazhen.name,
    })
  end,
  on_use = spec.on_use,
})

pangtongBazhen:addEffect(fk.FinishJudge, {
  anim_type = "drawcard",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(pangtongBazhen.name) and data.reason == "#eight_diagram_skill" and
      #player:getEquipments(Card.SubtypeArmor) == 0 and not data:matchPattern()
  end,
  on_use = function(self, event, target, player, data)
    player:drawCards(1, pangtongBazhen.name)
  end,
})

pangtongBazhen:addAI(Fk.Ltk.AI.newInvokeStrategy {
  think = function(self, ai)
    return ai:getBenefitOfEvents(function(logic)
      logic:judge({
        who = ai.player,
        reason = "#eight_diagram_skill",
        pattern = ".",
      })
    end) >= -100
  end,
})

return pangtongBazhen
