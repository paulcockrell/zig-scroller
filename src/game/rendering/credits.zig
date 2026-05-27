const std = @import("std");
const raylib = @import("raylib");
const World = @import("../world.zig").World;

pub fn system(world: *World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *World) void {
    const y_center = @as(f32, @floatFromInt(world.game.screen_height)) / 2;

    var text = raylib.textFormat("CREDITS", .{});
    var font_size: f32 = 24.0;
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 96.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("PROGRAMMING: Paul Cockrell", .{});
    font_size = 16.0;
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 48.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("GRAPHICS: Paul Cockrell", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 24.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("INSPIRATION: jslegenddev.substack.com", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );

    text = raylib.textFormat("Press 'c' to continue", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center + 24,
        raylib.Color.white,
    );
}
