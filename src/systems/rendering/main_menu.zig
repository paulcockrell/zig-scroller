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

    var text = raylib.textFormat("Zero Dash", .{});
    var font_size: i32 = 48;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        100,
        raylib.Color.green,
    );

    text = raylib.textFormat("press 'space' to play", .{});
    font_size = 20;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 40,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'c' for credits", .{});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 20,
        raylib.Color.yellow,
    );

    text = raylib.textFormat("press 'esc' to exit", .{});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.red,
    );
}
