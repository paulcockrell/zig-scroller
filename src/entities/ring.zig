const ecs = @import("../ecs.zig");

pub const Ring = struct {};

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();

    try world.rings.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = @as(f32, @floatFromInt(world.screen_width + 150)), .y = ecs.groundY(world) },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 140.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = 16.0, .height = 16.0 },
    );
}
