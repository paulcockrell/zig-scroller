const ecs = @import("../ecs.zig");

const WIDTH: f32 = 20.0;
const HEIGHT: f32 = 20.0;
const FRAME_COUNT: i32 = 7;

pub fn spawn(world: *ecs.World) !void {
    const ent = world.ecs.createEntity();
    const x = @as(f32, @floatFromInt(world.game.screen_width + world.game.rng(0, 500)));
    const y = world.game.groundY() - HEIGHT;
    const frame_duration: f32 = 1.0 / 14.0;

    try world.ecs.rings.put(
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
        .{ .dx = 2.0, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
