const std = @import("std");
const ecs = @import("../../ecs.zig");
const background = @import("../../entities/background.zig");
const platform = @import("../../entities/background.zig");

pub fn system(world: *ecs.World) void {
    var it = world.game.needs_reset.iterator();

    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        if (world.ecs.enemies.contains(ent)) {
            resetPos(world, ent);
        }

        if (world.ecs.rings.contains(ent)) {
            resetPos(world, ent);
        }
    }

    world.game.needs_reset.clearRetainingCapacity();
}

fn resetPos(world: *ecs.World, ent: ecs.Entity) void {
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    pos.x = @as(f32, @floatFromInt(world.game.screen_width + world.game.rng(0, 1000)));
}
