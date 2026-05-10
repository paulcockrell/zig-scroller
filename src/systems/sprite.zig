const ecs = @import("../ecs.zig");
const std = @import("std");
const raylib = @import("raylib");
const player = @import("../entities/player.zig");

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
    process_animation(anim, delta);

    const rect_x =
        0.0 + (@as(f32, @floatFromInt(anim.current_frame + 1)) * dim.width);

    const rect_y =
        if (player.isJumping(world, ent)) rect_y: {
            break :rect_y dim.height;
        } else rect_y: {
            break :rect_y 0.0;
        };

    const player_texture = world.sprites.getEntry(ecs.SpriteTag.player) orelse return;
    const texture = player_texture.value_ptr.*;
    const rl_rect = raylib.Rectangle.init(
        rect_x,
        rect_y,
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
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    process_animation(anim, delta);

    const enemy_texture = world.sprites.getEntry(ecs.SpriteTag.enemy) orelse return;
    const texture = enemy_texture.value_ptr.*;
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

fn ringRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    process_animation(anim, delta);

    const ring_texture = world.sprites.getEntry(ecs.SpriteTag.ring) orelse return;
    const texture = ring_texture.value_ptr.*;
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

fn platformRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    process_animation(anim, delta);

    const platform_texture = world.sprites.getEntry(ecs.SpriteTag.platform) orelse return;
    const texture = platform_texture.value_ptr.*;
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

fn backgroundRenderer(
    delta: f32,
    _: ecs.Entity,
    anim: *ecs.Animation,
    pos: *ecs.Position,
    _: *ecs.Velocity,
    dim: *ecs.Dimension,
    world: *ecs.World,
) void {
    process_animation(anim, delta);

    const background_texture = world.sprites.getEntry(ecs.SpriteTag.background) orelse return;
    const texture = background_texture.value_ptr.*;
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

fn process_animation(anim: *ecs.Animation, delta: f32) void {
    if (anim.frame_count <= 1) return;

    anim.animation_timer += delta;
    if (anim.animation_timer >= anim.frame_duration) {
        anim.current_frame += 1;
        if (anim.current_frame + 1 > anim.frame_count) anim.current_frame = 0;
    }
}
