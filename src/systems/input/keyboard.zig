const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const player = @import("../../entities/player.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn system(world: *ecs.World) void {
    switch (world.scene) {
        ecs.Scene.main_menu => {
            if (raylib.isKeyPressed(raylib.KeyboardKey.space)) {
                ecs.changeScene(ecs.Scene.game_play, world) catch |err| {
                    std.debug.print("Failed to change to scene 'game_play' {}\n", .{err});
                };
            }
        },
        ecs.Scene.game_play => {
            if (raylib.isKeyPressed(raylib.KeyboardKey.space)) {
                ecs.Query.players(world, {}, playerInput);
            }
            if (raylib.isKeyPressed(raylib.KeyboardKey.q)) {
                ecs.changeScene(ecs.Scene.main_menu, world) catch |err| {
                    std.debug.print("Failed to change to scene 'main_menu' {}\n", .{err});
                };
            }
        },
        else => {
            std.debug.print("[INPUT] Unknown scene\n", .{});
        },
    }
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

    world.sound_intents.put(ecs.SoundTag.jump, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Jump sound intent failed {}\n", .{err});
    };
}
