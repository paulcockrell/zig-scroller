const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const texture_tags = @import("./texture_tags.zig");

const TextureTag = texture_tags.TextureTag;

pub const TextureSystem = struct {
    textures: std.AutoHashMap(TextureTag, raylib.Texture),

    pub fn init(allocator: std.mem.Allocator) !TextureSystem {
        var textures = std.AutoHashMap(TextureTag, raylib.Texture).init(allocator);

        const player = try loadSprite("resources/graphics/player.png");
        textures.put(TextureTag.player, player);

        const enemy = try loadSprite("resources/graphics/enemy.png");
        textures.put(TextureTag.enemy, enemy);

        const ring = try loadSprite("resources/graphics/ring.png");
        textures.put(TextureTag.ring, ring);

        const background = try loadSprite("resources/graphics/background.png");
        textures.put(TextureTag.background, background);

        const platform = try loadSprite("resources/graphics/platform.png");
        textures.put(TextureTag.platform, platform);

        return .{
            .textures = textures,
        };
    }

    pub fn deinit(self: *TextureSystem) void {
        var it = self.textures.iterator();
        while (it.next()) |ent| {
            raylib.unloadSound(ent.value_ptr.*);
        }

        self.textures.deinit();
    }

    pub fn get(self: *TextureSystem, key: TextureTag) ?*raylib.Texture {
        return self.textures.getPtr(key);
    }
};

fn loadSprite(img_path: [:0]const u8) !raylib.Texture {
    const image = try raylib.loadImage(img_path);
    const texture = try raylib.loadTextureFromImage(image);

    return texture;
}
