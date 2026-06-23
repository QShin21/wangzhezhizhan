local loaded = false

return function(extension)
  if loaded then return end

  extension:loadSkillSkelsByPath("./packages/wangzhezhizhan/pkg/lords/skills")
  extension:loadSkillSkelsByPath("./packages/wangzhezhizhan/pkg/generals/skills")
  extension:loadSkillSkelsByPath("./packages/wangzhezhizhan/vendor/skills")

  loaded = true
end
