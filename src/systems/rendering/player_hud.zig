const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

const OFFSET_Y: f32 = 25.0;
const FONT_SIZE: i32 = 16;

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.players(
        world,
        delta,
        displayPlayerHud,
    );
}

fn displayPlayerHud(
    delta: f32,
    _: ecs.Entity,
    _: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (world.player_hud_timer <= 0.0) {
        world.player_hud_timer = 0;
        world.player_hud_score = 0;
        return;
    }

    world.player_hud_timer -= delta;

    const text = raylib.textFormat("+%d", .{world.player_hud_score});
    const text_width = raylib.measureText(text, FONT_SIZE);
    const x = @as(i32, @intFromFloat(pos.x + (dim.width / 2.0))) - @divFloor(text_width, 2);
    const y = @as(i32, @intFromFloat(pos.y - OFFSET_Y));

    std.debug.print("Player pos: x={}, y={}\n", .{ pos.x, pos.y });
    std.debug.print("Drawing player hud: timer={}, x={}, y={}\n", .{ world.player_hud_timer, x, y });

    raylib.drawText(
        text,
        x,
        y,
        FONT_SIZE,
        raylib.Color.white,
    );
}
