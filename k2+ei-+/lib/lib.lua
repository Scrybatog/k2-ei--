local sa_lib = {}

function ei_lib.set_properties(obj)
    if not (obj and obj.name and obj.type) then
        log(serpent.log({["Invalid object:"] = obj}))
        return
    end
    local prototype = data.raw[obj.type][obj.name]
    if not prototype then
        log("Could not find prototype"..obj.type.."/"..obj.name)
        return
    end
    recursive_copy(prototype, obj)
end