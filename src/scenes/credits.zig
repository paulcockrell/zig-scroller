const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub fn enter(world: *ecs.World) void {
    _ = world;
}

pub fn exit(world: *ecs.World) void {
    world.reset();
}

pub fn update(world: *ecs.World, delta: f32) void {
    _ = world;
    _ = delta;
}

pub fn render(world: *ecs.World, delta: f32) void {
    _ = world;
    _ = delta;
}
