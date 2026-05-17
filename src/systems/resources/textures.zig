const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) !void {
    try loadPlayerSprite(world);
    try loadEnemySprite(world);
    try loadRingSprite(world);
    try loadBackgroundSprite(world);
    try loadPlatformSprite(world);
}

fn loadPlayerSprite(world: *ecs.World) !void {
    try loadSprite(
        world,
        "resources/graphics/player.png",
        ecs.SpriteTag.player,
    );
}

fn loadEnemySprite(world: *ecs.World) !void {
    try loadSprite(
        world,
        "resources/graphics/enemy.png",
        ecs.SpriteTag.enemy,
    );
}

fn loadRingSprite(world: *ecs.World) !void {
    try loadSprite(
        world,
        "resources/graphics/ring.png",
        ecs.SpriteTag.ring,
    );
}

fn loadBackgroundSprite(world: *ecs.World) !void {
    try loadSprite(
        world,
        "resources/graphics/background.png",
        ecs.SpriteTag.background,
    );
}

fn loadPlatformSprite(world: *ecs.World) !void {
    try loadSprite(
        world,
        "resources/graphics/platform.png",
        ecs.SpriteTag.platform,
    );
}

fn loadSprite(world: *ecs.World, img_path: [:0]const u8, sprite_tag: ecs.SpriteTag) !void {
    const image = try raylib.loadImage(img_path);
    const texture = try raylib.loadTextureFromImage(image);
    raylib.unloadImage(image);

    try world.sprites.put(sprite_tag, texture);
}
