ei_lib = require("lib/lib")

local EI_CHANGES = {
    ["item"] = {
        ["ei_alien-seed"] = {localised_name = {"ei_alien-seed"},}
    },
}

for source, group in pairs(EI_CHANGES) do
    for name, object in pairs(group) do
        object.name = name
        object.type = source
        ei_lib.set_properties(object)
    end
end