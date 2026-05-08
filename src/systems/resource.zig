const ecs = @import("../ecs.zig");
const raylib = @import("raylib");
const std = @import("std");

pub fn system(world: *ecs.World) !void {
    try load_player_sprite(world);
}

fn load_player_sprite(world: *ecs.World) !void {
    const sonic_image = try raylib.loadImage("resources/sonic.png");
    const sonic_texture = try raylib.loadTextureFromImage(sonic_image);
    raylib.unloadImage(sonic_image);

    try world.sprites.put(ecs.SpriteTag.player, sonic_texture);
}
