const std = @import("std");
const ecs = @import("../../engine/ecs/ecs.zig");
const World = @import("../world.zig").World;

const GRAVITY = @import("../game.zig").GRAVITY;
const MAX_FALL_SPEED = @import("../game.zig").MAX_FALL_SPEED;

pub fn system(world: *World, delta: f32) void {
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
    world: *World,
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
            vel.dy += GRAVITY * 1.5 * delta; // fall faster than jump
        } else {
            vel.dy += GRAVITY * delta;
        }

        if (vel.dy > MAX_FALL_SPEED) {
            vel.dy = MAX_FALL_SPEED;
        }
    }
}
