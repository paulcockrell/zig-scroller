const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) void {
    var it = world.game.jump_intents.iterator();

    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const vel = world.ecs.velocities.getPtr(ent) orelse continue;
        const intent = world.game.jump_intents.getPtr(ent) orelse continue;

        vel.dy = intent.force;
    }

    world.game.jump_intents.clearRetainingCapacity();
}
