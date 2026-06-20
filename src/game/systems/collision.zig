const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;
const Scene = @import("../game.zig").Scene;
const AudioTag = @import("../../engine/assets/audio_tags.zig").AudioTag;
const Player = @import("../entities/player.zig");
const Enemy = @import("../entities/enemy.zig");

const JUMP_FORCE: f32 = -250.0;
const COIN_SCORE: i32 = 1;
const ENEMY_STOMP: i32 = 10;

pub fn system(world: *World) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;
        const vel = world.ecs.velocities.getPtr(ent) orelse continue;

        const player = ecs.EntityBundle{
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
    player: *const ecs.EntityBundle,
) void {
    handleGround(world, player);
    handleEnemies(world, player);
    handleCoins(world, player);
}

fn handleGround(world: *World, player: *const ecs.EntityBundle) void {
    if (player.pos.y + player.dim.height > world.game.groundY()) {
        player.pos.y = world.game.groundY();
    }
}

fn handleEnemies(
    world: *World,
    player: *const ecs.EntityBundle,
) void {
    var it = world.ecs.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;

        const enemy = ecs.EntityBundle{
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

fn handleCoins(
    world: *World,
    player: *const ecs.EntityBundle,
) void {
    var it = world.ecs.coins.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;
        const pos = world.ecs.positions.getPtr(ent) orelse continue;
        const dim = world.ecs.dimensions.getPtr(ent) orelse continue;

        const coin = ecs.EntityBundle{
            .ent = ent,
            .pos = pos,
            .dim = dim,
        };

        checkCoinCollision(
            world,
            player,
            &coin,
        );
    }
}

fn checkEnemyStomp(
    world: *World,
    player: *const ecs.EntityBundle,
    enemy: *const ecs.EntityBundle,
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
    player: *const ecs.EntityBundle,
    enemy: *const ecs.EntityBundle,
) void {
    if (!overlap(player, enemy)) return;
    if (enemyAttack(world, player, enemy)) return;

    if (world.ecs.health.getPtr(player.ent)) |player_health| {
        player_health.* -= 1;

        if (player_health.* == 0) {
            world.game.changeScene(Scene.game_over) catch |err| {
                std.debug.print("Failed to change to scene 'game_over' {}\n", .{err});
            };

            return;
        }
    }

    if (world.ecs.health.getPtr(enemy.ent)) |enemy_health| {
        enemy_health.* -= 1;

        if (enemy_health.* == 0) {
            world.game.needs_reset.put(enemy.ent, {}) catch |err| {
                std.debug.print("Entity reset failed {}\n", .{err});
            };

            world.game.sound_intents.put(AudioTag.hit, .{ .volume = 0.3 }) catch |err| {
                std.debug.print("Hit sound intent failed {}\n", .{err});
            };
        }
    }
}

fn checkCoinCollision(
    world: *World,
    player: *const ecs.EntityBundle,
    coin: *const ecs.EntityBundle,
) void {
    if (!overlap(player, coin)) return;

    world.game.addScore(COIN_SCORE);

    world.game.needs_reset.put(coin.ent, {}) catch |err| {
        std.debug.print("Entity reset failed {}\n", .{err});
    };

    world.game.sound_intents.put(AudioTag.coin, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Coin sound intent failed {}\n", .{err});
    };
}

fn enemyAttack(
    world: *World,
    player: *const ecs.EntityBundle,
    enemy: *const ecs.EntityBundle,
) bool {
    // player is jumping while colliding with enemy
    return (player.pos.y + player.dim.height) < world.game.groundY() and overlap(player, enemy);
}

fn overlap(
    player: *const ecs.EntityBundle,
    other: *const ecs.EntityBundle,
) bool {
    return !(player.pos.x + player.dim.width < other.pos.x or
        player.pos.x > other.pos.x + other.dim.width or
        player.pos.y + player.dim.height < other.pos.y or
        player.pos.y > other.pos.y + other.dim.height);
}
