const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const input = @import("../systems/input/keyboard.zig");
const game_over = @import("../systems/rendering/game_over.zig");
const Resources = @import("../resources/resources.zig").Resources;

pub fn enter(world: *ecs.World) void {
    _ = world;
}

pub fn exit(world: *ecs.World) void {
    world.reset();
}

pub fn update(world: *ecs.World, delta: f32) void {
    _ = delta;

    if (world.confirm_intent) {
        world.changeScene(ecs.Scene.main_menu) catch |err| {
            std.debug.print("Failed to change scene: Game Over -> Main Menu: {}\n", .{err});
        };
    }
}

pub fn render(world: *ecs.World, resources: *Resources, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    game_over.system(world, resources, delta);
}
