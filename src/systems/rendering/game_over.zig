const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *ecs.World) void {
    const y_center = @as(f32, @floatFromInt(world.game.screen_height)) / 2.0;

    var text = raylib.textFormat("GAME OVER", .{});
    var font_size: f32 = 24.0;
    world.resources.font_manager.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 96.0,
        raylib.Color.red,
    );

    text = raylib.textFormat("SCORE: %03i", .{world.game.score});
    font_size = 16.0;
    world.resources.font_manager.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 48.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("TIME: %.1fs", .{world.game.time});
    world.resources.font_manager.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 24.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("Press 'c' to continue", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}
