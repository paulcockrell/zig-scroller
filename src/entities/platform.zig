const std = @import("std");
const ecs = @import("../ecs.zig");

const WIDTH: f32 = 1280.0;
const HEIGHT: f32 = 66.0;
const FRAME_COUNT: i32 = 1;

pub fn spawn(world: *ecs.World) !void {
    try spawnPlatform(world, 0, ecs.groundY(world));
    try spawnPlatform(world, WIDTH, ecs.groundY(world));
}

fn spawnPlatform(world: *ecs.World, x: f32, y: f32) !void {
    const ent = world.createEntity();

    try world.platforms.put(
        ent,
        {},
    );

    try world.animations.put(
        ent,
        .{
            .animation_timer = 0,
            .frame_duration = 0,
            .frame_idx = 0,
            .frame_count = FRAME_COUNT,
        },
    );
    try world.positions.put(
        ent,
        .{ .x = x, .y = y },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 250.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
