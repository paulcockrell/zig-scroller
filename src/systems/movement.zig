const ecs = @import("../ecs.zig");
const std = @import("std");
const background = @import("../entities/background.zig");
const player = @import("../entities/player.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.players(world, delta, movement);
}

fn movement(
    dt: f32,
    ent: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    playerMovement(
        dt,
        ent,
        anim,
        pos,
        vel,
        dim,
        world,
    );

    backgroundMovement(
        pos,
        world,
    );
}

fn playerMovement(
    dt: f32,
    _: ecs.Entity,
    _: *ecs.Animation,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    pos.y += vel.dy * dt;

    if (vel.dy > 0.0) { // falling
        if (pos.y > ecs.groundY(world) - dim.height) { // below ground
            pos.y = ecs.groundY(world) - dim.height;
            vel.dy = 0;
        }
    }
}

fn backgroundMovement(
    pos: *ecs.Position,
    world: *ecs.World,
) void {
    ecs.Query.backgrounds(world, pos, updateBackgroundY);
}

fn updateBackgroundY(
    ctx: *ecs.Position,
    _: u32,
    _: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    pos.y = background.DEFAULT_Y - ((ctx.y + player.HEIGHT - ecs.groundY(world)) / 2.5);
}
