const ecs = @import("../ecs.zig");

const START_POS: f32 = 250.0;
const WIDTH: f32 = 32.0;
const HEIGHT: f32 = 44.0;
const FRAME_COUNT: i32 = 8;

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const y = ecs.groundY(world) - HEIGHT;
    const frame_duration = @as(f32, @floatFromInt(FRAME_COUNT)) / @as(f32, @floatFromInt(ecs.FPS));

    try world.players.put(
        ent,
        {},
    );

    try world.animations.put(
        ent,
        .{
            .animation_timer = 0,
            .frame_duration = frame_duration,
            .current_frame = 0,
            .frame_count = FRAME_COUNT,
        },
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
