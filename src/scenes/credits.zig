const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const input = @import("../systems/input/keyboard.zig");
const credits = @import("../systems/rendering/credits.zig");
const Resources = @import("../resources/resources.zig").Resources;

pub fn enter(world: *ecs.World) void {
    _ = world;
}

pub fn exit(world: *ecs.World) void {
    _ = world;
}

pub fn update(world: *ecs.World, delta: f32) void {
    _ = delta;

    if (world.game.confirm_intent) {
        world.game.changeScene(ecs.Scene.main_menu) catch |err| {
            std.debug.print("Failed to change scene: Credits -> Main Menu: {}\n", .{err});
        };
    }
}

pub fn render(world: *ecs.World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    credits.system(world, delta);
}
