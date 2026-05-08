const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.enemies(
        world,
        {},
        enemyRenderer,
    );
    ecs.Query.rings(
        world,
        {},
        ringRenderer,
    );
}

fn enemyRenderer(
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
        raylib.Color.red,
    );
}

fn ringRenderer(
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
        raylib.Color.yellow,
    );
}
