const std = @import("std");
const ecs = @import("../ecs.zig");

pub const Platform = struct {};

pub fn spawn(world: *ecs.World) !ecs.Entity {
    const ent = world.createEntity();

    try world.platforms.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = 0, .y = ecs.groundY(world) },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 250.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = 1280.0, .height = 160.0 },
    );

    return ent;
}
