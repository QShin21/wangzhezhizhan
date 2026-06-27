local qiaomeng = fk.CreateSkill {
  name = "wzzz_v__ty_ex__qiaomeng",
}

Fk:loadTranslationTable{
  ["wzzz_v__ty_ex__qiaomeng"] = "趫猛",
  [":wzzz_v__ty_ex__qiaomeng"] = "当你使用黑色牌指定其他角色为目标后，你可以弃置其中一名目标角色一张牌，若弃置的牌为：武器牌，此牌不能被响应；坐骑牌，你获得之。",

  ["#wzzz_v__ty_ex__qiaomeng-choose"] = "趫猛：弃置一名目标角色的一张牌，若为武器则此牌不可响应，若为坐骑则你获得之",

  ["$wzzz_v__ty_ex__qiaomeng1"] = "猛士骁锐，可慑百蛮失蹄！",
  ["$wzzz_v__ty_ex__qiaomeng2"] = "锐士志猛，可凭白手夺马！",
}

qiaomeng:addEffect(fk.TargetSpecified, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(qiaomeng.name) and
      data.card.color == Card.Black and data.firstTarget and
      table.find(data.use.tos, function(p)
        return p ~= player and not p:isNude()
      end)
  end,
  on_cost = function (self, event, target, player, data)
    local room = player.room
    local targets = table.filter(data.use.tos, function(p)
      return p ~= player and not p:isNude()
    end)
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = targets,
      prompt = "#wzzz_v__ty_ex__qiaomeng-choose",
      skill_name = qiaomeng.name,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    local id = room:askToChooseCard(player, {
      target = to,
      flag = "he",
      skill_name = qiaomeng.name,
    })
    local card = Fk:getCardById(id, true)
    if card.sub_type == Card.SubtypeOffensiveRide or card.sub_type == Card.SubtypeDefensiveRide then
      room:obtainCard(player, id, false, fk.ReasonPrey, player, qiaomeng.name)
    else
      room:throwCard(id, qiaomeng.name, to, player)
      if card.sub_type == Card.SubtypeWeapon then
        data.use.disresponsiveList = table.simpleClone(room.players)
      end
    end
  end,
})

return qiaomeng
