const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const player = @import("../../entities/player.zig");

pub fn system(world: *ecs.World) void {
    if (raylib.isKeyPressed(raylib.KeyboardKey.space)) {
        world.confirm_intent = true;
    }

    if (raylib.isKeyPressed(raylib.KeyboardKey.c)) {
        world.credits_intent = true;
    }
}

pub fn resetInput(world: *ecs.World) void {
    world.confirm_intent = false;
    world.credits_intent = false;
}
