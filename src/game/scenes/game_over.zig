const std = @import("std");
const raylib = @import("raylib");
const World = @import("../world.zig").World;
const Scene = @import("../world.zig").Scene;
const input = @import("../systems/input.zig");
const game_over = @import("../rendering/game_over.zig");
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
        world.game.changeScene(Scene.main_menu) catch |err| {
            std.debug.print("Failed to change scene: Game Over -> Main Menu: {}\n", .{err});
        };
    }
}

pub fn render(world: *World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    game_over.system(world, delta);
}
