const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("ecs.zig");

fn inputSystem(world: *ecs.World) void {
    if (!raylib.isKeyPressed(raylib.KeyboardKey.space)) return;

    const ctx: i32 = 0;

    ecs.Query.players(world, ctx, struct {
        fn run(
            _: i32,
            _: ecs.Entity,
            _: *ecs.Position,
            vel: *ecs.Velocity,
            _: *ecs.World,
        ) void {
            vel.dy = -100; //jump force
        }
    }.run);
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
        const ent = entry.key_ptr.*;
        const pos = entry.value_ptr.*;

        if (world.players.contains(ent)) {
            raylib.drawRectangle(
                @intFromFloat(pos.x),
                @intFromFloat(pos.y),
                20,
                20,
                raylib.Color.green,
            );
        }

        if (world.obstacles.contains(ent)) {
            raylib.drawRectangle(
                @intFromFloat(pos.x),
                @intFromFloat(pos.y),
                20,
                60,
                raylib.Color.red,
            );
        }
    }
}

pub fn main(init: std.process.Init) !void {
    const screen_width: i32 = 1000.0;
    const screen_height: i32 = 800.0;

    raylib.setTargetFPS(60);
    raylib.initWindow(
        screen_width,
        screen_height,
        "Zig scroller",
    );
    defer raylib.closeWindow();

    const allocator = init.gpa;

    var world = ecs.World.init(
        allocator,
        screen_width,
        screen_height,
    );
    defer world.deinit();

    _ = try ecs.spawnPlayer(&world);
    _ = try ecs.spawnObstacle(&world);

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
