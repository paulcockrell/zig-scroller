const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");
const player = @import("../../entities/player.zig");
const TextureTag = @import("../../resources/texture_tags.zig").TextureTag;

pub fn system(world: *ecs.World, delta: f32) void {
    renderBackgrounds(world, delta);
    renderPlatforms(world, delta);
    renderPlayers(world, delta);
    renderEnemies(world, delta);
    renderRings(world, delta);
}

fn renderBackgrounds(world: *ecs.World, delta: f32) void {
    var it = world.ecs.backgrounds.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        render(
            world,
            ent,
            TextureTag.background,
            delta,
        );
    }
}

fn renderPlatforms(world: *ecs.World, delta: f32) void {
    var it = world.ecs.platforms.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        render(
            world,
            ent,
            TextureTag.platform,
            delta,
        );
    }
}

fn renderEnemies(world: *ecs.World, delta: f32) void {
    var it = world.ecs.enemies.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        render(
            world,
            ent,
            TextureTag.enemy,
            delta,
        );
    }
}

fn renderRings(world: *ecs.World, delta: f32) void {
    var it = world.ecs.rings.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        render(
            world,
            ent,
            TextureTag.ring,
            delta,
        );
    }
}

fn renderPlayers(world: *ecs.World, delta: f32) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        renderPlayer(
            world,
            ent,
            delta,
        );
    }
}

fn renderPlayer(
    world: *ecs.World,
    ent: ecs.Entity,
    delta: f32,
) void {
    const anim = world.ecs.animations.getPtr(ent) orelse return;
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return;
    const texture = world.resources.textures.get(TextureTag.player) orelse return;
    const src_x = @as(f32, @floatFromInt(anim.frame_idx)) * dim.width;
    const src_y =
        if (player.isJumping(world, ent))
            dim.height
        else
            0.0;

    processAnimation(anim, delta);

    spriteRenderer(
        src_x,
        src_y,
        dim,
        pos,
        texture,
    );
}

fn render(
    world: *ecs.World,
    ent: ecs.Entity,
    texture_tag: TextureTag,
    delta: f32,
) void {
    const texture = world.resources.textures.get(texture_tag) orelse return;
    const anim = world.ecs.animations.getPtr(ent) orelse return;
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return;
    const src_x = @as(f32, @floatFromInt(anim.frame_idx)) * dim.width;
    const src_y: f32 = 0.0;

    processAnimation(anim, delta);

    spriteRenderer(
        src_x,
        src_y,
        dim,
        pos,
        texture,
    );
}

fn processAnimation(anim: *ecs.Animation, delta: f32) void {
    if (anim.frame_count <= 1) return;

    anim.animation_timer += delta;
    if (anim.animation_timer >= anim.frame_duration) {
        anim.animation_timer -= anim.frame_duration;
        anim.frame_idx += 1;
        if (anim.frame_idx >= anim.frame_count) anim.frame_idx = 0;
    }
}

fn spriteRenderer(
    src_x: f32,
    src_y: f32,
    dim: *ecs.Dimension,
    pos: *ecs.Position,
    texture: *raylib.Texture,
) void {
    const rl_rect = raylib.Rectangle.init(
        src_x,
        src_y,
        dim.width,
        dim.height,
    );
    const rl_pos = raylib.Vector2.init(
        pos.x,
        pos.y,
    );

    raylib.drawTextureRec(
        texture.*,
        rl_rect,
        rl_pos,
        .white,
    );
}
