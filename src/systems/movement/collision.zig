const std = @import("std");
const ecs = @import("../../ecs.zig");

const JUMP_FORCE: f32 = -250.0;
const RING_SCORE: i32 = 1;
const ENEMY_STOMP: i32 = 10;

const EntityBundle = struct {
    ent: ecs.Entity,
    pos: *ecs.Position,
    dim: *ecs.Dimension,
    vel: ?*ecs.Velocity = null,
};

pub fn system(world: *ecs.World) void {
    var it = world.players.iterator();
    while (it.next()) |ent| {
        const pos = world.positions.getPtr(ent) orelse continue;
        const dim = world.dimensions.getPtr(ent) orelse continue;
        const vel = world.velocities.getPtr(ent) orelse continue;

        const player = .{
            .ent = ent,
            .pos = pos,
            .dim = dim,
            .vel = vel,
        };

        checkPlayerCollision(world, &player);
    }
}

fn checkPlayerCollision(
    world: *ecs.World,
    player: *EntityBundle,
) void {
    handleEnemies(world, player);
    handleRings(world, player);
}

fn handleEnemies(world: *ecs.World, player: *EntityBundle) void {
    var it = world.enemies.iterator();
    while (it.next()) |ent| {
        const pos = world.positions.getPtr(ent) orelse continue;
        const dim = world.dimensions.getPtr(ent) orelse continue;

        const enemy = .{
            .ent = ent,
            .pos = pos,
            .dim = dim,
        };

        if (checkEnemyStomp(
            world,
            player,
            &enemy,
        )) continue;

        checkEnemyCollision(
            world,
            player,
            &enemy,
        );
    }
}

fn handleRings(world: *ecs.World, player: *EntityBundle) void {
    var it = world.rings.iterator();
    while (it.next()) |ent| {
        const pos = world.positions.getPtr(ent) orelse continue;
        const dim = world.dimensions.getPtr(ent) orelse continue;

        const ring = .{
            .ent = ent,
            .pos = pos,
            .dim = dim,
        };

        checkRingCollision(
            world,
            player,
            &ring,
        );
    }
}

fn checkEnemyStomp(
    world: *ecs.World,
    player: *EntityBundle,
    enemy: *EntityBundle,
) bool {
    if (enemyStomp(
        player,
        enemy,
    )) {
        _ = world.updateAndDisplayScore(ENEMY_STOMP);

        world.jump_intents.put(player.ent, .{ .force = JUMP_FORCE }) catch |err| {
            std.debug.print("Entity jump intent failed {}\n", .{err});
        };

        world.needs_reset.put(enemy.ent, {}) catch |err| {
            std.debug.print("Entity reset failed {}\n", .{err});
        };

        world.sound_intents.put(ecs.SoundTag.stomp, .{ .volume = 0.3 }) catch |err| {
            std.debug.print("Stomp sound intent failed {}\n", .{err});
        };

        return true;
    }

    return false;
}

fn checkEnemyCollision(
    world: *ecs.World,
    player: *EntityBundle,
    enemy: *EntityBundle,
) void {
    if (!overlap(player, enemy)) return;

    const health = world.updateHealth(1);

    world.needs_reset.put(enemy.ent, {}) catch |err| {
        std.debug.print("Entity reset failed {}\n", .{err});
    };

    world.sound_intents.put(ecs.SoundTag.hit, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Hit sound intent failed {}\n", .{err});
    };

    if (health <= 0) {
        world.changeScene(ecs.Scene.game_over) catch |err| {
            std.debug.print("Failed to change to scene 'game_over' {}\n", .{err});
        };
    }
}

fn checkRingCollision(
    world: *ecs.World,
    player: *EntityBundle,
    ring: *EntityBundle,
) void {
    if (!overlap(player, ring)) return;

    _ = world.updateAndDisplayScore(RING_SCORE);

    world.needs_reset.put(ring.ent, {}) catch |err| {
        std.debug.print("Entity reset failed {}\n", .{err});
    };

    world.sound_intents.put(ecs.SoundTag.ring, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Ring sound intent failed {}\n", .{err});
    };
}

fn enemyStomp(
    player: *EntityBundle,
    enemy: *EntityBundle,
) bool {
    const player_bottom = player.pos.y + player.dim.height;
    const enemy_top = enemy.pos.y;

    return player.vel.?.y > 0 and
        player_bottom <= enemy_top + 10 and
        overlap(player, enemy);
}

fn overlap(
    player: *EntityBundle,
    other: *EntityBundle,
) bool {
    return !(player.pos.x + player.dim.width < other.pos.x or
        player.pos.x > other.pos.x + other.dim.width or
        player.pos.y + player.dim.height < other.pos.y or
        player.pos.y > other.pos.y + other.dim.height);
}
