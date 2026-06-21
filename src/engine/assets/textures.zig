const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../engine/ecs.zig");
const texture_tags = @import("./texture_tags.zig");

const GRAPHICS_DIR = "resources/graphics/";
const TextureTag = texture_tags.TextureTag;

pub const TextureManager = struct {
    textures: std.AutoHashMap(TextureTag, raylib.Texture),

    pub fn init(allocator: std.mem.Allocator) !TextureManager {
        var textures = std.AutoHashMap(TextureTag, raylib.Texture).init(allocator);
        errdefer textures.deinit();

        const player_texture = try loadTexture(GRAPHICS_DIR ++ "player.png");
        errdefer raylib.unloadTexture(player_texture);
        try textures.put(TextureTag.player, player_texture);

        const enemy_texture = try loadTexture(GRAPHICS_DIR ++ "enemy.png");
        errdefer raylib.unloadTexture(enemy_texture);
        try textures.put(TextureTag.enemy, enemy_texture);

        const coin_texture = try loadTexture(GRAPHICS_DIR ++ "coin.png");
        errdefer raylib.unloadTexture(coin_texture);
        try textures.put(TextureTag.coin, coin_texture);

        const background_texture = try loadTexture(GRAPHICS_DIR ++ "background.png");
        errdefer raylib.unloadTexture(background_texture);
        try textures.put(TextureTag.background, background_texture);

        const platform_texture = try loadTexture(GRAPHICS_DIR ++ "platform.png");
        errdefer raylib.unloadTexture(platform_texture);
        try textures.put(TextureTag.platform, platform_texture);

        return .{
            .textures = textures,
        };
    }

    pub fn deinit(self: *TextureManager) void {
        var it = self.textures.iterator();
        while (it.next()) |ent| {
            raylib.unloadTexture(ent.value_ptr.*);
        }

        self.textures.deinit();
    }

    pub fn get(self: *TextureManager, key: TextureTag) ?*raylib.Texture {
        return self.textures.getPtr(key);
    }
};

fn loadTexture(img_path: [:0]const u8) !raylib.Texture {
    const image = try raylib.loadImage(img_path);
    defer image.unload();

    const texture = try raylib.loadTextureFromImage(image);
    raylib.setTextureFilter(texture, .point);

    return texture;
}
