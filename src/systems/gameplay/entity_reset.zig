const std = @import("std");
const ecs = @import("../../ecs.zig");
const background = @import("../../entities/background.zig");
const platform = @import("../../entities/background.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.needsReset(world, entityReset);
    world.needs_reset.clearRetainingCapacity();
}

pub fn entityReset(ent: ecs.Entity, world: *ecs.World) void {
    if (world.enemies.contains(ent)) {
        resetPos(world, ent);
        return;
    }

    if (world.rings.contains(ent)) {
        resetPos(world, ent);
    }
}

fn resetPos(world: *ecs.World, ent: ecs.Entity) void {
    const pos = world.positions.getPtr(ent) orelse return;
    pos.x = @as(f32, @floatFromInt(world.screen_width + world.rng(0, 1000)));
}
