const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const player = @import("../../entities/player.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn system(world: *ecs.World) void {
    if (raylib.isKeyPressed(raylib.KeyboardKey.space)) {
        world.confirm_intent = true;
    }

    if (raylib.isKeyPressed(raylib.KeyboardKey.q)) {
        world.quit_intent = true;
    }

    if (raylib.isKeyPressed(raylib.KeyboardKey.c)) {
        world.credits_intent = true;
    }
}

pub fn resetInput(world: *ecs.World) void {
    world.confirm_intent = false;
    world.quit_intent = false;
    world.credits_intent = false;
}

// fn playerInput(
//     _: void,
//     ent: ecs.Entity,
//     _: *ecs.Animation,
//     _: *ecs.Position,
//     _: *ecs.Velocity,
//     _: *ecs.Dimension,
//     world: *ecs.World,
// ) void {
//     if (player.isJumping(world, ent)) return;
//
//     world.jump_intents.put(ent, .{ .force = JUMP_FORCE }) catch |err| {
//         std.debug.print("Entity jump intent failed {}\n", .{err});
//     };
//
//     world.sound_intents.put(ecs.SoundTag.jump, .{ .volume = 0.3 }) catch |err| {
//         std.debug.print("Jump sound intent failed {}\n", .{err});
//     };
// }
