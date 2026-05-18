const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const resource_system = @import("../resources/resources.zig");

const Resources = resource_system.Resources;

pub fn system(world: *ecs.World, resources: *Resources) void {
    drawScore(world, resources);
    drawSpeed(world, resources);
    drawTime(world, resources);
    drawHealth(world, resources);
}

fn drawScore(world: *ecs.World, resources: *Resources) void {
    resources.text.drawTextPixel(
        raylib.textFormat("SCORE: %03i", .{world.score}),
        10,
        10,
        16,
        raylib.Color.white,
    );
}

fn drawSpeed(world: *ecs.World, resources: *Resources) void {
    const scroll_speed = @as(i32, @intFromFloat(world.scroll_speed));

    resources.text.drawTextPixel(
        raylib.textFormat("SPEED: %03i", .{scroll_speed}),
        10,
        30,
        16,
        raylib.Color.white,
    );
}

fn drawTime(world: *ecs.World, resources: *Resources) void {
    resources.text.drawTextPixel(
        raylib.textFormat("TIME: %.1fs", .{world.time}),
        10,
        50,
        16,
        raylib.Color.white,
    );
}

fn drawHealth(world: *ecs.World, resources: *Resources) void {
    var text_color = raylib.Color.white;
    text_color = switch (world.health) {
        0...3 => raylib.Color.red,
        4...7 => raylib.Color.orange,
        else => raylib.Color.green,
    };

    resources.text.drawTextPixel(
        raylib.textFormat("HEALTH: %03i", .{world.health}),
        10,
        70,
        16,
        text_color,
    );
}
