const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const AudioTag = @import("./audio_tag.zig").AudioTag;

pub const AudioManager = struct {
    sounds: std.AutoHashMap(AudioTag, raylib.Sound),

    pub fn init(allocator: std.mem.Allocator) !AudioManager {
        var sounds = std.AutoHashMap(AudioTag, raylib.Sound).init(allocator);

        const jump = try raylib.loadSound(
            "./resources/audio/lumora_studios-pixel-jump-319167.mp3",
        );
        const ring = try raylib.loadSound(
            "./resources/audio/ring.wav",
        );
        const hit = try raylib.loadSound(
            "./resources/audio/destroy.wav",
        );
        const stomp = try raylib.loadSound(
            "./resources/audio/hyper-ring.wav",
        );

        try sounds.put(AudioTag.jump, jump);
        try sounds.put(AudioTag.ring, ring);
        try sounds.put(AudioTag.hit, hit);
        try sounds.put(AudioTag.stomp, stomp);

        return .{
            .sounds = sounds,
        };
    }

    pub fn deinit(self: *AudioManager) void {
        var it = self.sounds.iterator();

        while (it.next()) |ent| {
            raylib.unloadSound(ent.value_ptr.*);
        }

        self.sounds.deinit();
    }

    pub fn play(self: *AudioManager, tag: AudioTag) void {
        if (self.sounds.get(tag)) |sound| {
            raylib.playSound(sound);
        }
    }
};
