const std = @import("std");
const ecs = @import("../ecs.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn system(world: *ecs.World) void {
    ecs.Query.players(world, {}, checkEntityCollision);
}

const PlayerCtx = struct {
    ent: ecs.Entity,
    x: f32,
    y: f32,
    w: f32,
    h: f32,
    dy: f32,
    dx: f32,
};

fn checkEntityCollision(
    _: void,
    ent: ecs.Entity,
    _: *ecs.Animation,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const ctx = PlayerCtx{
        .ent = ent,
        .x = pos.x,
        .y = pos.y,
        .w = dim.width,
        .h = dim.height,
        .dy = vel.dy,
        .dx = vel.dx,
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

        world.jump_intents.put(player_ctx.ent, .{ .force = JUMP_FORCE }) catch |err| {
            std.debug.print("Entity jump intent failed {}\n", .{err});
        };

        world.needs_reset.put(enemy, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };

        return;
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
        _ = world.updateHealth(1);

        world.needs_reset.put(enemy, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };
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
        _ = world.updateScore(1);

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
