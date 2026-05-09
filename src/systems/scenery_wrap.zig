const ecs = @import("../ecs.zig");
const std = @import("std");
const background = @import("../entities/background.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.backgrounds(
        world,
        delta,
        backgroundWrap,
    );
}

fn backgroundWrap(
    _: f32,
    ent: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    var bg_it = world.backgrounds.iterator();
    while (bg_it.next()) |bg_ent| {
        const ent2 = bg_ent.key_ptr.*;
        if (ent == ent2) continue;

        const bg_pos = world.positions.getPtr(ent2);
        if (bg_pos) |bg_p| {
            if (pos.x < 0) bg_p.x = pos.x + background.WIDTH;
        }
    }
}
