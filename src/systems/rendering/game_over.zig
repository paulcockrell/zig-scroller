const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const ui = @import("ui.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *ecs.World) void {
    const y_center = @divFloor(world.screen_height, 2);

    var text = raylib.textFormat("GAME OVER", .{});
    var font_size: i32 = 24;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 96,
        raylib.Color.red,
    );

    text = raylib.textFormat("SCORE: %03i", .{world.score});
    font_size = 16;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 48,
        raylib.Color.white,
    );

    text = raylib.textFormat("TIME: %.1fs", .{world.time});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 24,
        raylib.Color.white,
    );

    text = raylib.textFormat("Press 'c' to continue", .{});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}
