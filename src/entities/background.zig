const std = @import("std");
const ecs = @import("../ecs.zig");

pub const DEFAULT_X: f32 = 0.0;
pub const DEFAULT_Y: f32 = -100.0;
const WIDTH: f32 = 1920.0;
const HEIGHT: f32 = 1080.0;
const FRAME_COUNT: i32 = 1;

pub fn spawn(world: *ecs.World) !void {
    try spawnBackground(world, DEFAULT_X, DEFAULT_Y);
    try spawnBackground(world, DEFAULT_X + WIDTH + 1.0, DEFAULT_Y);
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
        .{ .dx = (world.scroll_speed * -1) + 10.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
