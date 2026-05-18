const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const Resources = @import("../systems/resources/resources.zig").Resources;

pub const Query = struct {
    pub fn sounds(
        world: *ecs.World,
        func: fn (
            sound_tag: ecs.SoundTag,
            sound: *raylib.Sound,
            world: *ecs.World,
        ) void,
    ) void {
        var it = world.sounds.iterator();

        while (it.next()) |entry| {
            const sound_tag = entry.key_ptr.*;
            const sound = entry.value_ptr;

            func(
                sound_tag,
                sound,
                world,
            );
        }
    }
};
