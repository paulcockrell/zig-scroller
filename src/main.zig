const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("ecs.zig");
const scroll = @import("systems/scroll.zig");
const wrap = @import("systems/wrap.zig");
const input = @import("systems/input.zig");
const gravity = @import("systems/gravity.zig");
const movement = @import("systems/movement.zig");
const render = @import("systems/render.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const screen_width: i32 = 1000;
    const screen_height: i32 = 800;

    raylib.setTargetFPS(60);
    raylib.initWindow(
        screen_width,
        screen_height,
        "Zig scroller",
    );
    defer raylib.closeWindow();

    var world = ecs.World.init(
        allocator,
        screen_width,
        screen_height,
    );
    defer world.deinit();

    _ = try ecs.spawnPlayer(&world);
    _ = try ecs.spawnObstacle(&world);

    while (!raylib.windowShouldClose()) {
        const delta = raylib.getFrameTime();

        input.system(&world);
        gravity.system(&world, delta);
        movement.system(&world, delta);
        scroll.system(&world, delta);
        wrap.system(&world, delta);

        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.black);
        render.system(&world);
    }
}
