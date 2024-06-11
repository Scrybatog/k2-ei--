local sa_lib = require("lib.lib")

local EI_CHANGES = {
    ["item"] = {
        ["ei_alien-seed"] = {localised_name = {"item-name.ei_alien-seed"}}
    }
}

for source, group in pairs(EI_CHANGES) do
    for name, object in pairs(group) do
        object.name = name
        object.type = source
        sa_lib.set_properties(object)
    end
end

local model = {}

model.destroy_non_gaia = {
    ["ei_gaia-pump"] = false,
    ["ei_bio-chamber"] = false,
    ["ei_bio-reactor"] = false,
}

function model.create_drop(entity)

    if not model.entity_check(entity) then
        return
    end

    -- create an item drop of this entity at its pos
    -- that is marked for deconstruction

    local surface = entity.surface
    local pos = entity.position
    local drop_name = entity.name -- only works if item name is the same as entity name

    -- create the drop
    local drop = surface.create_entity({
        name = "item-on-ground",
        position = pos,
        stack = {name = drop_name, count = 1}
    })

    -- mark the drop for deconstruction
    drop.order_deconstruction(entity.force)

end

function model.destroy_building(entity)

    local destroy_gaia = model.destroy_gaia
    local destroy_non_gaia = model.destroy_non_gaia
    local surface = entity.surface

    if destroy_gaia[entity.name] then

        if surface.name == "gaia" then

            -- create flying text
            surface.create_entity({
                name = "flying-text",
                position = entity.position,
                text = "Can't build on Gaia!",
                color = {r=1, g=0, b=0}
            })
            model.create_drop(entity)

            entity.destroy()
            return
        end

    end

    if destroy_non_gaia[entity.name] then

        if surface.name ~= "gaia" then

            -- create flying text
            surface.create_entity({
                name = "flying-text",
                position = entity.position,
                text = "Can only be built on Gaia!",
                color = {r=1, g=0, b=0}
            })
            model.create_drop(entity)

            entity.destroy()
            return
        end

    end
end



function model.on_built_entity(entity)

    if model.entity_check(entity) == false then
        return
    end

    model.destroy_building(entity)
    model.swap_entity(entity)
    model.register_entity(entity)

end


function model.update()

    model.update_entity_lifetimes()

end

return model