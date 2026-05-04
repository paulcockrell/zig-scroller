const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    var it = world.velocities.iterator();

    while (it.next()) |entry| {
        entry.value_ptr.dy += 100 * delta; //gravity
    }
}
