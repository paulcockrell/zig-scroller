const std = @import("std");
const raylib = @import("raylib");

pub fn main() !void {
    const screen_width: u16 = 1000;
    const screen_height: u16 = 600;

    // Prints to stderr, ignoring potential errors.
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    raylib.initWindow(screen_width, screen_height, "Zig scroller");
    raylib.setTargetFPS(60);
    defer raylib.closeWindow();

    while (!raylib.windowShouldClose()) {
        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.black);

        raylib.drawText(
            "Zig Scroller",
            screen_width / 2 - 70,
            screen_height / 2 - 25,
            20,
            raylib.Color.gray,
        );
    }
}
