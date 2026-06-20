const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

pub const WIDTH: f32 = 55.0;
pub const HEIGHT: f32 = 64.0;
pub const MAX_HEALTH: i32 = 10;

pub const AnimationState = enum {
    idle, // only used in main menu scene
    running,
    jumping,
    falling,
    hit,
    dead,
};

pub const idle_clip = ecs.AnimationClip{
    .row = 4,
    .frame_count = 4,
    .frame_duration = 0.1,
};

pub const running_clip = ecs.AnimationClip{
    .row = 0,
    .frame_count = 6,
    .frame_duration = 0.1,
};

pub const jumping_clip = ecs.AnimationClip{
    .row = 1,
    .frame_count = 1,
    .frame_duration = 0.1,
};

pub const falling_clip = ecs.AnimationClip{
    .row = 2,
    .frame_count = 1,
    .frame_duration = 0.1,
};

pub const hit_clip = ecs.AnimationClip{
    .row = 3,
    .frame_count = 1,
    .frame_duration = 0.1,
};

pub const dead_clip = ecs.AnimationClip{
    .row = 4,
    .frame_count = 1,
    .frame_duration = 0.1,
};

pub fn spawn(world: *World) !void {
    const ent = world.ecs.createEntity();
    const x = (@as(f32, @floatFromInt(world.game.screen_width)) / 2.0) - (WIDTH / 2.0);
    const y = world.game.groundY() - HEIGHT;

    try world.ecs.players.put(
        ent,
        {},
    );
    try world.ecs.animations.put(
        ent,
        .{
            .clip = &idle_clip,
            .frame_idx = 0,
            .timer = 0.0,
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

pub fn update(world: *World, ent: ecs.Entity) void {
    const anim_state = determineAnimationState(world, ent);
    const anim = world.ecs.animations.getPtr(ent) orelse return;

    switch (anim_state) {
        .idle => setClip(anim, &idle_clip),
        .running => setClip(anim, &running_clip),
        .jumping => setClip(anim, &jumping_clip),
        .falling => setClip(anim, &falling_clip),
        .hit => setClip(anim, &hit_clip),
        .dead => setClip(anim, &dead_clip),
    }
}

pub fn isGrounded(world: *World, ent: ecs.Entity) bool {
    const pos = world.ecs.positions.getPtr(ent) orelse return true;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return true;
    const vel = world.ecs.velocities.getPtr(ent) orelse return true;

    return pos.y + dim.height >= world.game.groundY() and vel.dy == 0;
}

pub fn determineAnimationState(world: *World, ent: ecs.Entity) AnimationState {
    const grounded = isGrounded(world, ent);
    const vel = world.ecs.velocities.getPtr(ent) orelse return .idle;
    const health = world.ecs.health.getPtr(ent) orelse return .idle;

    if (health.* <= 0) return .dead;
    if (!grounded and vel.dy < 0) return .jumping;
    if (!grounded and vel.dy > 0) return .falling;

    return .running;
}

fn setClip(anim: *ecs.Animation, clip: *const ecs.AnimationClip) void {
    if (anim.clip == clip) return;

    anim.clip = clip;
    anim.frame_idx = 0;
    anim.timer = 0.0;
}
