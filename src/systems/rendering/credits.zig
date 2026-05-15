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

    var text = raylib.textFormat("CREDITS", .{});
    var font_size: i32 = 24;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 96,
        raylib.Color.white,
    );

    text = raylib.textFormat("PROGRAMMING: Paul Cockrell", .{});
    font_size = 16;
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 48,
        raylib.Color.white,
    );

    text = raylib.textFormat("GRAPHICS: Paul Cockrell", .{world.time});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center - 24,
        raylib.Color.white,
    );

    text = raylib.textFormat("INSPIRATION: jslegenddev.substack.com", .{world.time});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );

    text = raylib.textFormat("Press 'space' to restart", .{});
    ui.drawCenteredText(
        world,
        text,
        font_size,
        y_center + 24,
        raylib.Color.white,
    );
}
