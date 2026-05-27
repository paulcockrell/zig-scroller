const ecs = @import("../../engine/ecs/ecs.zig");
const World = @import("../world.zig").World;

pub const WIDTH: f32 = 32.0;
pub const HEIGHT: f32 = 44.0;
pub const FRAME_COUNT: i32 = 8;

pub fn spawn(world: *World) !void {
    const ent = world.ecs.createEntity();
    const x = (@as(f32, @floatFromInt(world.game.screen_width)) / 2.0) - (WIDTH / 2.0);
    const y = world.game.groundY() - HEIGHT;
    const frame_duration: f32 = 1.0 / 24.0;

    try world.ecs.players.put(
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
        .{ .dx = 0.0, .dy = 0.0 },
    );
    try world.ecs.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}

pub fn isJumping(world: *World, ent: ecs.Entity) bool {
    const pos = world.ecs.positions.getPtr(ent) orelse return false;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return false;
    const jumping = pos.y + dim.height < world.game.groundY();

    return jumping;
}
