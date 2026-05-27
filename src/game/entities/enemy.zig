const std = @import("std");
const World = @import("../world.zig").World;

const WIDTH: f32 = 48.0;
const HEIGHT: f32 = 30.0;
const FRAME_COUNT: i32 = 5;

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
}
