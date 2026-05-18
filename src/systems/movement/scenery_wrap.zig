const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) void {
    backgroundsWrap(world);
    platformsWrap(world);
}

fn backgroundsWrap(world: *ecs.World) void {
    const rightmost_edge = findRightmostEdge(world, world.backgrounds);

    var it = world.backgrounds.iterator();
    while (it.next()) |ent| {
        wrap(
            world,
            ent,
            rightmost_edge,
        );
    }
}

fn platformsWrap(world: *ecs.World) void {
    const rightmost_edge = findRightmostEdge(world, world.platforms);

    var it = world.platforms.iterator();
    while (it.next()) |ent| {
        wrap(
            world,
            ent,
            rightmost_edge,
        );
    }
}

fn wrap(world: *ecs.World, ent: ecs.Entity, rightmost_edge: f32) void {
    var pos = world.positions.getPtr(ent) orelse return;
    const tile_dims = world.dimensions.getPtr(ent) orelse return;
    const tile_right_edge = pos.x + tile_dims.width;

    if (tile_right_edge <= 0) {
        pos.x = rightmost_edge;
    }
}

fn findRightmostEdge(world: *ecs.World, collection: anytype) f32 {
    var max_right_edge: f32 = -std.math.inf(f32);

    var it = collection.iterator();
    while (it.next()) |entry| {
        const entity = entry.key_ptr.*;

        const pos = world.positions.getPtr(entity) orelse continue;
        const dims = world.dimensions.getPtr(entity) orelse continue;

        const right_edge = pos.x + dims.width;

        if (right_edge > max_right_edge) {
            max_right_edge = right_edge;
        }
    }

    return max_right_edge;
}
