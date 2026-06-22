const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

pub fn system(world: *World) void {
    enemiesWrap(world);
    coinsWrap(world);
}

fn enemiesWrap(world: *World) void {
    var it = world.ecs.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        wrap(world, ent);
    }
}

fn coinsWrap(world: *World) void {
    var it = world.ecs.coins.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        wrap(world, ent);
    }
}

fn wrap(world: *World, ent: ecs.Entity) void {
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return;

    if (pos.x + dim.width < 0) {
        world.game.needs_reset.put(ent, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };
    }
}
