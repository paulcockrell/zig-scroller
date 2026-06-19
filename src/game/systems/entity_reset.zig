const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;
const background = @import("../../game/entities/background.zig");
const platform = @import("../../game/entities/background.zig");

pub fn system(world: *World) void {
    var it = world.game.needs_reset.iterator();

    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        if (world.ecs.enemies.contains(ent)) {
            resetPos(world, ent);
        }

        if (world.ecs.coins.contains(ent)) {
            resetPos(world, ent);
        }
    }

    world.game.needs_reset.clearRetainingCapacity();
}

fn resetPos(world: *World, ent: ecs.Entity) void {
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    pos.x = @as(f32, @floatFromInt(world.game.screen_width + world.game.rng(0, 1000)));
}
