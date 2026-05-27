const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../engine/ecs/ecs.zig");
const input = @import("../engine/platform/input.zig");
const scenes_change = @import("../engine/runtime/scene_change.zig");
const scenes_update = @import("../engine/runtime/scene_update.zig");
const scenes_render = @import("../engine/runtime/scene_render.zig");

pub const FPS: i32 = 60;
pub const SCREEN_WIDTH: i32 = 1280;
pub const SCREEN_HEIGHT: i32 = 720;
pub const VIRTUAL_SCREEN_WIDTH: i32 = 480;
pub const VIRTUAL_SCREEN_HEIGHT: i32 = 270;

pub const App = struct {
    world: ecs.World,
    target_texture: raylib.RenderTexture2D,
    bg_music: raylib.Music,

    pub fn init(allocator: std.mem.Allocator) !App {
        const target_texture = try initRaylib();
        const bg_music = try raylib.loadMusicStream("resources/audio/djartmusic-best-game-console-301284.mp3");
        const world = try ecs.World.init(
            allocator,
            VIRTUAL_SCREEN_WIDTH,
            VIRTUAL_SCREEN_HEIGHT,
        );

        return .{
            .world = world,
            .target_texture = target_texture,
            .bg_music = bg_music,
        };
    }

    pub fn deinit(self: *App) void {
        self.world.deinit();
        self.bg_music.unload();
        raylib.unloadRenderTexture(self.target_texture);
        raylib.closeAudioDevice();
        raylib.closeWindow();
    }

    pub fn run(self: *App) !void {
        raylib.playMusicStream(self.bg_music);

        try self.world.game.changeScene(ecs.Scene.main_menu);

        while (!raylib.windowShouldClose()) {
            const delta = raylib.getFrameTime();

            self.updateMusic();
            self.handleInput();
            self.update(delta);
            self.render(delta);
        }
    }

    fn updateMusic(self: *App) void {
        raylib.updateMusicStream(self.bg_music);
    }

    fn handleInput(self: *App) void {
        input.system(&self.world);
    }

    fn update(self: *App, delta: f32) void {
        scenes_change.system(&self.world);
        scenes_update.system(&self.world, delta);
    }

    fn render(self: *App, delta: f32) void {
        const viewport = self.calculateViewport();
        // Draw our scene to the render texture
        raylib.beginTextureMode(self.target_texture);
        scenes_render.system(&self.world, delta);
        raylib.endTextureMode();

        raylib.beginDrawing();
        raylib.clearBackground(raylib.Color.black);
        raylib.drawTexturePro(
            self.target_texture.texture,
            .{
                .x = 0.0,
                .y = 0.0,
                .width = @as(f32, @floatFromInt(self.target_texture.texture.width)),
                .height = @as(f32, @floatFromInt(self.target_texture.texture.height)) * -1.0,
            },
            viewport,
            .{
                .x = 0.0,
                .y = 0.0,
            },
            0,
            raylib.Color.white,
        );

        raylib.endDrawing();
    }

    fn initRaylib() !raylib.RenderTexture2D {
        raylib.initWindow(
            SCREEN_WIDTH,
            SCREEN_HEIGHT,
            "Zig Scroller",
        );
        raylib.initAudioDevice();
        raylib.setTargetFPS(FPS);

        const target_texture: raylib.RenderTexture2D = try raylib.loadRenderTexture(
            VIRTUAL_SCREEN_WIDTH,
            VIRTUAL_SCREEN_HEIGHT,
        );

        return target_texture;
    }

    fn calculateViewport(self: *App) raylib.Rectangle {
        _ = self;

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

        return .{
            .x = center_x,
            .y = center_y,
            .width = scaled_width,
            .height = scaled_height,
        };
    }
};
