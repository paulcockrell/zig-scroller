const ecs = @import("../ecs.zig");
const std = @import("std");

pub fn system(world: *ecs.World) void {
    ecs.Query.needs_reset(world, resetEntity);
    world.needs_reset.clearRetainingCapacity();
}

pub fn resetEntity(ent: ecs.Entity, world: *ecs.World) void {
    if (world.enemies.contains(ent)) {
        resetPos(world, ent);
    }

    if (world.rings.contains(ent)) {
        resetPos(world, ent);
    }
}

// Use the same reset x position func for now
fn resetPos(world: *ecs.World, ent: ecs.Entity) void {
    const pos = world.positions.getPtr(ent) orelse return;

    var prng = std.Random.DefaultPrng.init(std.testing.random_seed);
    const rand = prng.random();
    const offset = rand.intRangeAtMost(u16, 100, 1000);

    pos.x = @as(f32, @floatFromInt(world.screen_width + offset));
}
