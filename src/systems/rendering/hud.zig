const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) void {
    drawScore(world);
    drawSpeed(world);
    drawTime(world);
    drawHealth(world);
}

fn drawScore(world: *ecs.World) void {
    raylib.drawText(
        raylib.textFormat("SCORE: %03i", .{world.score}),
        10,
        10,
        16,
        raylib.Color.white,
    );
}

fn drawSpeed(world: *ecs.World) void {
    const scroll_speed = @as(i32, @intFromFloat(world.scroll_speed));

    raylib.drawText(
        raylib.textFormat("SPEED: %03i", .{scroll_speed}),
        10,
        30,
        16,
        raylib.Color.white,
    );
}

fn drawTime(world: *ecs.World) void {
    raylib.drawText(
        raylib.textFormat("TIME: %.1fs", .{world.time}),
        10,
        50,
        16,
        raylib.Color.white,
    );
}

fn drawHealth(world: *ecs.World) void {
    var text_color = raylib.Color.white;
    text_color = switch (world.health) {
        0...3 => raylib.Color.red,
        4...7 => raylib.Color.orange,
        else => raylib.Color.green,
    };

    raylib.drawText(
        raylib.textFormat("HEALTH: %03i", .{world.health}),
        10,
        70,
        16,
        text_color,
    );
}
