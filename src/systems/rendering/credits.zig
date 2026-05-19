const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const resource_systems = @import("../resources/resources.zig");

const Resources = resource_systems.Resources;

pub fn system(world: *ecs.World, resources: *Resources, delta: f32) void {
    _ = delta;

    drawText(world, resources);
}

fn drawText(world: *ecs.World, resources: *Resources) void {
    const y_center = @as(f32, @floatFromInt(world.screen_height)) / 2;

    var text = raylib.textFormat("CREDITS", .{});
    var font_size: f32 = 24.0;
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 96.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("PROGRAMMING: Paul Cockrell", .{});
    font_size = 16.0;
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 48.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("GRAPHICS: Paul Cockrell", .{world.time});
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 24.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("INSPIRATION: jslegenddev.substack.com", .{world.time});
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );

    text = raylib.textFormat("Press 'c' to continue", .{});
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center + 24,
        raylib.Color.white,
    );
}
