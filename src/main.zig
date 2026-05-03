const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("ecs.zig");

fn inputSystem(world: *ecs.World) void {
    if (raylib.isKeyPressed(raylib.KeyboardKey.space)) {
        var it = world.players.iterator();

        while (it.next()) |entry| {
            const e = entry.key_ptr.*;

            if (world.velocities.getPtr(e)) |vel| {
                vel.dy = -300; // jump force
            }
        }
    }
}

fn gravitySystem(world: *ecs.World, dt: f32) void {
    var it = world.velocities.iterator();

    while (it.next()) |entry| {
        entry.value_ptr.dx += 800 * dt; //gravity
    }
}

fn renderSystem(world: *ecs.World) void {
    var it = world.positions.iterator();

    while (it.next()) |entry| {
        const e = entry.key_ptr.*;
        const pos = entry.value_ptr.*;

        if (world.players.contains(e)) {
            raylib.drawRectangle(@intFromFloat(pos.x), @intFromFloat(pos.y), 20, 20, raylib.Color.green);
        } else if (world.obstacles.contains(e)) {
            raylib.drawRectangle(@intFromFloat(pos.x), @intFromFloat(pos.y), 20, 60, raylib.Color.red);
        }
    }
}

pub fn main(init: std.process.Init) !void {
    const screen_width: u16 = 1000;
    const screen_height: u16 = 600;

    raylib.initWindow(screen_width, screen_height, "Zig scroller");
    raylib.setTargetFPS(60);
    defer raylib.closeWindow();

    const allocator = init.gpa;

    var world = ecs.World.init(allocator);
    defer world.deinit();

    _ = try ecs.spawnPlayer(&world);

    while (!raylib.windowShouldClose()) {
        const dt = raylib.getFrameTime();

        inputSystem(&world);
        gravitySystem(&world, dt);
        ecs.movementSystem(&world, dt);

        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.black);
        renderSystem(&world);
    }
}
