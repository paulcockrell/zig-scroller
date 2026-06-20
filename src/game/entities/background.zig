const ecs = @import("../../engine/ecs.zig");
const std = @import("std");
const World = @import("../game.zig").World;

const WIDTH: f32 = 1778.0;
const HEIGHT: f32 = 885.0;
const FRAME_COUNT: i32 = 1;

pub const background_clip = ecs.AnimationClip{
    .row = 0,
    .frame_count = 1,
    .frame_duration = 0.0,
};

pub fn spawn(world: *World) !void {
    const y = (@as(f32, @floatFromInt(world.game.screen_height)) - HEIGHT) / 2.0;

    try spawnBackground(
        world,
        0.0,
        y,
    );
    try spawnBackground(
        world,
        WIDTH,
        y,
    );
}

fn spawnBackground(world: *World, x: f32, y: f32) !void {
    const ent = world.ecs.createEntity();

    try world.ecs.backgrounds.put(
        ent,
        {},
    );
    try world.ecs.animations.put(
        ent,
        .{
            .clip = &background_clip,
            .frame_idx = 0,
            .timer = 0.0,
        },
    );
    try world.ecs.positions.put(
        ent,
        .{ .x = x, .y = y },
    );
    try world.ecs.velocities.put(
        ent,
        .{ .dx = 0.2, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
