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
}

fn entityScroll(
    delta: f32,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    pos.x -= world.scroll_speed * delta;
}
