const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

const WIDTH: f32 = 32.0;
const HEIGHT: f32 = 32.0;
const FRAME_COUNT: i32 = 4;

pub const coin_clip = ecs.AnimationClip{
    .row = 0,
    .frame_count = 4,
    .frame_duration = 0.1,
    .frame_width = WIDTH,
    .frame_height = HEIGHT,
};

pub fn spawn(world: *World) !void {
    const ent = world.ecs.createEntity();
    const x = @as(f32, @floatFromInt(world.game.screen_width + world.game.rng(0, 500)));
    const y = world.game.groundY() - HEIGHT;

    try world.ecs.coins.put(
        ent,
        {},
    );
    try world.ecs.animations.put(
        ent,
        .{
            .clip = &coin_clip,
            .frame_idx = 0,
            .timer = 0.1,
        },
    );
    try world.ecs.positions.put(
        ent,
        .{ .x = @round(x), .y = @round(y) },
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
