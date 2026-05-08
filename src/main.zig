const std = @import("std");
const raylib = @import("raylib");

const ecs = @import("ecs.zig");

const scroll = @import("systems/scroll.zig");
const wrap = @import("systems/wrap.zig");
const input = @import("systems/input.zig");
const gravity = @import("systems/gravity.zig");
const movement = @import("systems/movement.zig");
const render = @import("systems/render.zig");
const collision = @import("systems/collision.zig");
const reset_entity = @import("systems/reset_entity.zig");
const jump_intents = @import("systems/jump_intent.zig");
const difficulty = @import("systems/difficulty.zig");
const hud = @import("systems/hud.zig");
const sprite = @import("systems/sprite.zig");
const resource = @import("systems/resource.zig");

const player = @import("entities/player.zig");
const enemy = @import("entities/enemy.zig");
const ring = @import("entities/ring.zig");

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

    // must come before entities are spawned
    resource.system(&world) catch |err| {
        std.debug.print("Failed to load resources. Exiting. {}", .{err});
        return;
    };

    _ = try player.spawn(&world);
    for (0..5) |_| {
        _ = try enemy.spawn(&world);
        _ = try ring.spawn(&world);
    }

    while (!raylib.windowShouldClose()) {
        const delta = raylib.getFrameTime();
        world.time += delta;

        input.system(&world);
        collision.system(&world);
        jump_intents.system(&world);
        gravity.system(&world, delta);
        movement.system(&world, delta);
        scroll.system(&world, delta);
        wrap.system(&world, delta);
        reset_entity.system(&world);
        difficulty.system(&world);
        hud.system(&world);
        sprite.system(&world);

        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.black);
        render.system(&world);
    }
}
