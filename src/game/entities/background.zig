const std = @import("std");
const World = @import("../world.zig").World;

const WIDTH: f32 = 578.0;
const HEIGHT: f32 = 320.0;
const FRAME_COUNT: i32 = 1;

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
        .{ .dx = 0.2, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
