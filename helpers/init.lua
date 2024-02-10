local helpers = {}

function helpers:color_markup(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers:uppercase_first_letter(text)
    return text:gsub("%S+", function(word) return word:sub(1,1):upper()..word:sub(2) end)
end

return helpers
