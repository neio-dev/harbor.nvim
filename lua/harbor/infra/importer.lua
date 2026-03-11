local Importer = {}

Importer.override = function(overrides)
    for mod, replacement in pairs(overrides) do
        package.loaded[mod] = require(replacement)
    end
end

Importer.reset = function(mods)
    for _, mod in ipairs(mods) do
        package.loaded[mod] = nil
    end
end

return Importer
