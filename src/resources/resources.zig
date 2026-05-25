const std = @import("std");

const AudioManager = @import("./audio.zig").AudioManager;
const FontManager = @import("./font.zig").FontManager;
const TextureManager = @import("./texture.zig").TextureManager;

pub const Resources = struct {
    font_manager: FontManager,
    audio_manager: AudioManager,
    texture_manager: TextureManager,

    pub fn init(allocator: std.mem.Allocator) !Resources {
        var font_manager = try FontManager.init();
        errdefer font_manager.deinit();

        var audio_manager = try AudioManager.init(allocator);
        errdefer audio_manager.deinit();

        var texture_manager = try TextureManager.init(allocator);
        errdefer texture_manager.deinit();

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
