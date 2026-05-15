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

    var text = raylib.textFormat("Credits", .{});
    var font_size: i32 = 48;
    ui.drawCenteredText(
        world,
        text,
        48,
        100,
        raylib.Color.yellow,
    );

    text = raylib.textFormat("Code: Paul Cockrell", .{});
    font_size = 20;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 40,
        raylib.Color.white,
    );

    text = raylib.textFormat("Graphics: Paul Cockrell", .{});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 20,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'space' to return to main menu", .{});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}
