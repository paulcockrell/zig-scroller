const ecs = @import("../ecs.zig");
const std = @import("std");
const raylib = @import("raylib");

pub fn system(world: *ecs.World) void {
    const sonic_texture = world.sprites.getEntry(ecs.SpriteTag.player);

    if (sonic_texture) |entry| {
        const texture = entry.value_ptr.*;

        raylib.drawTexture(
            texture,
            @divTrunc(world.screen_width, 2) - @divTrunc(texture.width, 2),
            @divTrunc(world.screen_height, 2) - @divTrunc(texture.height, 2),
            raylib.Color.white,
        );
    } else {
        std.debug.print("Failed to load player texture. Not rendering\n", .{});
    }
}
