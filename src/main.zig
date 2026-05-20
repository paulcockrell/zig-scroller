const std = @import("std");
const raylib = @import("raylib");

const ecs = @import("ecs.zig");

const input = @import("systems/input/keyboard.zig");
const scenes_change = @import("systems/scenes/change.zig");
const scenes_update = @import("systems/scenes/update.zig");
const scenes_render = @import("systems/scenes/render.zig");
const Resources = @import("resources/resources.zig").Resources;

const VIRTUAL_SCREEN_WIDTH: i32 = 480;
const VIRTUAL_SCREEN_HEIGHT: i32 = 270;
const SCREEN_WIDTH: i32 = 1280;
const SCREEN_HEIGHT: i32 = 720;

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var world = ecs.World.init(
        allocator,
        VIRTUAL_SCREEN_WIDTH,
        VIRTUAL_SCREEN_HEIGHT,
    );

    const target = try initRaylib();

    var resources = try Resources.init(allocator);

    //const bg_music = try raylib.loadMusicStream("resources/audio/djartmusic-best-game-console-301284.mp3");
    //raylib.playMusicStream(bg_music);

    try world.changeScene(ecs.Scene.main_menu);

    while (!raylib.windowShouldClose()) {
        //raylib.updateMusicStream(bg_music);

        const window_width = raylib.getScreenWidth();
        const window_height = raylib.getScreenHeight();

        const scale: f32 = @min(
            @as(f32, @floatFromInt(window_width)) / @as(f32, @floatFromInt(VIRTUAL_SCREEN_WIDTH)),
            @as(f32, @floatFromInt(window_height)) / @as(f32, @floatFromInt(VIRTUAL_SCREEN_HEIGHT)),
        );
        const scaled_width = @as(f32, @floatFromInt(VIRTUAL_SCREEN_WIDTH)) * scale;
        const scaled_height = @as(f32, @floatFromInt(VIRTUAL_SCREEN_HEIGHT)) * scale;
        const center_x = (@as(f32, @floatFromInt(window_width)) - scaled_width) / 2;
        const center_y = (@as(f32, @floatFromInt(window_height)) - scaled_height) / 2;

        const delta = raylib.getFrameTime();

        input.system(&world);

        scenes_change.system(&world);
        scenes_update.system(&world, &resources, delta);

        input.resetInput(&world);

        // Draw our scene to the render texture
        raylib.beginTextureMode(target);
        scenes_render.system(&world, &resources, delta);
        raylib.endTextureMode();

        raylib.beginDrawing();
        raylib.clearBackground(raylib.Color.black);
        raylib.drawTexturePro(
            target.texture,
            .{
                .x = 0.0,
                .y = 0.0,
                .width = @as(f32, @floatFromInt(target.texture.width)),
                .height = @as(f32, @floatFromInt(target.texture.height)) * -1.0,
            },
            .{
                .x = center_x,
                .y = center_y,
                .width = scaled_width,
                .height = scaled_height,
            },
            .{
                .x = 0.0,
                .y = 0.0,
            },
            0,
            raylib.Color.white,
        );
        raylib.endDrawing();
    }

    world.deinit();
    resources.deinit();
    raylib.closeAudioDevice();
    raylib.closeWindow();
}

fn initRaylib() !raylib.RenderTexture2D {
    raylib.initWindow(
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
        "Zig scroller",
    );

    raylib.initAudioDevice();

    raylib.setTargetFPS(ecs.FPS);

    const target: raylib.RenderTexture2D = try raylib.loadRenderTexture(
        VIRTUAL_SCREEN_WIDTH,
        VIRTUAL_SCREEN_HEIGHT,
    );

    return target;
}
