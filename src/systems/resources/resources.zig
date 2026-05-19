const std = @import("std");

const audio_system = @import("./audio.zig");
const AudioSystem = audio_system.AudioSystem;
const text_system = @import("./text.zig");
const TextSystem = text_system.TextSystem;
const texture_system = @import("./textures.zig");
const TextureSystem = texture_system.TextureSystem;
pub const TextureTag = texture_system.TextureTag;

pub const Resources = struct {
    text: TextSystem,
    audio: AudioSystem,
    textures: TextureSystem,

    pub fn init(allocator: std.mem.Allocator) !Resources {
        const text = try TextSystem.init();
        const audio = try AudioSystem.init(allocator);
        const textures = try TextureSystem.init(allocator);

        return .{
            .text = text,
            .audio = audio,
            .textures = textures,
        };
    }

    pub fn deinit(self: *Resources) void {
        self.text.deinit();
        self.audio.deinit();
        self.textures.deinit();
    }
};
