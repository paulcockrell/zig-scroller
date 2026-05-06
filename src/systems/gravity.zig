const ecs = @import("../ecs.zig");
const std = @import("std");

const GRAVITY: f32 = 500.0;
const MAX_FALL_SPEED: f32 = 400.0;

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.players(world, delta, applyGravity);
}

fn applyGravity(
    delta: f32,
    _: ecs.Entity,
    _: *ecs.Position,
    vel: *ecs.Velocity,
    _: *ecs.Dimension,
    _: *ecs.World,
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
