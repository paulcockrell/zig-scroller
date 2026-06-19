const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../engine/ecs.zig");
const AudioTag = @import("./audio_tags.zig").AudioTag;

const AUDIO_DIR = "resources/audio/";

pub const AudioManager = struct {
    sounds: std.AutoHashMap(AudioTag, raylib.Sound),

    pub fn init(allocator: std.mem.Allocator) !AudioManager {
        var sounds = std.AutoHashMap(AudioTag, raylib.Sound).init(allocator);
        errdefer sounds.deinit();

        const jump = try raylib.loadSound(
            AUDIO_DIR ++ "lumora_studios-pixel-jump-319167.mp3",
        );
        errdefer raylib.unloadSound(jump);

        const coin = try raylib.loadSound(
            AUDIO_DIR ++ "ring.wav",
        );
        errdefer raylib.unloadSound(coin);

        const hit = try raylib.loadSound(
            AUDIO_DIR ++ "destroy.wav",
        );
        errdefer raylib.unloadSound(hit);

        const stomp = try raylib.loadSound(
            AUDIO_DIR ++ "hyper-ring.wav",
        );
        errdefer raylib.unloadSound(stomp);

        try sounds.put(AudioTag.jump, jump);
        try sounds.put(AudioTag.coin, coin);
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
