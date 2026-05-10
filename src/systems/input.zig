const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const std = @import("std");
const player = @import("../entities/player.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn system(world: *ecs.World) void {
    if (!raylib.isKeyPressed(raylib.KeyboardKey.space)) return;

    ecs.Query.players(world, {}, playerInput);
}

fn playerInput(
    _: void,
    ent: ecs.Entity,
    _: *ecs.Animation,
    _: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (player.isJumping(world, ent)) return;

    world.jump_intents.put(ent, .{ .force = JUMP_FORCE }) catch |err| {
        std.debug.print("Entity jump intent failed {}\n", .{err});
    };

    world.sound_intents.put(ecs.SoundTag.jump, {}) catch |err| {
        std.debug.print("Jump sound intent failed {}\n", .{err});
    };
}
