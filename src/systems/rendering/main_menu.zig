const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    _ = delta;

    drawText(world);
}

fn drawText(world: *ecs.World) void {
    var text = raylib.textFormat("Zig Scroller", .{});
    var y = @divFloor(world.screen_height, 2) - 48;
    drawCenteredText(
        world,
        text,
        48,
        y,
        raylib.Color.green,
    );

    text = raylib.textFormat("press space to start", .{});
    y = @divFloor(world.screen_height, 2) + 24;
    drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.white,
    );

    text = raylib.textFormat("press c for credits", .{});
    y = @divFloor(world.screen_height, 2) + 44;
    drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.yellow,
    );

    text = raylib.textFormat("press esc to exit", .{});
    y = @divFloor(world.screen_height, 2) + 64;
    drawCenteredText(
        world,
        text,
        18,
        y,
        raylib.Color.red,
    );
}

fn drawCenteredText(
    world: *ecs.World,
    text: [:0]const u8,
    font_size: i32,
    y: i32,
    colour: raylib.Color,
) void {
    const text_width = raylib.measureText(text, font_size);
    const x: i32 = @divFloor(world.screen_width - text_width, 2);

    raylib.drawText(
        text,
        x,
        y,
        font_size,
        colour,
    );
}
