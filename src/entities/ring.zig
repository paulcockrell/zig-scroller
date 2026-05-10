const ecs = @import("../ecs.zig");

const WIDTH: f32 = 16.0;
const HEIGHT: f32 = 16.0;
const FRAME_COUNT: i32 = 1;

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 500)));
    const y = ecs.groundY(world) - HEIGHT;

    try world.rings.put(
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
        .{ .dx = 250.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}
