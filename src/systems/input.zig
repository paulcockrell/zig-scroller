const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const std = @import("std");

const JUMP_FORCE: f32 = -500.0;

pub fn system(world: *ecs.World) void {
    if (!raylib.isKeyPressed(raylib.KeyboardKey.space)) return;

    ecs.Query.players(world, {}, spaceInput);
}

fn spaceInput(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (pos.y < ecs.groundY(world)) return;

    vel.dy = JUMP_FORCE;
}
