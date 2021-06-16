function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

function clamp(v,min,max)
    if v < min then
        return min
    end
    if v > max then
        return max
    end
    return v
end

tau = 2*math.pi

function polygon(n,pos,size,angle)
    local v = {}
    for i=0,n-1 do
        local theta = angle + i*(tau/n)
        local vec = angle2vec(theta)
        vec.x = size * vec.x + pos.x
        vec.y = size * vec.y + pos.y
        v[i*2+1] = vec.x
        v[i*2+2] = vec.y
    end
    return v
end

function angle2vec(angle)
    return {x = math.cos(angle), y = math.sin(angle)}
end

function vec2angle(vec)
    return math.atan2(vec.y, vec.x)
end

function add(v1,v2)
    return {x = v1.x + v2.x, y = v1.y + v2.y}
end

function diff(v1,v2)
    return {x = v1.x - v2.x, y = v1.y - v2.y}
end

function mul(v, c)
    return {x = v.x*c, y=v.y*c}
end

function rotate(v,angle)
    return {x = x*math.cos(angle) - y*math.sin(angle),
            y = x*math.sin(angle) - y*math.cos(angle)}
end

function norm(v)
    return math.sqrt(v.x*v.x + v.y*v.y)
end

function normalize(v)
    return mul(v, 1/norm(v))
end

function dist(pos1, pos2)
    return norm( diff(pos1, pos2) )
end

function vectorFromPointToPlayer(pos)
    return diff(player.pos, pos)
end

function sign(x)
    if x == 0 then return 1 end
    return x/math.abs(x)
end
