const ecs = @import("../ecs.zig");

pub const Player = struct {};

pub fn spawn(world: *ecs.World) !ecs.Entity {
    const ent = world.createEntity();

    try world.players.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = 100.0, .y = @as(f32, @floatFromInt(world.screen_height)) / 2.0 },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 0.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = 100.0, .height = 100.0 },
    );

    return ent;
}
