local sa_lib = {}


function sa_lib.clean_nils(t)
  local ans = {}
  for _,v in pairs(t) do
    ans[ #ans+1 ] = v
  end
  return ans
end
  
function sa_lib.table_contains_value(table_in, value)
    for i,v in pairs(table_in) do
        if v == value then
            return true
        end
    end
    return false
end

function sa_lib.switch_string(switch_table, string)
    
    -- retrun if no switch_table is given or no string is given
    if not switch_table or not string then
        return nil
    end

    -- loop over switch_table and check if string is in it
    for i,v in pairs(switch_table) do
        if string == i then
            return v
        end
    end

    -- return nil if no match was found
    return nil
end

function sa_lib.config(name)
    return settings.startup["ei_"..name].value
end


-- count how many keys are in a table
function sa_lib.getn(table_in)
    local count = 0
    for _,_ in pairs(table_in) do
        count = count + 1
    end
    return count
end

---@param inputstr string
---@param start string
function sa_lib.starts_with(inputstr, start) 
    return inputstr:sub(1, #start) == start 
end

local function recursive_copy(target, source)
    for key, value in pairs(source) do
        if tostring(key):find('^_') ~= 1 then
            if type(value) == 'table' then
                target[key] = target[key] or {}
                recursive_copy(target[key], source[key])
            else
                target[key] = source[key]
            end
        end
    end
end

function sa_lib.set_properties(obj)
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

return sa_lib