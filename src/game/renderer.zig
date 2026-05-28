const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../engine/ecs.zig");
const TextureTag = @import("../engine/assets//texture_tags.zig").TextureTag;
const World = @import("game.zig").World;

pub fn renderEntity(
    world: *World,
    ent: ecs.Entity,
    texture_tag: TextureTag,
    delta: f32,
) void {
    const texture = world.resources.texture_manager.get(texture_tag) orelse return;
    const anim = world.ecs.animations.getPtr(ent) orelse return;
    const pos = world.ecs.positions.getPtr(ent) orelse return;
    const dim = world.ecs.dimensions.getPtr(ent) orelse return;
    const src_x = @as(f32, @floatFromInt(anim.frame_idx)) * dim.width;
    const src_y: f32 = 0.0;

    processAnimation(anim, delta);

    drawTexture(
        src_x,
        src_y,
        dim,
        pos,
        texture,
    );
}

pub fn processAnimation(anim: *ecs.Animation, delta: f32) void {
    if (anim.frame_count <= 1) return;

    anim.animation_timer += delta;
    if (anim.animation_timer >= anim.frame_duration) {
        anim.animation_timer -= anim.frame_duration;
        anim.frame_idx += 1;
        if (anim.frame_idx >= anim.frame_count) anim.frame_idx = 0;
    }
}

pub fn drawTexture(
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
