const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const texture_tags = @import("./texture_tags.zig");

const TextureTag = texture_tags.TextureTag;

pub const TextureManager = struct {
    textures: std.AutoHashMap(TextureTag, raylib.Texture),

    pub fn init(allocator: std.mem.Allocator) !TextureManager {
        var textures = std.AutoHashMap(TextureTag, raylib.Texture).init(allocator);

        const player = try loadSprite(ecs.GRAPHICS_DIR ++ "player.png");
        try textures.put(TextureTag.player, player);

        const enemy = try loadSprite(ecs.GRAPHICS_DIR ++ "enemy.png");
        try textures.put(TextureTag.enemy, enemy);

        const ring = try loadSprite(ecs.GRAPHICS_DIR ++ "ring.png");
        try textures.put(TextureTag.ring, ring);

        const background = try loadSprite(ecs.GRAPHICS_DIR ++ "background.png");
        try textures.put(TextureTag.background, background);

        const platform = try loadSprite(ecs.GRAPHICS_DIR ++ "platform.png");
        try textures.put(TextureTag.platform, platform);

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

fn loadSprite(img_path: [:0]const u8) !raylib.Texture {
    const image = try raylib.loadImage(img_path);
    const texture = try raylib.loadTextureFromImage(image);

    return texture;
}
