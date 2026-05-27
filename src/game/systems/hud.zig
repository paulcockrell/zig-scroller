const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../engine/ecs/ecs.zig");

pub fn system(world: *ecs.World) void {
    drawScore(world);
    drawSpeed(world);
    drawTime(world);
    drawHealth(world);
}

fn drawScore(world: *ecs.World) void {
    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("SCORE: %03i", .{world.game.score}),
        10,
        10,
        16,
        raylib.Color.white,
    );
}

fn drawSpeed(world: *ecs.World) void {
    const scroll_speed = @as(i32, @intFromFloat(world.game.scroll_speed));

    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("SPEED: %03i", .{scroll_speed}),
        10,
        30,
        16,
        raylib.Color.white,
    );
}

fn drawTime(world: *ecs.World) void {
    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("TIME: %.1fs", .{world.game.time}),
        10,
        50,
        16,
        raylib.Color.white,
    );
}

fn drawHealth(world: *ecs.World) void {
    var text_color = raylib.Color.white;
    text_color = switch (world.game.health) {
        0...3 => raylib.Color.red,
        4...7 => raylib.Color.orange,
        else => raylib.Color.green,
    };

    world.resources.font_manager.drawTextPixel(
        raylib.textFormat("HEALTH: %03i", .{world.game.health}),
        10,
        70,
        16,
        text_color,
    );
}
