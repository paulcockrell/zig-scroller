const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn drawCenteredText(
    world: *ecs.World,
    text: [:0]const u8,
    font_size: i32,
    y: i32,
    colour: raylib.Color,
) void {
    const text_width = raylib.measureText(text, font_size);
    const x: i32 = @divFloor(world.screen_width - text_width, 2);

    raylib.drawText(
        text,
        x,
        y,
        font_size,
        colour,
    );
}
