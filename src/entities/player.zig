const ecs = @import("../ecs.zig");

const START_POS: f32 = 250.0;
const WIDTH: f32 = 32.0;
const HEIGHT: f32 = 44.0;

pub const Player = struct {};

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const y = ecs.groundY(world) - HEIGHT;

    try world.players.put(
        ent,
        {},
    );
    try world.positions.put(
        ent,
        .{ .x = START_POS, .y = y },
    );
    try world.velocities.put(
        ent,
        .{ .dx = 0.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
