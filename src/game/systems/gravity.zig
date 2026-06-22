const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;
const collision = @import("../systems/collision.zig");

const GRAVITY = @import("../game.zig").GRAVITY;
const MAX_FALL_SPEED = @import("../game.zig").MAX_FALL_SPEED;

pub fn system(world: *World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        applyPlayerGravity(
            world,
            ent,
            delta,
        );
    }
}

fn applyPlayerGravity(
    world: *World,
    ent: ecs.Entity,
    delta: f32,
) void {
    const vel = world.ecs.velocities.getPtr(ent) orelse return;

    // Player is on the ground
    if (collision.isEntityGrounded(world, ent)) {
        return;
    }

    if (vel.dy > 0.0) {
        vel.dy += GRAVITY * 1.5 * delta; // fall faster than jump
    } else {
        vel.dy += GRAVITY * delta;
    }

    if (vel.dy > MAX_FALL_SPEED) {
        vel.dy = MAX_FALL_SPEED;
    }
}
