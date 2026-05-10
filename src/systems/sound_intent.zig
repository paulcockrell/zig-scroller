const ecs = @import("../ecs.zig");
const std = @import("std");
const raylib = @import("raylib");

pub fn system(world: *ecs.World) void {
    ecs.Query.sound_intents(world, play_sound);
    world.sound_intents.clearRetainingCapacity();
}

fn play_sound(
    sound_tag: ecs.SoundTag,
    sound_params: *ecs.SoundParams,
    world: *ecs.World,
) void {
    const sound = world.sounds.get(sound_tag);
    if (sound) |s| {
        raylib.setSoundVolume(s, sound_params.volume);
        raylib.playSound(s);
    } else {
        std.debug.print("Couldn't find sound with tag {}\n", .{sound_tag});
    }
}
