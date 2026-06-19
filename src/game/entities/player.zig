const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

pub const WIDTH: f32 = 24.0;
pub const HEIGHT: f32 = 30.0;
pub const FRAME_COUNT: i32 = 6;
pub const FPS: f32 = 10.0;
pub const MAX_HEALTH: i32 = 10;

pub const State = enum {
    running,
    jumping,
    falling,
    dead,
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
    try world.ecs.health.put(
        ent,
        MAX_HEALTH,
    );
}

pub fn current_state(world: *World, ent: ecs.Entity) State {
    if (isDead(world, ent)) return .dead;
    if (isJumping(world, ent)) return .jumping;
    if (isFalling(world, ent)) return .falling;

    return .running;
}

pub fn isDead(world: *World, ent: ecs.Entity) bool {
    const health = world.ecs.health.get(ent) orelse return true;
    return health <= 0;
}

pub fn isRunning(world: *World, ent: ecs.Entity) bool {
    const pos = world.ecs.positions.get(ent) orelse return false;
    const dim = world.ecs.dimensions.get(ent) orelse return false;
    const running = pos.y + dim.height < world.game.groundY();

    return running;
}

pub fn isJumping(world: *World, ent: ecs.Entity) bool {
    const vel = world.ecs.velocities.get(ent) orelse return false;
    return vel.dy < 0.0;
}

pub fn isFalling(world: *World, ent: ecs.Entity) bool {
    const vel = world.ecs.velocities.get(ent) orelse return false;
    return vel.dy > 0.0;
}
