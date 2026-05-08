const ecs = @import("../ecs.zig");
const std = @import("std");
const raylib = @import("raylib");

pub fn system(world: *ecs.World) void {
    ecs.Query.players(
        world,
        {},
        playerRenderer,
    );
}

fn playerRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const sonic_texture = world.sprites.getEntry(ecs.SpriteTag.player);

    if (sonic_texture) |entry| {
        const texture = entry.value_ptr.*;
        const rl_rect = raylib.Rectangle.init(
            0.0,
            0.0,
            dim.width,
            dim.height,
        );
        const rl_pos = raylib.Vector2.init(
            pos.x,
            pos.y,
        );

        raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
    } else {
        std.debug.print("Failed to load player texture. Not rendering\n", .{});
    }
}
