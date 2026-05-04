const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.players(world, delta, playerMovement);
}

fn playerMovement(
    dt: f32,
    _: ecs.Entity,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    wrld: *ecs.World,
) void {
    pos.y += vel.dy * dt;

    if (pos.y < 100.0) {
        vel.dy = vel.dy * -1;
    }

    if (pos.y >= @as(f32, @floatFromInt(wrld.screen_height)) / 2.0) {
        vel.dy = 0;
        pos.y = @as(f32, @floatFromInt(wrld.screen_height)) / 2.0;
    }
}
