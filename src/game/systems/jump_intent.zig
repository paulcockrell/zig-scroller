const std = @import("std");
const World = @import("../game.zig").World;

pub fn system(world: *World) void {
    var it = world.game.jump_intents.iterator();

    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const vel = world.ecs.velocities.getPtr(ent) orelse continue;
        const intent = world.game.jump_intents.getPtr(ent) orelse continue;

        vel.dy = intent.force;
    }

    world.game.jump_intents.clearRetainingCapacity();
}
