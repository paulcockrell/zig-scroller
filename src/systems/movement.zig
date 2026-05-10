const ecs = @import("../ecs.zig");
const std = @import("std");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.players(world, delta, playerMovement);
}

fn playerMovement(
    dt: f32,
    _: ecs.Entity,
    _: *ecs.Animation,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    pos.y += vel.dy * dt;

    if (vel.dy > 0.0) { // falling
        if (pos.y > ecs.groundY(world) - dim.height) { // below ground
            pos.y = ecs.groundY(world) - dim.height;
            vel.dy = 0;
        }
    }
}
