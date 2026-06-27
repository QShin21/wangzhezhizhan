local qiaobian = fk.CreateSkill {
  name = "wzzz_v__ol_ex__qiaobian"
}

Fk:loadTranslationTable {
  ["wzzz_v__ol_ex__qiaobian"] = "巧变",
  [":wzzz_v__ol_ex__qiaobian"] = "你可以弃置一张手牌并跳过你的一个阶段（准备阶段和结束阶段除外），若你以此法跳过了：摸牌阶段，你可以获得至多两名其他角色的各一张手牌；出牌阶段，你可以移动场上的一张牌。回合结束时，若你本回合跳过了至少三个阶段，你可以摸两张牌。",

  ["#wzzz_v__ol_ex__qiaobian-invoke"] = "巧变：弃置一张手牌并跳过 %arg",
  ["#wzzz_v__ol_ex__qiaobian-prey"] = "巧变：你可以选择至多两名其他角色，获得这些角色各一张手牌",
  ["#wzzz_v__ol_ex__qiaobian-move"] = "巧变：你可以移动场上的一张牌",
  ["#wzzz_v__ol_ex__qiaobian-draw"] = "巧变：你本回合跳过了至少三个阶段，可以摸两张牌",

  ["$wzzz_v__ol_ex__qiaobian1"] = "顺势而变，则胜矣。",
  ["$wzzz_v__ol_ex__qiaobian2"] = "万物变化，固无休息。",
}

qiaobian:addEffect(fk.EventPhaseChanging, {
  anim_type = "control",
  can_trigger = function (self, event, target, player, data)
    return target == player and player:hasSkill(qiaobian.name) and not player:isKongcheng() and
      (data.phase > Player.Start and data.phase < Player.Finish) and not data.skipped
  end,
  on_cost = function (self, event, target, player, data)
    local cards = player.room:askToDiscard(player, {
      min_num = 1,
      max_num = 1,
      include_equip = false,
      skill_name = qiaobian.name,
      cancelable = true,
      prompt = "#wzzz_v__ol_ex__qiaobian-invoke:::" .. Util.PhaseStrMapper(data.phase),
      skip = true,
    })
    if #cards > 0 then
      event:setCostData(self, {cards = cards})
      return true
    end
  end,
  on_use = function (self, event, target, player, data)
    local room = player.room
    data.skipped = true
    room:throwCard(event:getCostData(self).cards, qiaobian.name, player, player)
    room:addPlayerMark(player, "wzzz_v__ol_ex__qiaobian_skipped-turn", 1)
    if player.dead then return false end

    if data.phase == Player.Draw then
      local targets = table.filter(room:getOtherPlayers(player, false), function(p)
        return not p:isKongcheng()
      end)
      if #targets > 0 then
        local tos = room:askToChoosePlayers(player, {
          min_num = 1,
          max_num = 2,
          targets = targets,
          skill_name = qiaobian.name,
          prompt = "#wzzz_v__ol_ex__qiaobian-prey",
          cancelable = true,
        })
        if #tos > 0 then
          room:sortByAction(tos)
          for _, p in ipairs(tos) do
            if player.dead then return end
            if not p:isKongcheng() then
              local card_id = room:askToChooseCard(player, {
                skill_name = qiaobian.name,
                target = p,
                flag = "h",
              })
              room:obtainCard(player, card_id, false, fk.ReasonPrey, player, qiaobian.name)
            end
          end
        end
      end
    elseif data.phase == Player.Play and #room:canMoveCardInBoard() > 0 then
      local targets = room:askToChooseToMoveCardInBoard(player, {
        prompt = "#wzzz_v__ol_ex__qiaobian-move",
        skill_name = qiaobian.name,
        cancelable = true,
      })
      if #targets == 2 then
        room:askToMoveCardInBoard(player, {
          target_one = targets[1],
          target_two = targets[2],
          skill_name = qiaobian.name,
        })
      end
    end
  end
})

qiaobian:addEffect(fk.EventPhaseStart, {
  anim_type = "drawcard",
  can_trigger = function (self, event, target, player, data)
    return target == player and player:hasSkill(qiaobian.name) and player.phase == Player.Finish and
      player:getMark("wzzz_v__ol_ex__qiaobian_skipped-turn") >= 3
  end,
  on_cost = function(self, event, target, player, data)
    return player.room:askToSkillInvoke(player, {
      skill_name = qiaobian.name,
      prompt = "#wzzz_v__ol_ex__qiaobian-draw",
    })
  end,
  on_use = function (self, event, target, player, data)
    player:drawCards(2, qiaobian.name)
  end
})

return qiaobian
