local zhiba_active = fk.CreateSkill {
  name = "wzzz_v__zhiba_active&",
}

Fk:loadTranslationTable{
  ["wzzz_v__zhiba_active&"] = "制霸",
  [":wzzz_v__zhiba_active&"] = "出牌阶段限一次，你可以与拥有“制霸”的角色拼点（其可以拒绝此拼点），若你没赢，其可以获得拼点的两张牌。",

  ["#wzzz_v__zhiba"] = "制霸：你可以与孙策拼点",
}

zhiba_active:addEffect("active", {
  mute = true,
  prompt = "#wzzz_v__zhiba",
  card_num = 0,
  target_num = 0,
  can_use = function(self, player)
    return player:usedSkillTimes(zhiba_active.name, Player.HistoryPhase) == 0 and player.kingdom == "wu" and not player:isKongcheng() and
      table.find(Fk:currentRoom().alive_players, function(p)
        return p:hasSkill("wzzz_v__zhiba") and p ~= player and player:canPindian(p)
      end)
  end,
  card_filter = Util.FalseFunc,
  on_use = function(self, room, effect)
    local player = effect.from
    local targets = table.filter(room.alive_players, function(p)
      return p:hasSkill("wzzz_v__zhiba") and p ~= player and player:canPindian(p)
    end)
    local target
    if #targets == 1 then
      target = targets[1]
    else
      target = room:askToChoosePlayers(player, {
        min_num = 1,
        max_num = 1,
        targets = targets,
        skill_name = "wzzz_v__zhiba",
        prompt = "#wzzz_v__zhiba",
        cancelable = false,
      })[1]
    end
    if not target then return end
    room:notifySkillInvoked(target, "wzzz_v__zhiba")
    target:broadcastSkillInvoke("wzzz_v__zhiba")
    room:doIndicate(player.id, { target.id })
    if room:askToChoice(target, {
        choices = {"wzzz_v__zhiba_yes", "wzzz_v__zhiba_no"},
        skill_name = "wzzz_v__zhiba",
        prompt = "#wzzz_v__zhiba-ask:" .. player.id,
      }) == "wzzz_v__zhiba_no" then
      return
    end
    local pindian = player:pindian({target}, "wzzz_v__zhiba")
    if target.dead then return end
    if pindian.results[target].winner ~= player then
      local to_get = {}
      local cid = pindian.fromCard and pindian.fromCard:getEffectiveId()
      if room:getCardArea(cid) == Card.DiscardPile then
        table.insert(to_get, cid)
      end
      local toCard = pindian.results[target].toCard
      cid = toCard and toCard:getEffectiveId()
      if room:getCardArea(cid) == Card.DiscardPile then
        table.insertIfNeed(to_get, cid)
      end
      if #to_get > 0 then
        room:obtainCard(target, to_get, true, fk.ReasonJustMove, target, "wzzz_v__zhiba")
      end
    end
  end,
})

return zhiba_active
