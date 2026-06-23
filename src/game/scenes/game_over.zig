const std = @import("std");
const raylib = @import("raylib");
const World = @import("../game.zig").World;
const Scene = @import("../game.zig").Scene;
const input = @import("../systems/input.zig");
const AudioTag = @import("../../engine/assets/audio_tags.zig").AudioTag;

pub fn enter(world: *World) void {
    _ = world;
}

pub fn exit(world: *World) void {
    world.reset();
}

pub fn update(world: *World, delta: f32) void {
    _ = delta;

    if (world.game.confirm_intent) {
        world.game.next_scene = Scene.main_menu;
    }
}

pub fn render(world: *World, delta: f32) void {
    _ = delta;
    const y_center = @as(f32, @floatFromInt(world.game.screen_height)) / 2.0;

    raylib.clearBackground(raylib.Color.black);

    var text = raylib.textFormat("GAME OVER", .{});
    var font_size: f32 = 24.0;
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 96.0,
        raylib.Color.red,
    );

    text = raylib.textFormat("SCORE: %03i", .{world.game.score});
    font_size = 16.0;
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 48.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("TIME: %.1fs", .{world.game.time});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 24.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("Press 'c' to continue", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}
