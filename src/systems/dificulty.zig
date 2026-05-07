const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    world.scroll_speed = ecs.BASE_SCROLL_SPEED + (ecs.SCROLL_SPEED_FACTOR * world.time);
    if (world.scroll_speed > ecs.MAX_SCROLL_SPEED) {
        world.scroll_speed = ecs.MAX_SCROLL_SPEED;
    }
}
