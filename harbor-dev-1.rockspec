package = "harbor"
version = "dev-1"
source = {
   url = "git+https://github.com/neio-dev/harbor.git"
}
description = {
   summary = "> Project in heavy development, you can use it but lot of changes are expected before full release.",
   detailed = "> Project in heavy development, you can use it but lot of changes are expected before full release. ",
   homepage = "https://github.com/neio-dev/harbor",
   license = "*** please specify a license ***"
}
dependencies = {
   queries = {}
}
build_dependencies = {
   queries = {}
}
build = {
   type = "builtin",
   modules = {
      ["harbor.core.commands"] = "lua/harbor/core/commands.lua",
      ["harbor.core.config"] = "lua/harbor/core/config.lua",
      ["harbor.core.harbor"] = "lua/harbor/core/harbor.lua",
      ["harbor.core.lighthouse"] = "lua/harbor/core/lighthouse.lua",
      ["harbor.domain.bay"] = "lua/harbor/domain/bay.lua",
      ["harbor.domain.dock"] = "lua/harbor/domain/dock.lua",
      ["harbor.domain.fleet"] = "lua/harbor/domain/fleet.lua",
      ["harbor.domain.ship"] = "lua/harbor/domain/ship.lua",
      ["harbor.extensions.builtins.lualine"] = "lua/harbor/extensions/builtins/lualine.lua",
      ["harbor.extensions.builtins.telescope"] = "lua/harbor/extensions/builtins/telescope.lua",
      ["harbor.extensions.extension"] = "lua/harbor/extensions/extension.lua",
      ["harbor.extensions.init"] = "lua/harbor/extensions/init.lua",
      ["harbor.infra.buffers"] = "lua/harbor/infra/buffers.lua",
      ["harbor.infra.emitter"] = "lua/harbor/infra/emitter.lua",
      ["harbor.infra.input"] = "lua/harbor/infra/input.lua",
      ["harbor.infra.sessions"] = "lua/harbor/infra/sessions.lua",
      ["harbor.infra.windows"] = "lua/harbor/infra/windows.lua",
      ["harbor.init"] = "lua/harbor/init.lua",
      ["harbor.tests.test_ship"] = "lua/harbor/tests/test_ship.lua",
      ["harbor.types"] = "lua/harbor/types.lua",
      ["harbor.ui.icons"] = "lua/harbor/ui/icons.lua",
      ["harbor.ui.init"] = "lua/harbor/ui/init.lua",
      ["harbor.utils.init"] = "lua/harbor/utils/init.lua",
      ["harbor.utils.input"] = "lua/harbor/utils/input.lua",
      ["harbor.utils.table"] = "lua/harbor/utils/table.lua"
   },
   copy_directories = {
      "doc"
   }
}
test_dependencies = {
   queries = {}
}
