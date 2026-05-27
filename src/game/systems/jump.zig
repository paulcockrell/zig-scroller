const std = @import("std");
const ecs = @import("../../engine/ecs/ecs.zig");
const World = @import("../world.zig").World;
const background = @import("../../game/entities/background.zig");
const player = @import("../../game/entities/player.zig");

pub fn system(world: *World, delta: f32) void {
    movePlayers(world, delta);
}

fn movePlayers(world: *World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse return;
        const dim = world.ecs.dimensions.getPtr(ent) orelse return;
        const vel = world.ecs.velocities.getPtr(ent) orelse return;

        playerMovement(world, pos, vel, dim, delta);
        backgroundMovement(world, pos);
    }
}

fn playerMovement(
    world: *World,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    delta: f32,
) void {
    pos.y += vel.dy * delta;

    if (vel.dy > 0.0) { // falling
        if (pos.y > world.game.groundY() - dim.height) { // below ground
            pos.y = world.game.groundY() - dim.height;
            vel.dy = 0;
        }
    }
}

// Moves the background inline with player jumping to give nice effect
fn backgroundMovement(
    world: *World,
    player_pos: *ecs.Position,
) void {
    var it = world.ecs.backgrounds.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse return;

        pos.y = (player_pos.y + player.HEIGHT - world.game.groundY()) / 2.5;
    }
}
