const std = @import("std");
const raylib = @import("raylib");

const ecs = @import("ecs.zig");

const resource_audio = @import("systems/resources/audio.zig");
const resource_textures = @import("systems/resources/textures.zig");

const player = @import("entities/player.zig");
const enemy = @import("entities/enemy.zig");
const ring = @import("entities/ring.zig");
const platform = @import("entities/platform.zig");
const background = @import("entities/background.zig");

const main_menu = @import("scenes/main_menu.zig");
const game_play = @import("scenes/game_play.zig");
const game_over = @import("scenes/game_over.zig");
const credits = @import("scenes/credits.zig");

const SCREEN_WIDTH: i32 = 800;
const SCREEN_HEIGHT: i32 = 600;

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var world = ecs.World.init(
        allocator,
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
    );

    init_raylib(&world);
    try spawn_entities(&world);

    const bg_music = try raylib.loadMusicStream("resources/audio/monume-drum-amp-bass-dnb-music-dampb-drum-and-bass-519203.mp3");
    raylib.playMusicStream(bg_music);

    while (!raylib.windowShouldClose()) {
        raylib.updateMusicStream(bg_music);
        raylib.beginDrawing();

        const delta = raylib.getFrameTime();

        switch (world.scene) {
            ecs.Scene.game_play => {
                game_play.update(&world, delta);
                game_play.render(&world, delta);
            },
            ecs.Scene.game_over => {
                game_over.update(&world, delta);
                game_over.render(&world, delta);
            },
            ecs.Scene.credits => {
                credits.update(&world, delta);
                credits.render(&world, delta);
            },
            else => {
                main_menu.update(&world, delta);
                main_menu.render(&world, delta);
            },
        }

        defer raylib.endDrawing();
    }

    world.deinit();
    raylib.closeAudioDevice();
    raylib.closeWindow();
}

fn init_raylib(world: *ecs.World) void {
    raylib.initWindow(
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
        "Zig scroller",
    );

    raylib.initAudioDevice();

    raylib.setTargetFPS(ecs.FPS);

    resource_textures.system(world) catch |err| {
        std.debug.print("Failed to load texture resources. Exiting. {}", .{err});
        return;
    };

    // must come before entities are spawned
    resource_audio.system(world) catch |err| {
        std.debug.print("Failed to load audio resources. Exiting. {}", .{err});
        return;
    };
}

fn spawn_entities(world: *ecs.World) !void {
    try player.spawn(world);
    try platform.spawn(world);
    try background.spawn(world);
    for (0..5) |_| {
        try enemy.spawn(world);
        try ring.spawn(world);
    }
}
