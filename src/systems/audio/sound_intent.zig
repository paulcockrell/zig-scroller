const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const Resources = @import("../../resources/resources.zig").Resources;

pub fn system(world: *ecs.World, resources: *Resources) void {
    var it = world.sound_intents.iterator();

    while (it.next()) |entry| {
        const audio_tag = entry.key_ptr.*;
        const audio_params = entry.value_ptr;
        const sound = resources.audio.sounds.get(audio_tag);

        if (sound) |s| {
            raylib.setSoundVolume(s, audio_params.volume);
            raylib.playSound(s);
        } else {
            std.debug.print("Couldn't find sound with audio tag {}\n", .{audio_tag});
        }
    }

    world.sound_intents.clearRetainingCapacity();
}
