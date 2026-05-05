const std = @import("std");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.players(world, {}, checkObstacleCollision);
}

const PlayerCtx = struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};

fn checkObstacleCollision(
    _: void,
    _: ecs.Entity,
    player_pos: *ecs.Position,
    _: *ecs.Velocity,
    player_dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const ctx = PlayerCtx{
        .x = player_pos.x,
        .y = player_pos.y,
        .w = player_dim.width,
        .h = player_dim.height,
    };
    ecs.Query.obstacles(world, ctx, checkObstacle);
}

fn checkObstacle(
    player_ctx: PlayerCtx,
    _: ecs.Entity,
    obstacle_pos: *ecs.Position,
    _: *ecs.Velocity,
    obstacle_dim: *ecs.Dimension,
    _: *ecs.World,
) void {
    if (overlap(
        player_ctx.x,
        player_ctx.y,
        player_ctx.w,
        player_ctx.h,
        obstacle_pos.x,
        obstacle_pos.y,
        obstacle_dim.width,
        obstacle_dim.height,
    )) {
        std.debug.print("Collision!\n", .{});
    }
}

fn overlap(x1: f32, y1: f32, w1: f32, h1: f32, x2: f32, y2: f32, w2: f32, h2: f32) bool {
    return !(x1 + w1 < x2 or
        x1 > x2 + w2 or
        y1 + h1 < y2 or
        y1 > y2 + h2);
}
