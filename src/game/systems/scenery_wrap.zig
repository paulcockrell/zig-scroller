const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../world.zig").World;

pub fn system(world: *World) void {
    backgroundsWrap(world);
    platformsWrap(world);
}

fn backgroundsWrap(world: *World) void {
    const rightmost_edge = findRightmostEdge(world, world.ecs.backgrounds);

    var it = world.ecs.backgrounds.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        wrap(
            world,
            ent,
            rightmost_edge,
        );
    }
}

fn platformsWrap(world: *World) void {
    const rightmost_edge = findRightmostEdge(world, world.ecs.platforms);

    var it = world.ecs.platforms.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        wrap(
            world,
            ent,
            rightmost_edge,
        );
    }
}

fn wrap(world: *World, ent: ecs.Entity, rightmost_edge: f32) void {
    var pos = world.ecs.positions.getPtr(ent) orelse return;
    const tile_dims = world.ecs.dimensions.getPtr(ent) orelse return;
    const tile_right_edge = pos.x + tile_dims.width;

    if (tile_right_edge <= 0) {
        pos.x = rightmost_edge;
    }
}

fn findRightmostEdge(world: *World, collection: anytype) f32 {
    var max_right_edge: f32 = -std.math.inf(f32);

    var it = collection.iterator();
    while (it.next()) |entry| {
        const entity = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(entity) orelse continue;
        const dims = world.ecs.dimensions.getPtr(entity) orelse continue;
        const right_edge = pos.x + dims.width;

        if (right_edge > max_right_edge) {
            max_right_edge = right_edge;
        }
    }

    return max_right_edge;
}
