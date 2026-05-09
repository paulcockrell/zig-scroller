const ecs = @import("../ecs.zig");
const std = @import("std");
const background = @import("../entities/background.zig");
const platform = @import("../entities/background.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.needs_reset(world, entityReset);
    world.needs_reset.clearRetainingCapacity();
}

pub fn entityReset(ent: ecs.Entity, world: *ecs.World) void {
    if (world.enemies.contains(ent)) {
        resetPos(world, ent);
    }

    if (world.rings.contains(ent)) {
        resetPos(world, ent);
    }
}

fn resetPos(world: *ecs.World, ent: ecs.Entity) void {
    const pos = world.positions.getPtr(ent) orelse return;
    pos.x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 1000)));
}
