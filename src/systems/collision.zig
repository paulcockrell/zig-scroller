const std = @import("std");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.players(world, {}, checkEntityCollision);
}

const PlayerCtx = struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
    dy: f32,
    dx: f32,
};

fn checkEntityCollision(
    _: void,
    _: ecs.Entity,
    player_pos: *ecs.Position,
    player_vel: *ecs.Velocity,
    player_dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const ctx = PlayerCtx{
        .x = player_pos.x,
        .y = player_pos.y,
        .w = player_dim.width,
        .h = player_dim.height,
        .dy = player_vel.dy,
        .dx = player_vel.dx,
    };
    ecs.Query.enemies(world, ctx, checkEnemyCollision);
    ecs.Query.rings(world, ctx, checkRingCollision);
}

fn checkEnemyCollision(
    player_ctx: PlayerCtx,
    enemy: ecs.Entity,
    enemy_pos: *ecs.Position,
    _: *ecs.Velocity,
    enemy_dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (stomp(
        player_ctx.x,
        player_ctx.y,
        player_ctx.w,
        player_ctx.h,
        player_ctx.dy,
        enemy_pos.x,
        enemy_pos.y,
        enemy_dim.width,
        enemy_dim.height,
    )) {
        std.debug.print("Enemy stomp!\n", .{});

        // TODO: trigger second 'bounce' of player

        world.needs_reset.put(enemy, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };
    }

    if (overlap(
        player_ctx.x,
        player_ctx.y,
        player_ctx.w,
        player_ctx.h,
        enemy_pos.x,
        enemy_pos.y,
        enemy_dim.width,
        enemy_dim.height,
    )) {
        std.debug.print("Enemy collision!\n", .{});
    }
}

fn checkRingCollision(
    player_ctx: PlayerCtx,
    ring: ecs.Entity,
    ring_pos: *ecs.Position,
    _: *ecs.Velocity,
    ring_dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (overlap(
        player_ctx.x,
        player_ctx.y,
        player_ctx.w,
        player_ctx.h,
        ring_pos.x,
        ring_pos.y,
        ring_dim.width,
        ring_dim.height,
    )) {
        const score = world.updateScore(1);
        std.debug.print("Ring collision! New score {}\n", .{score});

        world.needs_reset.put(ring, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };
    }
}

fn stomp(
    x1: f32,
    y1: f32,
    w1: f32,
    h1: f32,
    dy1: f32,
    x2: f32,
    y2: f32,
    w2: f32,
    h2: f32,
) bool {
    if (dy1 <= 0) return false; // if obj1 is not falling return

    return overlap(
        x1,
        y1,
        w1,
        h1,
        x2,
        y2,
        w2,
        h2,
    );
}

fn overlap(
    x1: f32,
    y1: f32,
    w1: f32,
    h1: f32,
    x2: f32,
    y2: f32,
    w2: f32,
    h2: f32,
) bool {
    return !(x1 + w1 < x2 or
        x1 > x2 + w2 or
        y1 + h1 < y2 or
        y1 > y2 + h2);
}
