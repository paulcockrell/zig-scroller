const ecs = @import("../ecs.zig");

pub const Ring = struct {};

pub fn spawn(world: *ecs.World) !ecs.Entity {
    const ent = world.createEntity();

    try world.rings.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = @as(f32, @floatFromInt(world.screen_width + 150)), .y = @as(f32, @floatFromInt(world.screen_height)) / 2.0 },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 140.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = 25.0, .height = 25.0 },
    );

    return ent;
}
