const std = @import("std");
const ecs = @import("../../engine/ecs.zig");
const World = @import("../game.zig").World;
const background = @import("../../game/entities/background.zig");
const platform = @import("../../game/entities/background.zig");
const enemy_entity = @import("../entities/enemy.zig");

pub fn system(world: *World) void {
    var it = world.game.needs_reset.iterator();

    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        if (world.ecs.enemies.contains(ent)) {
            resetEnemy(world, ent);
        }

        if (world.ecs.coins.contains(ent)) {
            resetPos(world, ent);
        }
    }

    world.game.needs_reset.clearRetainingCapacity();
}

fn resetEnemy(world: *World, ent: ecs.Entity) void {
    resetPos(world, ent);

    const health = world.ecs.health.getPtr(ent) orelse return;
    health.* = enemy_entity.MAX_HEALTH;
}

pub fn resetPos(world: *World, ent: ecs.Entity) void {
    var farthest_enemy_x: f32 = 0.0;
    var it = world.ecs.enemies.iterator();

    while (it.next()) |entry| {
        const enemy_ent = entry.key_ptr.*;

        if (enemy_ent == ent) continue;

        if (world.ecs.positions.getPtr(enemy_ent)) |enemy_pos| {
            if (enemy_pos.x > farthest_enemy_x) {
                farthest_enemy_x = enemy_pos.x;
            }
        }
    }

    const spawn_base = @max(
        farthest_enemy_x,
        @as(f32, @floatFromInt(world.game.screen_width)),
    );

    const pos = world.ecs.positions.getPtr(ent) orelse return;
    pos.x = spawn_base + @as(f32, @floatFromInt(world.game.rng(0, 1000)));
}
