const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const Resources = @import("../../resources/resources.zig").Resources;

pub fn system(world: *ecs.World, resources: *Resources) void {
    drawText(world, resources);
}

fn drawText(world: *ecs.World, resources: *Resources) void {
    const y_center = @as(f32, @floatFromInt(world.screen_height)) / 2.0;

    var text = raylib.textFormat("Zero Dash", .{});
    var font_size: f32 = 24.0;
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 96.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'space' to play", .{});
    font_size = 16.0;
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 48.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'c' for credits", .{});
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 24.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'esc' to exit", .{});
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}
