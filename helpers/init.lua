local cairo = require("lgi").cairo


local helpers = {}

function helpers:color_markup(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers:addMarginsToImage(image, marginSize)
    local img = cairo.ImageSurface.create_from_png(image)

    local width = img:get_width()
    local height = img:get_height()

    local newWidth = width + 2 * marginSize
    local newHeight = height + 2 * marginSize

    local newImg = cairo.ImageSurface(cairo.Format.RGB24, newWidth, newHeight)

    local cr = cairo.Context(newImg)

    cr:set_source_surface(img, marginSize, marginSize)

    cr:paint()

    return newImg
end

return helpers
