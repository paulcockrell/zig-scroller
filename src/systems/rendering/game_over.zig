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
    var font_size: i32 = 48;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 200,
        raylib.Color.red,
    );

    text = raylib.textFormat("SCORE: %d", .{world.score});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 120,
        raylib.Color.yellow,
    );

    text = raylib.textFormat("Time: %.1fs", .{world.time});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 60,
        raylib.Color.yellow,
    );

    text = raylib.textFormat("Press 'space' to return to main menu", .{});
    font_size = 20;

    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}
