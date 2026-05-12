const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *ecs.World) void {
    raylib.drawText(
        raylib.textFormat("GAME OVER", .{}),
        @divFloor(world.screen_width, 2) - 80,
        @divFloor(world.screen_height, 2) - 20,
        20,
        raylib.Color.lime,
    );
    raylib.drawText(
        raylib.textFormat("Score:", .{world.score}),
        @divFloor(world.screen_width, 2) - 80,
        @divFloor(world.screen_height, 2) - 0,
        16,
        raylib.Color.white,
    );
    raylib.drawText(
        raylib.textFormat("time:", .{world.time}),
        @divFloor(world.screen_width, 2) - 80,
        @divFloor(world.screen_height, 2) + 20,
        16,
        raylib.Color.white,
    );
}
