const ecs = @import("../ecs.zig");

pub const WIDTH: f32 = 32.0;
pub const HEIGHT: f32 = 44.0;
pub const FRAME_COUNT: i32 = 8;

pub fn spawn(world: *ecs.World) !void {
    const ent = world.createEntity();
    const x = (@as(f32, @floatFromInt(world.screen_width)) / 2.0) - (WIDTH / 2.0);
    const y = world.groundY() - HEIGHT;
    const frame_duration: f32 = 1.0 / 24.0;

    try world.players.put(
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
        .{ .dx = 0.0, .dy = 0.0 },
    );
    try world.dimensions.put(
        ent,
        .{ .width = WIDTH, .height = HEIGHT },
    );
}

pub fn isJumping(world: *ecs.World, ent: ecs.Entity) bool {
    const pos = world.positions.getPtr(ent) orelse return false;
    const dim = world.dimensions.getPtr(ent) orelse return false;
    const jumping = pos.y + dim.height < world.groundY();

    return jumping;
}
