const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;
const MAX_SCROLL_SPEED = @import("../game.zig").MAX_SCROLL_SPEED;
const BASE_SCROLL_SPEED = @import("../game.zig").BASE_SCROLL_SPEED;
const SCROLL_SPEED_FACTOR = @import("../game.zig").SCROLL_SPEED_FACTOR;

pub fn system(world: *World) void {
    if (world.game.scroll_speed >= MAX_SCROLL_SPEED) return;

    world.game.scroll_speed = BASE_SCROLL_SPEED + SCROLL_SPEED_FACTOR * std.math.pow(f32, world.game.time, 1.5);

    if (world.game.scroll_speed > MAX_SCROLL_SPEED) {
        world.game.scroll_speed = MAX_SCROLL_SPEED;
    }
}
