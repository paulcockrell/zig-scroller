const std = @import("std");
const ecs = @import("../ecs.zig");

const WIDTH: f32 = 48.0;
const HEIGHT: f32 = 30.0;
const DX: f32 = 150.0;

pub const Enemy = struct {};

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 1000)));
    const y = ecs.groundY(world) - HEIGHT;

    try world.enemies.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = x, .y = y },
    );
    try world.velocities.put(
        ent,
        .{ .dx = DX, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
