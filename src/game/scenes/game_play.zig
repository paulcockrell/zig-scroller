const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;
const gravity = @import("../systems/gravity.zig");
const jump = @import("../systems/jump.zig");
const collision = @import("../systems/collision.zig");
const jump_intent = @import("../systems/jump_intent.zig");
const difficulty = @import("../systems/difficulty.zig");
const hud = @import("../systems/hud.zig");
const scroll = @import("../systems/scroll.zig");
const entity_wrap = @import("../systems/entity_wrap.zig");
const entity_reset = @import("../systems/entity_reset.zig");
const scenery_wrap = @import("../systems/scenery_wrap.zig");
const sound_intent = @import("../systems/sound_intent.zig");
const player_animation = @import("../systems/player_animation.zig");
const player = @import("../entities/player.zig");
const enemy = @import("../entities/enemy.zig");
const coin = @import("../entities/coin.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");
const popup_points = @import("../systems/popup_points.zig");
const AudioTag = @import("../../engine/assets/audio_tags.zig").AudioTag;
const TextureTag = @import("../../engine/assets/texture_tags.zig").TextureTag;
const renderer = @import("../renderer.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn enter(world: *World) !void {
    try player.spawn(world, player.ScreenMode.game);
    try platform.spawn(world);
    try background.spawn(world);
    for (0..3) |_| {
        try enemy.spawn(world);
    }
    for (0..2) |_| {
        try coin.spawn(world);
    }
}

pub fn exit(world: *World) void {
    _ = world;
}

pub fn update(world: *World, delta: f32) void {
    world.game.time += delta;

    if (world.game.jump_intent) jumpPlayer(world);

    entity_reset.system(world);
    jump_intent.system(world);
    jump.system(world, delta);
    gravity.system(world, delta);
    collision.system(world);
    scroll.system(world, delta);
    entity_wrap.system(world);
    scenery_wrap.system(world);
    difficulty.system(world);
    player_animation.system(world);
    sound_intent.system(world);
}

pub fn render(world: *World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);

    renderBackgrounds(world, delta);
    renderPlatforms(world, delta);
    renderPlayers(world, delta);
    renderEnemies(world, delta);
    renderCoins(world, delta);

    hud.system(world);
    popup_points.system(world, delta);
}

fn jumpPlayer(
    world: *World,
) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        // Only jump from floor
        if (!collision.isEntityGrounded(world, ent)) return;

        world.game.jump_intents.put(ent, .{ .force = JUMP_FORCE }) catch |err| {
            std.debug.print("Entity jump intent failed {}\n", .{err});
        };

        world.game.sound_intents.put(AudioTag.jump, .{ .volume = 0.3 }) catch |err| {
            std.debug.print("Jump sound intent failed {}\n", .{err});
        };
    }
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

fn renderEnemies(world: *World, delta: f32) void {
    var it = world.ecs.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderer.renderEntity(
            world,
            ent,
            TextureTag.enemy,
            delta,
        );
    }
}

fn renderCoins(world: *World, delta: f32) void {
    var it = world.ecs.coins.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderer.renderEntity(
            world,
            ent,
            TextureTag.coin,
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
