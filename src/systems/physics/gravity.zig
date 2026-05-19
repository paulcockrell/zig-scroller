const std = @import("std");
const ecs = @import("../../ecs.zig");

const GRAVITY: f32 = 500.0;
const MAX_FALL_SPEED: f32 = 400.0;

pub fn system(world: *ecs.World, delta: f32) void {
    var it = world.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.positions.getPtr(ent) orelse continue;
        const dim = world.dimensions.getPtr(ent) orelse continue;
        const vel = world.velocities.getPtr(ent) orelse continue;

        applyPlayerGravity(
            world,
            pos,
            vel,
            dim,
            delta,
        );
    }
}

fn applyPlayerGravity(
    world: *ecs.World,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    delta: f32,
) void {
    const is_grounded = pos.y + dim.height >= world.groundY() and vel.dy == 0;

    if (is_grounded) {
        vel.dy = 0;
    } else {
        if (vel.dy > 0) {
            vel.dy += GRAVITY * 1.5 * delta; // fall faster than jump
        } else {
            vel.dy += GRAVITY * delta;
        }

        if (vel.dy > MAX_FALL_SPEED) {
            vel.dy = MAX_FALL_SPEED;
        }
    }
}
