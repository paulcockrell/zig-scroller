const std = @import("std");
const ecs = @import("../ecs.zig");

pub const WIDTH: f32 = 1920.0;
pub const HEIGHT: f32 = 540.0;

pub const Background = struct {};

pub fn spawn(world: *ecs.World) !void {
    try spawnBackground(world, 0.0, 0.0);
    try spawnBackground(world, WIDTH + 1.0, 0.0);
}

fn spawnBackground(world: *ecs.World, x: f32, y: f32) !void {
    const ent = world.createEntity();

    try world.backgrounds.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = x, .y = y },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 100.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
