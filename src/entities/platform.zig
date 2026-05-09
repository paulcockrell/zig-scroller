const std = @import("std");
const ecs = @import("../ecs.zig");

pub const WIDTH: f32 = 1280.0;
pub const HEIGHT: f32 = 160.0;

pub const Platform = struct {};

pub fn spawn(world: *ecs.World) !void {
    try spawnPlatform(world, 0, ecs.groundY(world));
    try spawnPlatform(world, WIDTH, ecs.groundY(world));
}

fn spawnPlatform(world: *ecs.World, x: f32, y: f32) !void {
    const ent = world.createEntity();

    try world.platforms.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = x, .y = y },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 250.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
