local helpers = {}

function helpers:color_markup(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

return helpers
