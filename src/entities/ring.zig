const ecs = @import("../ecs.zig");

const WIDTH: f32 = 16.0;
const HEIGHT: f32 = 16.0;
const FRAME_COUNT: i32 = 16;

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 500)));
    const y = world.groundY() - HEIGHT;
    const frame_duration: f32 = 1.0 / 12.0;

    try world.rings.put(
        ent,
        {},
    );

    try world.animations.put(
        ent,
        .{
            .animation_timer = 0,
            .frame_duration = frame_duration,
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
        .{ .dx = 2.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
