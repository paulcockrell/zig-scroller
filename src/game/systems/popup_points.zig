const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../engine/ecs/ecs.zig");
const World = @import("../world.zig").World;

const OFFSET_Y: f32 = 25.0;
const FONT_SIZE: i32 = 16;

pub fn system(world: *World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;

        displayPopupPoints(
            world,
            pos,
            dim,
            delta,
        );
    }
}

fn displayPopupPoints(
    world: *World,
    pos: *ecs.Position,
    dim: *ecs.Dimension,
    delta: f32,
) void {
    if (world.game.popup_points_timer <= 0.0) {
        world.game.popup_points_timer = 0.0;
        world.game.popup_points = 0;
        return;
    } else {
        world.game.popup_points_timer -= delta;
    }

    const text = raylib.textFormat("+%d", .{world.game.popup_points});
    const text_width = raylib.measureText(text, FONT_SIZE);
    const x = pos.x + (dim.width / 2.0) - (@as(f32, @floatFromInt(text_width)) / 2.0);
    const y = pos.y - OFFSET_Y;

    world.resources.font_manager.drawTextPixel(
        text,
        x,
        y,
        FONT_SIZE,
        raylib.Color.white,
    );
}
