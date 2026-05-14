const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const ui = @import("ui.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *ecs.World) void {
    var text = raylib.textFormat("Game Over", .{});
    var y = @divFloor(world.screen_height, 2) - 48;
    ui.drawCenteredText(
        world,
        text,
        48,
        y,
        raylib.Color.red,
    );

    text = raylib.textFormat("score: %d", .{world.score});
    y = @divFloor(world.screen_height, 2) + 24;
    ui.drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.white,
    );

    text = raylib.textFormat("time: %.1fs", .{world.time});
    y = @divFloor(world.screen_height, 2) + 48;
    ui.drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'q' to return to main menu", .{});
    y = @divFloor(world.screen_height, 2) + 96;
    ui.drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.yellow,
    );
}
