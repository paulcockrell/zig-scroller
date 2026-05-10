const ecs = @import("../ecs.zig");
const std = @import("std");
const raylib = @import("raylib");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.backgrounds(
        world,
        {},
        backgroundRenderer,
    );
    ecs.Query.platforms(
        world,
        {},
        platformRenderer,
    );
    ecs.Query.players(
        world,
        delta,
        playerRenderer,
    );
    ecs.Query.enemies(
        world,
        {},
        enemyRenderer,
    );
    ecs.Query.rings(
        world,
        {},
        ringRenderer,
    );
}

fn playerRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    anim.animation_timer += delta;
    if (anim.animation_timer >= anim.frame_duration) {
        anim.current_frame += 1;
        if (anim.current_frame + 1 > anim.frame_count) anim.current_frame = 0;
    }
    const player_texture = world.sprites.getEntry(ecs.SpriteTag.player) orelse return;
    const texture = player_texture.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        0.0 + (@as(f32, @floatFromInt(anim.current_frame + 1)) * dim.width),
        0.0,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
}

fn enemyRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const enemy_texture = world.sprites.getEntry(ecs.SpriteTag.enemy) orelse return;
    const texture = enemy_texture.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        0.0,
        0.0,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
}

fn ringRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const ring_texture = world.sprites.getEntry(ecs.SpriteTag.ring) orelse return;
    const texture = ring_texture.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        0.0,
        0.0,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
}

fn platformRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const platform_texture = world.sprites.getEntry(ecs.SpriteTag.platform) orelse return;
    const texture = platform_texture.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        0.0,
        0.0,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
}

fn backgroundRenderer(
    _: void,
    _: ecs.Entity,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    const background_texture = world.sprites.getEntry(ecs.SpriteTag.background) orelse return;
    const texture = background_texture.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        0.0,
        0.0,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
}
