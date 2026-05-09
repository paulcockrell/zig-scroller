const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    drawScore(world);
    drawSpeed(world);
    drawTime(world);
    drawHealth(world);
}

fn drawScore(world: *ecs.World) void {
    raylib.drawText(
        raylib.textFormat("Score: %03i", .{world.score}),
        10,
        10,
        20,
        raylib.Color.white,
    );
}

fn drawSpeed(world: *ecs.World) void {
    const scroll_speed = @as(i32, @intFromFloat(world.scroll_speed));

    var text_color = raylib.Color.white;
    text_color = switch (scroll_speed) {
        0...200 => raylib.Color.green,
        201...400 => raylib.Color.orange,
        else => raylib.Color.red,
    };

    raylib.drawText(
        raylib.textFormat("Speed: %03i", .{scroll_speed}),
        10,
        30,
        20,
        text_color,
    );
}

fn drawTime(world: *ecs.World) void {
    raylib.drawText(
        raylib.textFormat("Time: %.1fs", .{world.time}),
        10,
        50,
        20,
        raylib.Color.blue,
    );
}

fn drawHealth(world: *ecs.World) void {
    raylib.drawText(
        raylib.textFormat("Health: %03i", .{world.health}),
        10,
        70,
        20,
        raylib.Color.white,
    );
}
