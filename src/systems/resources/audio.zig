const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../../ecs.zig");

pub fn system(world: *ecs.World) !void {
    try load_jump_sound(world);
    try load_ring_sound(world);
    try load_hit_sound(world);
    try load_stomp_sound(world);
}

pub fn deinit(world: *ecs.World) void {
    ecs.Query.sounds(world, unload_sounds);
}

fn unload_sounds(_: ecs.SoundTag, sound: *raylib.Sound, _: *ecs.World) void {
    raylib.unloadSound(sound.*);
}

fn load_jump_sound(world: *ecs.World) !void {
    const jump = try raylib.loadSound("resources/audio/lumora_studios-pixel-jump-319167.mp3");
    try world.sounds.put(ecs.SoundTag.jump, jump);
}

fn load_ring_sound(world: *ecs.World) !void {
    const ring = try raylib.loadSound("resources/audio/ring.wav");
    try world.sounds.put(ecs.SoundTag.ring, ring);
}

fn load_hit_sound(world: *ecs.World) !void {
    const hit = try raylib.loadSound("resources/audio/destroy.wav");
    try world.sounds.put(ecs.SoundTag.hit, hit);
}

fn load_stomp_sound(world: *ecs.World) !void {
    const stomp = try raylib.loadSound("resources/audio/hyper-ring.wav");
    try world.sounds.put(ecs.SoundTag.stomp, stomp);
}
