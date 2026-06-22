const ecs = @import("../../engine/ecs.zig");
const std = @import("std");
const World = @import("../game.zig").World;

pub const WIDTH: f32 = 480.0;
pub const HEIGHT: f32 = 45.0;

pub const platform_clip = ecs.AnimationClip{
    .row = 0,
    .frame_count = 1,
    .frame_duration = 0.0,
    .frame_width = WIDTH,
    .frame_height = HEIGHT,
};

pub fn spawn(world: *World) !void {
    try spawnPlatform(world, 0, world.game.groundY());
    try spawnPlatform(world, WIDTH, world.game.groundY());
}

fn spawnPlatform(world: *World, x: f32, y: f32) !void {
    const ent = world.ecs.createEntity();

    try world.ecs.platforms.put(
        ent,
        {},
    );
    try world.ecs.animations.put(
        ent,
        .{
            .clip = &platform_clip,
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
        .{ .dx = 2.0, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
