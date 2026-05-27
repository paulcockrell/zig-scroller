const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../world.zig").World;
const Scene = @import("../world.zig").Scene;
const AudioTag = @import("../../engine/assets/audio_tags.zig").AudioTag;

const JUMP_FORCE: f32 = -250.0;
const RING_SCORE: i32 = 1;
const ENEMY_STOMP: i32 = 10;

const EntityBundle = struct {
    ent: ecs.Entity,
    pos: *ecs.Position,
    dim: *ecs.Dimension,
    vel: ?*ecs.Velocity = null,
};

pub fn system(world: *World) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;
        const vel = world.ecs.velocities.getPtr(ent) orelse continue;

        const player = EntityBundle{
            .ent = ent,
            .pos = pos,
            .dim = dim,
            .vel = vel,
        };

        checkPlayerCollision(world, &player);
    }
}

fn checkPlayerCollision(
    world: *World,
    player: *const EntityBundle,
) void {
    handleEnemies(world, player);
    handleRings(world, player);
}

fn handleEnemies(
    world: *World,
    player: *const EntityBundle,
) void {
    var it = world.ecs.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;

        const enemy = EntityBundle{
            .ent = ent,
            .pos = pos,
            .dim = dim,
        };

        checkEnemyStomp(
            world,
            player,
            &enemy,
        );

        checkEnemyCollision(
            world,
            player,
            &enemy,
        );
    }
}

fn handleRings(
    world: *World,
    player: *const EntityBundle,
) void {
    var it = world.ecs.rings.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;

        const ring = EntityBundle{
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
    world: *World,
    player: *const EntityBundle,
    enemy: *const EntityBundle,
) void {
    if (!enemyAttack(world, player, enemy)) return;

    _ = world.game.addScore(ENEMY_STOMP);

    world.game.jump_intents.put(player.ent, .{ .force = JUMP_FORCE }) catch |err| {
        std.debug.print("Entity jump intent failed {}\n", .{err});
    };

    world.game.needs_reset.put(enemy.ent, {}) catch |err| {
        std.debug.print("Entity reset failed {}\n", .{err});
    };

    world.game.sound_intents.put(AudioTag.stomp, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Stomp sound intent failed {}\n", .{err});
    };
}

fn checkEnemyCollision(
    world: *World,
    player: *const EntityBundle,
    enemy: *const EntityBundle,
) void {
    if (!overlap(player, enemy)) return;
    if (enemyAttack(world, player, enemy)) return;

    const health = world.game.updateHealth(1);

    world.game.needs_reset.put(enemy.ent, {}) catch |err| {
        std.debug.print("Entity reset failed {}\n", .{err});
    };

    world.game.sound_intents.put(AudioTag.hit, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Hit sound intent failed {}\n", .{err});
    };

    if (health <= 0) {
        world.game.changeScene(Scene.game_over) catch |err| {
            std.debug.print("Failed to change to scene 'game_over' {}\n", .{err});
        };
    }
}

fn checkRingCollision(
    world: *World,
    player: *const EntityBundle,
    ring: *const EntityBundle,
) void {
    if (!overlap(player, ring)) return;

    world.game.addScore(RING_SCORE);

    world.game.needs_reset.put(ring.ent, {}) catch |err| {
        std.debug.print("Entity reset failed {}\n", .{err});
    };

    world.game.sound_intents.put(AudioTag.ring, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Ring sound intent failed {}\n", .{err});
    };
}

fn enemyAttack(
    world: *World,
    player: *const EntityBundle,
    enemy: *const EntityBundle,
) bool {
    // player is jumping while colliding with enemy
    return (player.pos.y + player.dim.height) < world.game.groundY() and overlap(player, enemy);
}

fn overlap(
    player: *const EntityBundle,
    other: *const EntityBundle,
) bool {
    return !(player.pos.x + player.dim.width < other.pos.x or
        player.pos.x > other.pos.x + other.dim.width or
        player.pos.y + player.dim.height < other.pos.y or
        player.pos.y > other.pos.y + other.dim.height);
}
