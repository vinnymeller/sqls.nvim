local M = {}

M.get_prev_str_occurrence_from_buf = function(str)
    local prev_pos = vim.fn.searchpos(str, 'bnWz')
    return prev_pos[1], prev_pos[2]
end

M.get_next_str_occurrence_from_buf = function(str)
    local prev_pos = vim.fn.searchpos(str, 'cnWz')
    return prev_pos[1], prev_pos[2]
end

M.get_text_between_pos = function(start_line, start_col, end_line, end_col)
    return vim.api.nvim_buf_get_text(
        0,
        start_line - 1,
        start_col,
        end_line - 1,
        end_col,
        {}
    )
end

M.write_lines_to_temp_file = function(lines)
    local temp_file = vim.fn.tempname()
    vim.fn.writefile(lines, temp_file)
    return temp_file
end

M.write_text_to_temp_file = function(text)
    local temp_file = vim.fn.tempname()
    local file = io.open(temp_file, "w")
    -- check if file is nil
    if file == nil then
        print("Error: unable to make temp file " .. temp_file)
        return
    end
    file:write(text)
    file:close()
    return temp_file
end


return M
