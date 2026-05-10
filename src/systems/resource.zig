const ecs = @import("../ecs.zig");
const raylib = @import("raylib");
const std = @import("std");

pub fn system(world: *ecs.World) !void {
    try load_player_sprite(world);
    try load_enemy_sprite(world);
    try load_ring_sprite(world);
    try load_background_sprite(world);
    try load_platform_sprite(world);
    try load_sounds(world);
}

pub fn deinit(world: *ecs.World) void {
    ecs.Query.sounds(world, unload_sounds);
}

fn unload_sounds(_: ecs.SoundTag, sound: *raylib.Sound, _: *ecs.World) void {
    raylib.unloadSound(sound.*);
}

fn load_player_sprite(world: *ecs.World) !void {
    try load_sprite(
        world,
        "resources/graphics/player.png",
        ecs.SpriteTag.player,
    );
}

fn load_enemy_sprite(world: *ecs.World) !void {
    try load_sprite(
        world,
        "resources/graphics/enemy.png",
        ecs.SpriteTag.enemy,
    );
}

fn load_ring_sprite(world: *ecs.World) !void {
    try load_sprite(
        world,
        "resources/graphics/ring.png",
        ecs.SpriteTag.ring,
    );
}

fn load_background_sprite(world: *ecs.World) !void {
    try load_sprite(
        world,
        "resources/graphics/background.png",
        ecs.SpriteTag.background,
    );
}

fn load_platform_sprite(world: *ecs.World) !void {
    try load_sprite(
        world,
        "resources/graphics/platform.png",
        ecs.SpriteTag.platform,
    );
}

fn load_sprite(world: *ecs.World, img_path: [:0]const u8, sprite_tag: ecs.SpriteTag) !void {
    const image = try raylib.loadImage(img_path);
    const texture = try raylib.loadTextureFromImage(image);
    raylib.unloadImage(image);

    try world.sprites.put(sprite_tag, texture);
}

fn load_sounds(world: *ecs.World) !void {
    // try load_background_sound(world);
    try load_jump_sound(world);
    try load_ring_sound(world);
    try load_hit_sound(world);
    try load_stomp_sound(world);
}

// fn load_background_sound(world: *ecs.World) !void {
//     const background = try raylib.loadSound("resources/audio/background.wav");
//     raylib.playSound(background);
//     try world.sounds.put(ecs.SoundTag.background, background);
// }

fn load_jump_sound(world: *ecs.World) !void {
    const jump = try raylib.loadSound("resources/audio/lumora_studios-pixel-jump-319167.mp3");
    try world.sounds.put(ecs.SoundTag.jump, jump);
}

fn load_ring_sound(world: *ecs.World) !void {
    const ring = try raylib.loadSound("resources/audio/ring.wav");
    try world.sounds.put(ecs.SoundTag.ring, ring);
}

fn load_hit_sound(world: *ecs.World) !void {
    const hit = try raylib.loadSound("resources/audio/destroy.wav");
    try world.sounds.put(ecs.SoundTag.hit, hit);
}

fn load_stomp_sound(world: *ecs.World) !void {
    const stomp = try raylib.loadSound("resources/audio/hyper-ring.wav");
    try world.sounds.put(ecs.SoundTag.stomp, stomp);
}
