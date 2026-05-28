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
const player = @import("../entities/player.zig");
const enemy = @import("../entities/enemy.zig");
const ring = @import("../entities/ring.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");
const popup_points = @import("../systems/popup_points.zig");
const AudioTag = @import("../../engine/assets/audio_tags.zig").AudioTag;
const TextureTag = @import("../../engine/assets/texture_tags.zig").TextureTag;
const renderer = @import("../renderer.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn enter(world: *World) !void {
    try player.spawn(world);
    try platform.spawn(world);
    try background.spawn(world);
    for (0..3) |_| {
        try enemy.spawn(world);
    }
    for (0..2) |_| {
        try ring.spawn(world);
    }
}

pub fn exit(world: *World) void {
    _ = world;
}

pub fn update(world: *World, delta: f32) void {
    world.game.time += delta;

    if (world.game.jump_intent) jumpPlayer(world);

    collision.system(world);
    jump_intent.system(world);
    gravity.system(world, delta);
    jump.system(world, delta);
    scroll.system(world, delta);
    entity_wrap.system(world);
    entity_reset.system(world);
    scenery_wrap.system(world);
    difficulty.system(world);
    sound_intent.system(world);
}

pub fn render(world: *World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);

    renderBackgrounds(world, delta);
    renderPlatforms(world, delta);
    renderPlayers(world, delta);
    renderEnemies(world, delta);
    renderRings(world, delta);

    hud.system(world);
    popup_points.system(world, delta);
}

fn jumpPlayer(
    world: *World,
) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        if (player.isJumping(world, ent)) return;

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

fn renderRings(world: *World, delta: f32) void {
    var it = world.ecs.rings.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderer.renderEntity(
            world,
            ent,
            TextureTag.ring,
            delta,
        );
    }
}

fn renderPlayers(world: *World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderPlayer(
            world,
            ent,
            delta,
        );
    }
}

fn renderPlayer(
    world: *World,
    ent: ecs.Entity,
    delta: f32,
) void {
    const anim = world.ecs.animations.getPtr(ent) orelse return;
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return;
    const texture = world.resources.texture_manager.get(TextureTag.player) orelse return;
    const src_x = @as(f32, @floatFromInt(anim.frame_idx)) * dim.width;
    const src_y =
        if (player.isJumping(world, ent))
            dim.height
        else
            0.0;

    renderer.processAnimation(anim, delta);

    renderer.drawTexture(
        src_x,
        src_y,
        dim,
        pos,
        texture,
    );
}
