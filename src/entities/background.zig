const std = @import("std");
const ecs = @import("../ecs.zig");

const WIDTH: f32 = 1920.0;
const HEIGHT: f32 = 540.0;
const FRAME_COUNT: i32 = 1;

pub fn spawn(world: *ecs.World) !void {
    try spawnBackground(world, 0.0, 0.0);
    try spawnBackground(world, WIDTH + 1.0, 0.0);
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
            .current_frame = 0,
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
