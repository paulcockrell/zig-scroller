const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) void {
    enemiesWrap(world);
    ringsWrap(world);
}

fn enemiesWrap(world: *ecs.World) void {
    var it = world.enemies.iterator();
    while (it.next()) |ent| {
        wrap(world, ent);
    }
}

fn ringsWrap(world: *ecs.World) void {
    var it = world.rings.iterator();
    while (it.next()) |ent| {
        wrap(world, ent);
    }
}

fn wrap(world: *ecs.World, ent: ecs.Entity) void {
    const pos = world.positions.getPtr(ent) orelse return;
    const dim = world.dimensions.getPtr(ent) orelse return;

    if (pos.x + dim.width < 0) {
        world.needs_reset.put(ent, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };
    }
}
