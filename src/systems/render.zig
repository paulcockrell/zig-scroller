const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.players(world, {}, playerRenderer);
    ecs.Query.obstacles(world, {}, obstacleRenderer);
}

fn playerRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    _: *ecs.World,
) void {
    raylib.drawRectangle(
        @intFromFloat(pos.x),
        @intFromFloat(pos.y),
        @intFromFloat(dim.width),
        @intFromFloat(dim.height),
        raylib.Color.green,
    );
}

fn obstacleRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    _: *ecs.World,
) void {
    std.debug.print("drawing obstacle {} {}\n", .{ pos.x, pos.y });
    raylib.drawRectangle(
        @intFromFloat(pos.x),
        @intFromFloat(pos.y),
        @intFromFloat(dim.width),
        @intFromFloat(dim.height),
        raylib.Color.red,
    );
}
