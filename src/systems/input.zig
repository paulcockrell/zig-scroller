const raylib = @import("raylib");
const ecs = @import("../ecs.zig");

pub fn system(world: *ecs.World) void {
    if (!raylib.isKeyPressed(raylib.KeyboardKey.space)) return;

    ecs.Query.players(world, {}, spaceInput);
}

fn spaceInput(
    _: void,
    _: ecs.Entity,
    _: *ecs.Position,
    vel: *ecs.Velocity,
    _: *ecs.Dimension,
    _: *ecs.World,
) void {
    vel.dy = -100; //jump force
}
