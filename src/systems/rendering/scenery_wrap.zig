const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.backgrounds(world, delta, wrapBackgroundTile);
    ecs.Query.platforms(world, delta, wrapPlatformTile);
}

fn wrapBackgroundTile(
    _: f32,
    entity: ecs.Entity,
    _: *ecs.Animation,
    position: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    const rightmost_edge = findRightmostEdge(world, world.backgrounds);

    const tile_dims = world.dimensions.getPtr(entity) orelse return;

    const tile_right_edge = position.x + tile_dims.width;

    if (tile_right_edge <= 0) {
        position.x = rightmost_edge;
    }
}

fn wrapPlatformTile(
    _: f32,
    entity: ecs.Entity,
    _: *ecs.Animation,
    position: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    const rightmost_edge = findRightmostEdge(world, world.platforms);

    const tile_dims = world.dimensions.getPtr(entity) orelse return;

    const tile_right_edge = position.x + tile_dims.width;

    if (tile_right_edge <= 0) {
        position.x = rightmost_edge;
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
