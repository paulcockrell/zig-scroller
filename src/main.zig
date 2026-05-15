const std = @import("std");
const raylib = @import("raylib");

const ecs = @import("ecs.zig");

const resource_audio = @import("systems/resources/audio.zig");
const resource_textures = @import("systems/resources/textures.zig");
const input = @import("systems/input/keyboard.zig");
const scenesChange = @import("systems/scenes/change.zig");
const scenesUpdate = @import("systems/scenes/update.zig");
const scenesRender = @import("systems/scenes/render.zig");

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

    const bg_music = try raylib.loadMusicStream("resources/audio/city.mp3");
    raylib.playMusicStream(bg_music);

    try world.changeScene(ecs.Scene.main_menu);

    while (!raylib.windowShouldClose()) {
        raylib.updateMusicStream(bg_music);
        raylib.beginDrawing();

        const delta = raylib.getFrameTime();

        input.system(&world);

        scenesChange.system(&world);
        scenesUpdate.system(&world, delta);
        scenesRender.system(&world, delta);

        input.resetInput(&world);

        raylib.endDrawing();
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
