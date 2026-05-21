const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;
        const vel = world.ecs.velocities.getPtr(ent) orelse continue;

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
    const is_grounded = pos.y + dim.height >= world.game.groundY() and vel.dy == 0;

    if (is_grounded) {
        vel.dy = 0;
    } else {
        if (vel.dy > 0) {
            vel.dy += ecs.GRAVITY * 1.5 * delta; // fall faster than jump
        } else {
            vel.dy += ecs.GRAVITY * delta;
        }

        if (vel.dy > ecs.MAX_FALL_SPEED) {
            vel.dy = ecs.MAX_FALL_SPEED;
        }
    }
}
