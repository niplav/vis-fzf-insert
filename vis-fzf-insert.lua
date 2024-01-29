-- Copyright (C) 2017  Guillaume Chérel
-- Copyright (C) 2023  Matěj Cepl
-- Copyright (c) 2023-2024  niplav
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

module = {}
module.cmd_path = "fzf"
module.cmd_args = {"--height=40%"}
module.paste_prefix = {""}
module.paste_postfix = {""}

local clip_action = vis:action_register("clip", function(keys)
    if #keys == 0 then
        return -1
    end

    idx = tonumber(keys)
    if keys == "[" then
       idx = 1
    elseif keys == "(" then
       idx = 2
    elseif idx == nil then
        vis:info(
            string.format(
                "fzf-clip: Not a number",
                status, command, status
            )
        )
        return 1
    end

    local cmd_path = module.cmd_path

    local command = string.gsub([[
            $cmd_path $cmd_args $args
        ]],
        '%$([%w_]+)', {
            cmd_path = cmd_path,
            cmd_args = module.cmd_args[idx]
        }
    )

    local file = io.popen(command)
    local output = {}
    for line in file:lines() do
        table.insert(output, line)
    end
    local success, msg, status = file:close()

    if status == 0 then
        vis:feedkeys(string.format("i%s%s%s", module.paste_prefix[idx], output[1], module.paste_postfix[idx]))
    elseif status == 1 then
        vis:info(
            string.format(
                "fzf-clip: No match. Command %s exited with return value %i.",
                command, status
            )
        )
    elseif status == 2 then
        vis:info(
            string.format(
                "fzf-clip: Error. Command %s exited with return value %i.",
                command, status
            )
        )
    elseif status == 130 then
        vis:info(
            string.format(
                "fzf-clip: Interrupted. Command %s exited with return value %i",
                command, status
            )
        )
    else
        vis:info(
            string.format(
                "fzf-clip: Unknown exit status %i. command %s exited with return value %i",
                status, command, status
            )
        )
    end

    vis:feedkeys("<vis-redraw>")
    return 1
end, "Insert string from a file")

vis:map(vis.modes.NORMAL, "[[", clip_action)

return module
