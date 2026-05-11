const std = @import("std");
const raylib = @import("raylib");

const ecs = @import("ecs.zig");

const scroll = @import("systems/rendering/scroll.zig");
const input = @import("systems/input/keyboard.zig");
const gravity = @import("systems/physics/gravity.zig");
const movement = @import("systems/movement/movement.zig");
const collision = @import("systems/movement/collision.zig");
const jump_intent = @import("systems/movement/jump_intent.zig");
const difficulty = @import("systems/gameplay/difficulty.zig");
const hud = @import("systems/rendering/hud.zig");
const sprite = @import("systems/rendering/sprite.zig");
const resource_audio = @import("systems/resources/audio.zig");
const resource_textures = @import("systems/resources/textures.zig");
const entity_wrap = @import("systems/rendering/entity_wrap.zig");
const entity_reset = @import("systems/gameplay/entity_reset.zig");
const scenery_wrap = @import("systems/rendering/scenery_wrap.zig");
const sound_intent = @import("systems/audio/sound_intent.zig");

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

    const bg_music = try raylib.loadMusicStream("resources/audio/monume-drum-amp-bass-dnb-music-dampb-drum-and-bass-519203.mp3");
    raylib.playMusicStream(bg_music);

    var world = ecs.World.init(
        allocator,
        screen_width,
        screen_height,
    );
    defer world.deinit();

    resource_textures.system(&world) catch |err| {
        std.debug.print("Failed to load texture resources. Exiting. {}", .{err});
        return;
    };

    // must come before entities are spawned
    resource_audio.system(&world) catch |err| {
        std.debug.print("Failed to load audio resources. Exiting. {}", .{err});
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

        raylib.updateMusicStream(bg_music);
    }
}
