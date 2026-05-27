const std = @import("std");
const raylib = @import("raylib");
const World = @import("../world.zig").World;
const Scene = @import("../world.zig").Scene;
const input = @import("../systems/input.zig");
const Resources = @import("../../engine/assets/resources.zig").Resources;

pub fn enter(world: *World) void {
    _ = world;
}

pub fn exit(world: *World) void {
    _ = world;
}

pub fn update(world: *World, delta: f32) void {
    _ = delta;

    if (world.game.confirm_intent) {
        world.game.changeScene(Scene.main_menu) catch |err| {
            std.debug.print("Failed to change scene: Credits -> Main Menu: {}\n", .{err});
        };
    }
}

pub fn render(world: *World, delta: f32) void {
    _ = delta;
    const y_center = @as(f32, @floatFromInt(world.game.screen_height)) / 2;

    raylib.clearBackground(raylib.Color.black);

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
