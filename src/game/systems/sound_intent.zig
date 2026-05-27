const std = @import("std");
const raylib = @import("raylib");
const World = @import("../world.zig").World;

pub fn system(world: *World) void {
    var it = world.game.sound_intents.iterator();

    while (it.next()) |entry| {
        const audio_tag = entry.key_ptr.*;
        const audio_params = entry.value_ptr;
        const sound = world.resources.audio_manager.sounds.get(audio_tag);

        if (sound) |s| {
            raylib.setSoundVolume(s, audio_params.volume);
            raylib.playSound(s);
        } else {
            std.debug.print("Couldn't find sound with audio tag {}\n", .{audio_tag});
        }
    }

    world.game.sound_intents.clearRetainingCapacity();
}
