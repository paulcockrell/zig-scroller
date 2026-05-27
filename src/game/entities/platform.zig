const std = @import("std");
const ecs = @import("../../engine/ecs/ecs.zig");

const WIDTH: f32 = 504.0;
const FRAME_COUNT: i32 = 1;

pub const PLATFORM_HEIGHT: f32 = 57.0;

pub fn spawn(world: *ecs.World) !void {
    try spawnPlatform(world, 0, world.game.groundY());
    try spawnPlatform(world, WIDTH, world.game.groundY());
}

fn spawnPlatform(world: *ecs.World, x: f32, y: f32) !void {
    const ent = world.ecs.createEntity();

    try world.ecs.platforms.put(
        ent,
        {},
    );

    try world.ecs.animations.put(
        ent,
        .{
            .animation_timer = 0,
            .frame_duration = 0,
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
        .{ .dx = 2.0, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = PLATFORM_HEIGHT },
    );
}
