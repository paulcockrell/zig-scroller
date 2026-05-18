const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const resources_system = @import("../resources/resources.zig");

const Resources = resources_system.Resources;

pub fn system(world: *ecs.World, resources: *Resources) void {
    drawText(world, resources);
}

fn drawText(world: *ecs.World, resources: *Resources) void {
    const y_center = @divFloor(world.screen_height, 2);

    var text = raylib.textFormat("Zero Dash", .{});
    var font_size: i32 = 24;
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 96,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'space' to play", .{});
    font_size = 16;
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 48,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'c' for credits", .{});
    resources.text.drawTextPixelCentered(
        world,
        text,
        font_size,
        y_center - 24,
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
