const std = @import("std");
const raylib = @import("raylib");
const World = @import("../world.zig").World;
const Scene = @import("../world.zig").Scene;
const input = @import("../systems/input.zig");
const credits = @import("../../game/rendering/credits.zig");
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
    raylib.clearBackground(raylib.Color.black);
    credits.system(world, delta);
}
