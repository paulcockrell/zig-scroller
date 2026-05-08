const ecs = @import("../ecs.zig");
const raylib = @import("raylib");
const std = @import("std");

pub fn system(world: *ecs.World) !void {
    try load_player_sprite(world);
    try load_enemy_sprite(world);
}

fn load_player_sprite(world: *ecs.World) !void {
    const player_image = try raylib.loadImage("resources/sonic.png");
    const player_texture = try raylib.loadTextureFromImage(player_image);
    raylib.unloadImage(player_image);

    try world.sprites.put(ecs.SpriteTag.player, player_texture);
}

fn load_enemy_sprite(world: *ecs.World) !void {
    const enemy_image = try raylib.loadImage("resources/motobug.png");
    const enemy_texture = try raylib.loadTextureFromImage(enemy_image);
    raylib.unloadImage(enemy_image);

    try world.sprites.put(ecs.SpriteTag.enemy, enemy_texture);
}
