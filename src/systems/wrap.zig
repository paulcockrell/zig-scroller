const std = @import("std");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.enemies(
        world,
        delta,
        entityWrap,
    );
    ecs.Query.rings(
        world,
        delta,
        entityWrap,
    );
}

fn entityWrap(
    _: f32,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    wrld: *ecs.World,
) void {
    if (pos.x < 0) {
        var prng = std.Random.DefaultPrng.init(std.testing.random_seed);
        const rand = prng.random();
        const offset = rand.intRangeAtMost(u16, 100, 1000);

        pos.x = @as(f32, @floatFromInt(wrld.screen_width + offset));
    }
}
