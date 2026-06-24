const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

const WIDTH: f32 = 80.0;
const HEIGHT: f32 = 48.0;
pub const MAX_HEALTH: i32 = 1;

pub const running_clip = ecs.AnimationClip{
    .row = 0,
    .frame_count = 4,
    .frame_duration = 0.1,
    .frame_width = WIDTH,
    .frame_height = HEIGHT,
};

pub const dead_clip = ecs.AnimationClip{
    .row = 1,
    .frame_count = 4,
    .frame_duration = 0.1,
};

pub fn spawn(world: *World) !void {
    const ent = world.ecs.createEntity();
    const x = if (world.ecs.enemies.count() == 0)
        (@as(f32, @floatFromInt(world.game.screen_width)) * 2.0 / 3.0) - (WIDTH / 2.0)
    else
        @as(f32, @floatFromInt(world.game.screen_width + world.game.rng(0, 1000)));

    const y = world.game.groundY() - HEIGHT;

    try world.ecs.enemies.put(
        ent,
        {},
    );
    try world.ecs.animations.put(
        ent,
        .{
            .clip = &running_clip,
            .frame_idx = 0,
            .timer = 0.0,
        },
    );
    try world.ecs.positions.put(
        ent,
        .{ .x = @round(x), .y = @round(y) },
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
