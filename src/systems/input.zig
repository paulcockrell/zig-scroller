const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const std = @import("std");

const JUMP_FORCE: f32 = -250.0;

pub fn system(world: *ecs.World) void {
    if (!raylib.isKeyPressed(raylib.KeyboardKey.space)) return;

    ecs.Query.players(world, {}, playerInput);
}

fn playerInput(
    _: void,
    ent: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (pos.y + dim.height < ecs.groundY(world)) return; // already in jump

    world.jump_intents.put(ent, .{ .force = JUMP_FORCE }) catch |err| {
        std.debug.print("Entity jump intent failed {}\n", .{err});
    };
}
