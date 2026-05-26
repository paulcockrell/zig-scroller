const std = @import("std");
const ecs = @import("../../engine/ecs/ecs.zig");
const MAX_SCROLL_SPEED = @import("../../shared/constants.zig").MAX_SCROLL_SPEED;
const BASE_SCROLL_SPEED = @import("../../shared/constants.zig").BASE_SCROLL_SPEED;
const SCROLL_SPEED_FACTOR = @import("../../shared/constants.zig").SCROLL_SPEED_FACTOR;

pub fn system(world: *ecs.World) void {
    if (world.game.scroll_speed >= MAX_SCROLL_SPEED) return;

    world.game.scroll_speed = BASE_SCROLL_SPEED + SCROLL_SPEED_FACTOR * std.math.pow(f32, world.game.time, 1.5);

    if (world.game.scroll_speed > MAX_SCROLL_SPEED) {
        world.game.scroll_speed = MAX_SCROLL_SPEED;
    }
}
