local xiemu = fk.CreateSkill {
  name = "wzzz_v__sxfy__xiemu",
  attached_skill_name = "wzzz_v__sxfy__xiemu&",
}

Fk:loadTranslationTable{
  ["wzzz_v__sxfy__xiemu"] = "协穆",
  [":wzzz_v__sxfy__xiemu"] = "其他角色出牌阶段限一次，其可以展示并交给你一张基本牌，然后本回合其攻击范围+1。",
}

xiemu:addEffect("atkrange", {
  correct_func = function (self, from, to)
    return from:getMark("@@wzzz_v__sxfy__xiemu-turn")
  end,
})

return xiemu
