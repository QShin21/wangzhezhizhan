local shouyu = fk.CreateSkill {
  name = "wzzz__shouyu",
  tags = { Skill.Compulsory },
}

Fk:loadTranslationTable {
  ["wzzz__shouyu"] = "守御",
  [":wzzz__shouyu"] = "锁定技，敌方角色计算与其他己方角色的距离+1。",
}

shouyu:addEffect("distance", {
  correct_func = function(self, from, to)
    local room = Fk:currentRoom()
    if table.find(room.alive_players, function(p)
      return p ~= to and p:hasSkill(shouyu.name) and from:isEnemy(p) and to:isFriend(p)
    end) then return 1 end
  end,
})

return shouyu
