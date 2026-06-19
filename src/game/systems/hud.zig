const std = @import("std");
const raylib = @import("raylib");
const World = @import("../game.zig").World;

pub fn system(world: *World) void {
    drawScore(world);
    drawSpeed(world);
    drawTime(world);
    drawHealth(world);
}

fn drawScore(world: *World) void {
    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("SCORE: %03i", .{world.game.score}),
        10,
        10,
        16,
        raylib.Color.white,
    );
}

fn drawSpeed(world: *World) void {
    const scroll_speed = @as(i32, @intFromFloat(world.game.scroll_speed));

    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("SPEED: %03i", .{scroll_speed}),
        10,
        30,
        16,
        raylib.Color.white,
    );
}

fn drawTime(world: *World) void {
    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("TIME: %.1fs", .{world.game.time}),
        10,
        50,
        16,
        raylib.Color.white,
    );
}

fn drawHealth(world: *World) void {
    var it = world.ecs.players.iterator();

    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const health = world.ecs.health.get(ent) orelse continue;
        const text_color = switch (health) {
            0...3 => raylib.Color.red,
            4...7 => raylib.Color.orange,
            else => raylib.Color.green,
        };

        world.resources.font_manager.drawTextPixel(
            raylib.textFormat("HEALTH: %03i", .{health}),
            10,
            70,
            16,
            text_color,
        );
    }
}
