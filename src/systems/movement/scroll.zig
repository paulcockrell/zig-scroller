const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    enemiesScroll(world, delta);
    ringsScroll(world, delta);
    backgroundsScroll(world, delta);
    platformsScroll(world, delta);
}

fn enemiesScroll(world: *ecs.World, delta: f32) void {
    var it = world.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.positions.getPtr(ent) orelse return;
        const vel = world.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn ringsScroll(world: *ecs.World, delta: f32) void {
    var it = world.rings.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.positions.getPtr(ent) orelse return;
        const vel = world.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn backgroundsScroll(world: *ecs.World, delta: f32) void {
    var it = world.backgrounds.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.positions.getPtr(ent) orelse return;
        const vel = world.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn platformsScroll(world: *ecs.World, delta: f32) void {
    var it = world.platforms.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.positions.getPtr(ent) orelse return;
        const vel = world.velocities.getPtr(ent) orelse return;

        scroll(world, pos, vel, delta);
    }
}

fn scroll(
    world: *ecs.World,
    pos: *ecs.Position,
    vel: *ecs.Velocity,
    delta: f32,
) void {
    pos.x -= world.scroll_speed * vel.dx * delta;
}
