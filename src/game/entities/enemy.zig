const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

const WIDTH: f32 = 80.0;
const HEIGHT: f32 = 48.0;
const FRAME_COUNT: i32 = 6;
pub const MAX_HEALTH: i32 = 1;

pub const State = enum {
    alive,
    dead,
};

pub fn spawn(world: *World) !void {
    const ent = world.ecs.createEntity();
    const x = @as(f32, @floatFromInt(world.game.screen_width + world.game.rng(0, 1000)));
    const y = world.game.groundY() - HEIGHT;
    const frame_duration: f32 = 1.0 / 6.0;

    try world.ecs.enemies.put(
        ent,
        {},
    );

    try world.ecs.animations.put(
        ent,
        .{
            .animation_timer = 0,
            .frame_duration = frame_duration,
            .frame_idx = 0,
            .frame_count = FRAME_COUNT,
        },
    );
    try world.ecs.positions.put(
        ent,
        .{ .x = x, .y = y },
    );
    try world.ecs.velocities.put(
        ent,
        .{ .dx = 2.5, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
    try world.ecs.health.put(
        ent,
        MAX_HEALTH,
    );
}

pub fn current_state(world: *World, ent: ecs.Entity) State {
    if (isDead(world, ent)) return .dead;

    return .alive;
}

pub fn isDead(world: *World, ent: ecs.Entity) bool {
    const health = world.ecs.health.get(ent) orelse return true;
    return health <= 0;
}
