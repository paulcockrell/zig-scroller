const std = @import("std");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) void {
    if (world.game.scroll_speed >= ecs.MAX_SCROLL_SPEED) return;

    world.game.scroll_speed = ecs.BASE_SCROLL_SPEED + (ecs.SCROLL_SPEED_FACTOR * world.game.time);

    if (world.game.scroll_speed > ecs.MAX_SCROLL_SPEED) {
        world.game.scroll_speed = ecs.MAX_SCROLL_SPEED;
    }
}
