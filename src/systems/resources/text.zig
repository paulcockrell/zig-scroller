const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const resource_system = @import("resources.zig");

const Resources = resource_system.Resources;

pub const TextSystem = struct {
    pixel_font: raylib.Font,

    pub fn init() !TextSystem {
        return .{
            .pixel_font = try raylib.loadFontEx(
                "./resources/fonts/m6x11.ttf",
                16,
                null,
            ),
        };
    }

    pub fn deinit(self: *TextSystem) void {
        raylib.unloadFont(self.pixel_font);
    }

    pub fn drawTextPixel(
        self: *TextSystem,
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
        self: *TextSystem,
        world: *ecs.World,
        text: [:0]const u8,
        font_size: f32,
        y: f32,
        colour: raylib.Color,
    ) void {
        const text_width = raylib.measureText(text, @as(i32, @intFromFloat(font_size)));
        const x = @as(f32, @floatFromInt(world.screen_width - text_width)) / 2.0;

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
