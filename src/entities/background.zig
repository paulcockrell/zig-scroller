const std = @import("std");
const ecs = @import("../ecs.zig");

const WIDTH: f32 = 578.0;
const HEIGHT: f32 = 320.0;
const FRAME_COUNT: i32 = 1;

pub fn spawn(world: *ecs.World) !void {
    const y = (@as(f32, @floatFromInt(world.screen_height)) - HEIGHT) / 2.0;

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

fn spawnBackground(world: *ecs.World, x: f32, y: f32) !void {
    const ent = world.createEntity();

    try world.backgrounds.put(
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
        .{ .dx = 0.2, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
