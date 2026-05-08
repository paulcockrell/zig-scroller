const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.enemies(
        world,
        delta,
        entityScroll,
    );
    ecs.Query.rings(
        world,
        delta,
        entityScroll,
    );
    ecs.Query.backgrounds(
        world,
        delta,
        entityScroll,
    );
    ecs.Query.platforms(
        world,
        delta,
        entityScroll,
    );
}

fn entityScroll(
    delta: f32,
    _: ecs.Entity,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    pos.x -= (world.scroll_speed + vel.dx) * delta;
}
