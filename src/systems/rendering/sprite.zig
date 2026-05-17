const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const player = @import("../../entities/player.zig");

pub fn system(world: *ecs.World, delta: f32) void {
    ecs.Query.backgrounds(
        world,
        delta,
        backgroundRenderer,
    );
    ecs.Query.platforms(
        world,
        delta,
        platformRenderer,
    );
    ecs.Query.players(
        world,
        delta,
        playerRenderer,
    );
    ecs.Query.enemies(
        world,
        delta,
        enemyRenderer,
    );
    ecs.Query.rings(
        world,
        delta,
        ringRenderer,
    );
}

fn playerRenderer(
    delta: f32,
    ent: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    processAnimation(anim, delta);

    const x =
        0.0 + (@as(f32, @floatFromInt(anim.frame_idx)) * dim.width);

    const y =
        if (player.isJumping(world, ent)) rect_y: {
            break :rect_y dim.height;
        } else rect_y: {
            break :rect_y 0.0;
        };

    spriteRenderer(
        world,
        ecs.SpriteTag.player,
        x,
        y,
        dim,
        pos,
    );
}

fn enemyRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    processAnimation(anim, delta);
    spriteRenderer(
        world,
        ecs.SpriteTag.enemy,
        (@as(f32, @floatFromInt(anim.frame_idx + 1)) * dim.width),
        0.0,
        dim,
        pos,
    );
}

fn ringRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    processAnimation(anim, delta);
    spriteRenderer(
        world,
        ecs.SpriteTag.ring,
        (@as(f32, @floatFromInt(anim.frame_idx + 1)) * dim.width),
        0.0,
        dim,
        pos,
    );
}

fn platformRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    processAnimation(anim, delta);
    spriteRenderer(
        world,
        ecs.SpriteTag.platform,
        (@as(f32, @floatFromInt(anim.frame_idx + 1)) * dim.width),
        0.0,
        dim,
        pos,
    );
}

fn backgroundRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    processAnimation(anim, delta);
    spriteRenderer(
        world,
        ecs.SpriteTag.background,
        (@as(f32, @floatFromInt(anim.frame_idx + 1)) * dim.width),
        0.0,
        dim,
        pos,
    );
}

fn processAnimation(anim: *ecs.Animation, delta: f32) void {
    if (anim.frame_count <= 1) return;

    anim.animation_timer += delta;
    if (anim.animation_timer >= anim.frame_duration) {
        anim.animation_timer -= anim.frame_duration;
        anim.frame_idx += 1;
        if (anim.frame_idx + 1 > anim.frame_count) anim.frame_idx = 0;
    }
}

fn spriteRenderer(
    world: *ecs.World,
    sprite_tag: ecs.SpriteTag,
    x: f32,
    y: f32,
    dim: *ecs.Dimension,
    pos: *ecs.Position,
) void {
    const sprite_entry = world.sprites.getEntry(sprite_tag) orelse return;
    const texture = sprite_entry.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        x,
        y,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(texture, rl_rect, rl_pos, .white);
}
