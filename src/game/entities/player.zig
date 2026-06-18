const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

pub const WIDTH: f32 = 24.0;
pub const HEIGHT: f32 = 30.0;
pub const FRAME_COUNT: i32 = 6;
pub const FPS: f32 = 10.0;
pub const PlayerState = enum {
    running,
    jumping,
    falling,
};

pub fn spawn(world: *World) !void {
    const ent = world.ecs.createEntity();
    const x = (@as(f32, @floatFromInt(world.game.screen_width)) / 2.0) - (WIDTH / 2.0);
    const y = world.game.groundY() - HEIGHT;
    const frame_duration: f32 = 1.0 / FPS;

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

pub fn state(world: *World, ent: ecs.Entity) PlayerState {
    if (isJumping(world, ent)) return .jumping;
    if (isFalling(world, ent)) return .falling;

    return .running;
}

fn isRunning(world: *World, ent: ecs.Entity) bool {
    const pos = world.ecs.positions.getPtr(ent) orelse return false;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return false;
    const running = pos.y + dim.height < world.game.groundY();

    return running;
}

fn isJumping(world: *World, ent: ecs.Entity) bool {
    const vel = world.ecs.velocities.getPtr(ent) orelse return false;
    return vel.dy < 0.0;
}

fn isFalling(world: *World, ent: ecs.Entity) bool {
    const vel = world.ecs.velocities.getPtr(ent) orelse return false;
    return vel.dy > 0.0;
}
