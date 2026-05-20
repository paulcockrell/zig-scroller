const std = @import("std");

const AudioManager = @import("./audio.zig").AudioManager;
const FontManager = @import("./font.zig").FontManager;
const TextureManager = @import("./texture.zig").TextureManager;

pub const Resources = struct {
    font_manager: FontManager,
    audio_manager: AudioManager,
    texture_manager: TextureManager,

    pub fn init(allocator: std.mem.Allocator) !Resources {
        const font_manager = try FontManager.init();
        const audio_manager = try AudioManager.init(allocator);
        const texture_manager = try TextureManager.init(allocator);

        return .{
            .font_manager = font_manager,
            .audio_manager = audio_manager,
            .texture_manager = texture_manager,
        };
    }

    pub fn deinit(self: *Resources) void {
        self.font_manager.deinit();
        self.audio_manager.deinit();
        self.texture_manager.deinit();
    }
};
