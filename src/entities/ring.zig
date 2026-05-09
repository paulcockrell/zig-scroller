const ecs = @import("../ecs.zig");

const WIDTH: f32 = 16.0;
const HEIGHT: f32 = 16.0;

pub const Ring = struct {};

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 500)));
    const y = ecs.groundY(world) - HEIGHT;

    try world.rings.put(
        ent,
        {},
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
