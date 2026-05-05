const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.obstacles(
        world,
        delta,
        obstacleWrap,
    );
}

fn obstacleWrap(
    _: f32,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    wrld: *ecs.World,
) void {
    if (pos.x < 0) {
        pos.x = @as(f32, @floatFromInt(wrld.screen_width)) + 100.0;
    }
}
