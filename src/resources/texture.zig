const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const texture_tags = @import("./texture_tags.zig");

const TextureTag = texture_tags.TextureTag;

pub const TextureManager = struct {
    textures: std.AutoHashMap(TextureTag, raylib.Texture),

    pub fn init(allocator: std.mem.Allocator) !TextureManager {
        var textures = std.AutoHashMap(TextureTag, raylib.Texture).init(allocator);

        const player_texture = try loadTexture(ecs.GRAPHICS_DIR ++ "player.png");
        try textures.put(TextureTag.player, player_texture);

        const enemy_texture = try loadTexture(ecs.GRAPHICS_DIR ++ "enemy.png");
        try textures.put(TextureTag.enemy, enemy_texture);

        const ring_texture = try loadTexture(ecs.GRAPHICS_DIR ++ "ring.png");
        try textures.put(TextureTag.ring, ring_texture);

        const background_texture = try loadTexture(ecs.GRAPHICS_DIR ++ "background.png");
        try textures.put(TextureTag.background, background_texture);

        const platform_texture = try loadTexture(ecs.GRAPHICS_DIR ++ "platform.png");
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
    const texture = try raylib.loadTextureFromImage(image);

    return texture;
}
