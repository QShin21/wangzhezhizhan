local zhengu = fk.CreateSkill {
  name = "wzzz_v__zhengu",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhengu"] = "镇骨",
  [":wzzz_v__zhengu"] = "结束阶段，你可以选择一名其他角色，本回合结束时和其下个回合结束时，其将手牌摸或弃至与你手牌数量相同（至多摸至五张）。",

  ["#wzzz_v__zhengu-choose"] = "镇骨：选择一名其他角色，本回合结束时和其下个回合结束时其将手牌调整与你相同",
  ["@@wzzz_v__zhengu"] = "镇骨",

  ["$wzzz_v__zhengu1"] = "镇守城池，必以骨相拼！",
  ["$wzzz_v__zhengu2"] = "孔明计虽百算，却难敌吾镇骨千具！",
}

zhengu:addLoseEffect(function (self, player, is_death)
  if is_death or (WzzzHuashen and WzzzHuashen.isHuashenSkill(player, zhengu.name)) then
    local room = player.room
    for _, p in ipairs(room.alive_players) do
      room:removeTableMark(p, "@@wzzz_v__zhengu", player.id)
    end
  end
end)
zhengu:addEffect(fk.EventPhaseStart, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(zhengu.name) and player.phase == Player.Finish and
      #player.room:getOtherPlayers(player, false) > 0
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local to = room:askToChoosePlayers(player, {
      min_num = 1,
      max_num = 1,
      targets = room:getOtherPlayers(player, false),
      skill_name = zhengu.name,
      prompt = "#wzzz_v__zhengu-choose",
      cancelable = true,
    })
    if #to > 0 then
      event:setCostData(self, {tos = to})
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local to = event:getCostData(self).tos[1]
    room:addTableMarkIfNeed(to, "@@wzzz_v__zhengu", player.id)
    local x, y, z = player:getHandcardNum(), to:getHandcardNum(), 0
    if x > y then
      z = math.min(5, x) - y
      if z > 0 then
        room:drawCards(to, z, zhengu.name)
      end
    elseif x < y then
      z = y - x
      room:askToDiscard(to, {
        min_num = z,
        max_num = z,
        include_equip = false,
        skill_name = zhengu.name,
        cancelable = false,
      })
    end
  end,
})
zhengu:addEffect(fk.TurnEnd, {
  anim_type = "control",
  can_trigger = function(self, event, target, player, data)
    if target.dead or player.dead then return end
    if table.contains(target:getTableMark("@@wzzz_v__zhengu"), player.id) then
      local x, y = player:getHandcardNum(), target:getHandcardNum()
      return x < y or (x > y and y < 5)
    end
  end,
  on_cost = Util.TrueFunc,
  on_use = function(self, event, target, player, data)
    local room = player.room
    room:doIndicate(player.id, {target.id})
    local x, y, z = player:getHandcardNum(), target:getHandcardNum(), 0
    if x > y then
      z = math.min(5, x) - y
      if z > 0 then
        room:drawCards(target, z, zhengu.name)
      end
    elseif x < y then
      z = y - x
      room:askToDiscard(target, {
        min_num = z,
        max_num = z,
        include_equip = false,
        skill_name = zhengu.name,
        cancelable = false,
      })
    end
  end,
})
zhengu:addEffect(fk.TurnEnd, {
  late_refresh = true,
  can_refresh = function(self, event, target, player, data)
    return target == player and player:getMark("@@wzzz_v__zhengu") ~= 0
  end,
  on_refresh = function(self, event, target, player, data)
    player.room:setPlayerMark(player, "@@wzzz_v__zhengu", 0)
  end,
})

return zhengu
