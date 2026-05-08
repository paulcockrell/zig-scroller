const std = @import("std");
const ecs = @import("../ecs.zig");

pub const Background = struct {};

pub fn spawn(world: *ecs.World) !ecs.Entity {
    const ent = world.createEntity();

    try world.backgrounds.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = 0, .y = ecs.groundY(world) },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 100.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = 1920.0, .height = 540.0 },
    );

    return ent;
}
