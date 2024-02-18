local M = {}

function M.map(table, fn)
    local t = {}
    for k, v in pairs(table) do
        t[k] = fn(v)
    end
    return t
end

function M.reduce(table, fn, init)
    local acc = init
    for _, v in pairs(table) do
        acc = fn(acc, v)
    end
    return acc
end

return M
