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
    _: *ecs.World,
) void {
    raylib.drawRectangle(
        @intFromFloat(pos.x),
        @intFromFloat(pos.y),
        20,
        20,
        raylib.Color.green,
    );
}

fn obstacleRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.World,
) void {
    std.debug.print("drawing obstacle {} {}\n", .{ pos.x, pos.y });
    raylib.drawRectangle(
        @intFromFloat(pos.x),
        @intFromFloat(pos.y),
        20,
        60,
        raylib.Color.red,
    );
}
