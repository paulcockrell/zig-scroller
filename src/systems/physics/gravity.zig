const std = @import("std");
const ecs = @import("../../ecs.zig");

const GRAVITY: f32 = 500.0;
const MAX_FALL_SPEED: f32 = 400.0;

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.players(world, delta, applyPlayerGravity);
}

fn applyPlayerGravity(
    delta: f32,
    _: ecs.Entity,
    _: *ecs.Animation,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const is_grounded = pos.y + dim.height >= ecs.groundY(world) and vel.dy == 0;

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
