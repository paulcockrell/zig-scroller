const std = @import("std");
const raylib = @import("raylib");

const ecs = @import("ecs.zig");

const scroll = @import("systems/scroll.zig");
const input = @import("systems/input.zig");
const gravity = @import("systems/gravity.zig");
const movement = @import("systems/movement.zig");
const collision = @import("systems/collision.zig");
const jump_intent = @import("systems/jump_intent.zig");
const difficulty = @import("systems/difficulty.zig");
const hud = @import("systems/hud.zig");
const sprite = @import("systems/sprite.zig");
const resource = @import("systems/resource.zig");
const entity_wrap = @import("systems/entity_wrap.zig");
const entity_reset = @import("systems/entity_reset.zig");
const scenery_wrap = @import("systems/scenery_wrap.zig");
const sound_intent = @import("systems/sound_intent.zig");

const player = @import("entities/player.zig");
const enemy = @import("entities/enemy.zig");
const ring = @import("entities/ring.zig");
const platform = @import("entities/platform.zig");
const background = @import("entities/background.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const screen_width: i32 = 800;
    const screen_height: i32 = 600;

    raylib.setTargetFPS(ecs.FPS);
    raylib.initWindow(
        screen_width,
        screen_height,
        "Zig scroller",
    );
    defer raylib.closeWindow();

    raylib.initAudioDevice();
    defer raylib.closeAudioDevice();

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

    try player.spawn(&world);
    try platform.spawn(&world);
    try background.spawn(&world);
    for (0..5) |_| {
        try enemy.spawn(&world);
        try ring.spawn(&world);
    }

    while (!raylib.windowShouldClose()) {
        const delta = raylib.getFrameTime();
        world.time += delta;

        input.system(&world);
        collision.system(&world);
        jump_intent.system(&world);
        gravity.system(&world, delta);
        movement.system(&world, delta);
        scroll.system(&world, delta);
        entity_wrap.system(&world, delta);
        entity_reset.system(&world);
        scenery_wrap.system(&world, delta);
        difficulty.system(&world);
        sound_intent.system(&world);

        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.black);
        sprite.system(&world, delta);
        hud.system(&world);
    }
}
