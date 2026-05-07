const std = @import("std");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.enemies(
        world,
        delta,
        entityWrap,
    );
    ecs.Query.rings(
        world,
        delta,
        entityWrap,
    );
}

fn entityWrap(
    _: f32,
    entity: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (pos.x < 0) {
        world.needs_reset.put(entity, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };
    }
}
