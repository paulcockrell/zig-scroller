const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const resource_system = @import("resources.zig");

const Resources = resource_system.Resources;

pub const TextSystem = struct {
    pixel_font: raylib.Font,

    pub fn init() TextSystem {
        return .{
            .pixel_font = raylib.loadFont("../../../resources/fonts/m6x11.ttf"),
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
        resources: *Resources,
        text: [:0]const u8,
        font_size: i32,
        y: i32,
        colour: raylib.Color,
    ) void {
        const text_width = raylib.measureText(text, font_size);
        const x: i32 = @divFloor(world.screen_width - text_width, 2);

        resources.text.drawTextPixel(
            self,
            text,
            x,
            y,
            font_size,
            colour,
        );
    }
};
