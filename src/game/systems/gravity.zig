const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

const GRAVITY = @import("../game.zig").GRAVITY;
const MAX_FALL_SPEED = @import("../game.zig").MAX_FALL_SPEED;

pub fn system(world: *World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const vel = world.ecs.velocities.getPtr(ent) orelse continue;

        applyPlayerGravity(
            vel,
            delta,
        );
    }
}

fn applyPlayerGravity(
    vel: *ecs.Velocity,
    delta: f32,
) void {
    if (vel.dy > 0) {
        vel.dy += GRAVITY * 1.5 * delta; // fall faster than jump
    } else {
        vel.dy += GRAVITY * delta;
    }

    if (vel.dy > MAX_FALL_SPEED) {
        vel.dy = MAX_FALL_SPEED;
    }
}
