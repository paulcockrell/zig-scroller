const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) !void {
    try load_player_sprite(world);
    try load_enemy_sprite(world);
    try load_ring_sprite(world);
    try load_background_sprite(world);
    try load_platform_sprite(world);
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
