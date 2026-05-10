const ecs = @import("../ecs.zig");
const std = @import("std");

pub fn system(world: *ecs.World) void {
    ecs.Query.jump_intent(world, jump);
    world.jump_intents.clearRetainingCapacity();
}

fn jump(
    vel: *ecs.Velocity,
    intent: *ecs.JumpIntent,
    _: *ecs.World,
) void {
    vel.dy = intent.force;
}
