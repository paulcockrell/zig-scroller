const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;

pub fn system(world: *World, delta: f32) void {
    enemiesScroll(world, delta);
    coinsScroll(world, delta);
    backgroundsScroll(world, delta);
    platformsScroll(world, delta);
}

fn enemiesScroll(world: *World, delta: f32) void {
    var it = world.ecs.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse return;
        const vel = world.ecs.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn coinsScroll(world: *World, delta: f32) void {
    var it = world.ecs.coins.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse return;
        const vel = world.ecs.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn backgroundsScroll(world: *World, delta: f32) void {
    var it = world.ecs.backgrounds.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse return;
        const vel = world.ecs.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn platformsScroll(world: *World, delta: f32) void {
    var it = world.ecs.platforms.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse return;
        const vel = world.ecs.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn scroll(
    world: *World,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    delta: f32,
) void {
    pos.x -= world.game.scroll_speed * vel.dx * delta;
}
