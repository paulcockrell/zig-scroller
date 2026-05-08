const std = @import("std");
const ecs = @import("../ecs.zig");

pub const Enemy = struct {};

pub fn spawn(world: *ecs.World) !ecs.Entity {
    const ent = world.createEntity();

    try world.enemies.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 1000))), .y = ecs.groundY(world) },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 150.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = 48.0, .height = 30.0 },
    );

    return ent;
}
