const ecs = @import("../ecs.zig");
const std = @import("std");
const raylib = @import("raylib");

pub fn system(world: *ecs.World) void {
    const sonic_texture = world.sprites.getEntry(ecs.SpriteTag.player);

    if (sonic_texture) |entry| {
        const texture = entry.value_ptr.*;
        const pos = raylib.Vector2.init(
            @as(f32, @floatFromInt(@divTrunc(world.screen_width, 2))),
            @as(f32, @floatFromInt(@divTrunc(world.screen_height, 2))),
        );
        const frame_rect = raylib.Rectangle.init(
            0,
            0,
            32,
            44,
        );

        raylib.drawTextureRec(texture, frame_rect, pos, .white);
    } else {
        std.debug.print("Failed to load player texture. Not rendering\n", .{});
    }
}
