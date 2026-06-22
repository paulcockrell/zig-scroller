const std = @import("std");
const raylib = @import("raylib");
const World = @import("../game.zig").World;
const Scene = @import("../game.zig").Scene;
const jump = @import("../systems/jump.zig");
const player = @import("../entities/player.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");
const Resources = @import("../../engine/assets/resources.zig").Resources;
const TextureTag = @import("../../engine/assets/texture_tags.zig").TextureTag;
const renderer = @import("../renderer.zig");

pub fn enter(world: *World) !void {
    try player.spawn(world, player.ScreenMode.menu);
    try platform.spawn(world);
    try background.spawn(world);
}

pub fn exit(world: *World) void {
    world.reset();
}

pub fn update(world: *World, delta: f32) void {
    if (world.game.jump_intent) {
        world.game.changeScene(Scene.game_play) catch |err| {
            std.debug.print("Failed to change scene: Main Menu -> Game Play: {}\n", .{err});
        };
    }

    if (world.game.confirm_intent) {
        world.game.changeScene(Scene.credits) catch |err| {
            std.debug.print("Failed to change scene: Main Menu -> Credits: {}\n", .{err});
        };
    }

    jump.system(world, delta);
}

pub fn render(world: *World, delta: f32) void {
    const y_center = @as(f32, @floatFromInt(world.game.screen_height)) / 2.0;

    raylib.clearBackground(raylib.Color.black);

    renderBackgrounds(world, delta);
    renderPlatforms(world, delta);
    renderPlayers(world, delta);

    var text = raylib.textFormat("Zig Scroller", .{});
    var font_size: f32 = 24.0;
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 96.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'space' to play", .{});
    font_size = 16.0;
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 48.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'c' for credits", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center - 24.0,
        raylib.Color.white,
    );

    text = raylib.textFormat("press 'esc' to exit", .{});
    world.resources.font_manager.drawTextPixelCentered(
        world.game.screen_width,
        text,
        font_size,
        y_center,
        raylib.Color.white,
    );
}

fn renderBackgrounds(world: *World, delta: f32) void {
    var it = world.ecs.backgrounds.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderer.renderEntity(
            world,
            ent,
            TextureTag.background,
            delta,
        );
    }
}

fn renderPlatforms(world: *World, delta: f32) void {
    var it = world.ecs.platforms.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderer.renderEntity(
            world,
            ent,
            TextureTag.platform,
            delta,
        );
    }
}

fn renderPlayers(world: *World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderer.renderEntity(
            world,
            ent,
            TextureTag.player,
            delta,
        );
    }
}
