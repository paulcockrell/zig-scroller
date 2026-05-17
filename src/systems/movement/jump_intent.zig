const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) void {
    ecs.Query.jumpIntents(world, jump);
    world.jump_intents.clearRetainingCapacity();
}

fn jump(
    vel: *ecs.Velocity,
    intent: *ecs.JumpIntent,
    _: *ecs.World,
) void {
    vel.dy = intent.force;
}
