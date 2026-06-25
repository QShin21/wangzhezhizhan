local wzzz_v__midao = fk.CreateSkill{
  name = "wzzz_v__midao",
}

Fk:loadTranslationTable{
  ["wzzz_v__midao"] = "米道",
  [":wzzz_v__midao"] = "当一张判定牌生效前，你可以打出一张“米”代替之。",

  ["#wzzz_v__midao-ask"] = "米道：你可以打出一张“米”修改 %dest 的“%arg”判定",

  ["$wzzz_v__midao1"] = "从善从良，从五斗米道。",
  ["$wzzz_v__midao2"] = "兼济天下，解百姓之忧。",
}

wzzz_v__midao:addEffect(fk.AskForRetrial, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return player:hasSkill(wzzz_v__midao.name) and #player:getPile("zhanglu_mi") > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local cards = room:askToCards(player, {
      min_num = 1,
      max_num = 1,
      skill_name = wzzz_v__midao.name,
      pattern = ".|.|.|zhanglu_mi",
      prompt = "#wzzz_v__midao-ask::"..target.id..":"..data.reason,
      cancelable = true,
      expand_pile = "zhanglu_mi",
    })
    if #cards > 0 then
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    player.room:changeJudge{
      card = Fk:getCardById(event:getCostData(self).cards[1]),
      player = player,
      data = data,
      skillName = wzzz_v__midao.name,
      response = true,
    }
  end,
})

return wzzz_v__midao
