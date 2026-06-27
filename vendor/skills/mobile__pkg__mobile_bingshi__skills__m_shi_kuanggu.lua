local mShiKuanggu = fk.CreateSkill {
  name = "wzzz_v__m_shi__kuanggu",
}

Fk:loadTranslationTable{
  ["wzzz_v__m_shi__kuanggu"] = "狂骨",
  [":wzzz_v__m_shi__kuanggu"] = "当你对距离1以内的一名角色造成伤害后，你可以选择一项：1.回复1点体力；2.摸一张牌；3.回复1点体力并摸一张牌，然后弃置一张牌，令你此阶段内使用【杀】的次数+1（每回合限一次）。",

  ["$wzzz_v__m_shi__kuanggu1"] = "曹贼吴犬，我有何惧哉？",
  ["$wzzz_v__m_shi__kuanggu2"] = "我尚未全力一搏，又试问谁能阻挡？",
  ["$wzzz_v__m_shi__kuanggu3"] = "饮罢贼血，看我再立功绩。",
  ["$wzzz_v__m_shi__kuanggu4"] = "与我为敌，是汝等最大的不幸。",
  ["$wzzz_v__m_shi__kuanggu5"] = "贼寇尚未尽戮，我岂会还营？",
  ["$wzzz_v__m_shi__kuanggu6"] = "可还有强敌，能让我浅尝一败？",
}

mShiKuanggu:addEffect(fk.Damage, {
  mute = true,
  can_trigger = function(self, event, target, player, data)
    return target == player and player:hasSkill(mShiKuanggu.name) and
      (data.extra_data or {}).kuangguCheck
  end,
  on_cost = function(self, event, target, player, data)
    local room = player.room
    local allChoices = { "draw1", "recover", "beishui", "Cancel" }
    local choices = table.simpleClone(allChoices)
    if player:getMark("wzzz_v__m_shi__kuanggu_beishui-turn") > 0 then
      table.removeOne(choices, "beishui")
    end
    if not player:isWounded() then
      table.removeOne(choices, "recover")
    end
    local choice = room:askToChoice(player, {
      choices = choices,
      skill_name = mShiKuanggu.name,
      all_choices = allChoices,
    })
    if choice ~= "Cancel" then
      event:setCostData(self, { choice = choice })
      return true
    end
  end,
  on_use = function(self, event, target, player, data)
    local room = player.room
    local choice = event:getCostData(self).choice
    local audioIndex = choice == "beishui" and math.random(5, 6) or math.random(1, 2)

    player:broadcastSkillInvoke(mShiKuanggu.name, audioIndex)
    room:notifySkillInvoked(player, mShiKuanggu.name, "drawcard")

    if choice ~= "draw1" and player:isWounded() then
      room:recover{
        who = player,
        num = 1,
        recoverBy = player,
        skillName = mShiKuanggu.name,
      }
      if not player:isAlive() then return false end
    end

    if choice ~= "recover" then
      player:drawCards(1, mShiKuanggu.name)
      if not player:isAlive() then return false end
    end

    if choice == "beishui" then
      room:addPlayerMark(player, "wzzz_v__m_shi__kuanggu_beishui-turn")
      if not player:isNude() then
        local cards = room:askToDiscard(player, {
          min_num = 1,
          max_num = 1,
          skill_name = mShiKuanggu.name,
          include_equip = true,
          cancelable = false,
        })
        if #cards > 0 then
          room:addPlayerMark(player, MarkEnum.SlashResidue .. "-phase", 1)
        end
      end
    end
  end,
})

mShiKuanggu:addEffect(fk.BeforeHpChanged, {
  can_refresh = function(self, event, target, player, data)
    if data.damageEvent and player == data.damageEvent.from and player:compareDistance(target, 2, "<") then
      return true
    end
  end,
  on_refresh = function(self, event, target, player, data)
    data.damageEvent.extra_data = data.damageEvent.extra_data or {}
    data.damageEvent.extra_data.kuangguCheck = true
  end,
})

return mShiKuanggu
