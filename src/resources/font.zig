const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub const FontManager = struct {
    pixel_font: raylib.Font,

    pub fn init() !FontManager {
        return .{
            .pixel_font = try raylib.loadFontEx(
                "./resources/fonts/m6x11.ttf",
                16,
                null,
            ),
        };
    }

    pub fn deinit(self: *FontManager) void {
        raylib.unloadFont(self.pixel_font);
    }

    pub fn drawTextPixel(
        self: *FontManager,
        text: [:0]const u8,
        x: f32,
        y: f32,
        font_size: f32,
        colour: raylib.Color,
    ) void {
        raylib.drawTextEx(
            self.pixel_font,
            text,
            .{ .x = @floor(x), .y = @floor(y) },
            font_size,
            0,
            colour,
        );
    }

    pub fn drawTextPixelCentered(
        self: *FontManager,
        world: *ecs.World,
        text: [:0]const u8,
        font_size: f32,
        y: f32,
        colour: raylib.Color,
    ) void {
        const text_width = raylib.measureText(text, @as(i32, @intFromFloat(font_size)));
        const x = @as(f32, @floatFromInt(world.game.screen_width - text_width)) / 2.0;

        raylib.drawTextEx(
            self.pixel_font,
            text,
            .{ .x = @floor(x), .y = @floor(y) },
            font_size,
            0,
            colour,
        );
    }
};
