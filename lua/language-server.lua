local M = {}

function M.server(name, setup)
    return {
        name = name,
        setup = setup and setup or {},
    }
end

return M
