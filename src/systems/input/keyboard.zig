const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const player = @import("../../entities/player.zig");

pub fn system(world: *ecs.World) void {
    if (raylib.isKeyPressed(raylib.KeyboardKey.space)) {
        world.jump_intent = true;
    }

    if (raylib.isKeyPressed(raylib.KeyboardKey.c)) {
        world.confirm_intent = true;
    }
}

pub fn resetInput(world: *ecs.World) void {
    world.jump_intent = false;
    world.confirm_intent = false;
}
