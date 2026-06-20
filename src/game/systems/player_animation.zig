const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../engine/ecs.zig");
const player = @import("../entities/player.zig");
const World = @import("../game.zig").World;
const AnimationState = @import("../entities/player.zig").AnimationState;

pub fn system(world: *World) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        updateAnimation(
            world,
            ent,
        );
    }
}

fn updateAnimation(world: *World, ent: ecs.Entity) void {
    const anim_state = determineAnimationState(world, ent);
    const anim = world.ecs.animations.getPtr(ent) orelse return;

    switch (anim_state) {
        .idle => setClip(anim, &player.idle_clip),
        .running => setClip(anim, &player.running_clip),
        .jumping => setClip(anim, &player.jumping_clip),
        .falling => setClip(anim, &player.falling_clip),
        .hit => setClip(anim, &player.hit_clip),
        .dead => setClip(anim, &player.dead_clip),
    }
}

fn determineAnimationState(world: *World, ent: ecs.Entity) AnimationState {
    const grounded = player.isGrounded(world, ent);
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
