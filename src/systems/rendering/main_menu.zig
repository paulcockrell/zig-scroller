const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const ui = @import("ui.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *ecs.World) void {
    var text = raylib.textFormat("Zig Scroller", .{});
    var y = @divFloor(world.screen_height, 2) - 48;
    ui.drawCenteredText(
        world,
        text,
        48,
        y,
        raylib.Color.green,
    );

    text = raylib.textFormat("press space to start", .{});
    y = @divFloor(world.screen_height, 2) + 24;
    ui.drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.white,
    );

    text = raylib.textFormat("press c for credits", .{});
    y = @divFloor(world.screen_height, 2) + 48;
    ui.drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.yellow,
    );

    text = raylib.textFormat("press esc to exit", .{});
    y = @divFloor(world.screen_height, 2) + 96;
    ui.drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.red,
    );
}
