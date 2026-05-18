const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const gravity = @import("../systems/physics/gravity.zig");
const movement = @import("../systems/movement/movement.zig");
const collision = @import("../systems/movement/collision.zig");
const jump_intent = @import("../systems/movement/jump_intent.zig");
const difficulty = @import("../systems/gameplay/difficulty.zig");
const hud = @import("../systems/rendering/hud.zig");
const sprite = @import("../systems/rendering/sprite.zig");
const scroll = @import("../systems/movement/scroll.zig");
const entity_wrap = @import("../systems/movement/entity_wrap.zig");
const entity_reset = @import("../systems/gameplay/entity_reset.zig");
const scenery_wrap = @import("../systems/movement/scenery_wrap.zig");
const sound_intent = @import("../systems/audio/sound_intent.zig");
const player = @import("../entities/player.zig");
const enemy = @import("../entities/enemy.zig");
const ring = @import("../entities/ring.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");
const player_hud = @import("../systems/rendering/player_hud.zig");
const resource_system = @import("../systems/resources/resources.zig");

const Resources = resource_system.Resources;

const JUMP_FORCE: f32 = -250.0;

pub fn enter(world: *ecs.World) !void {
    try player.spawn(world);
    try platform.spawn(world);
    try background.spawn(world);
    for (0..3) |_| {
        try enemy.spawn(world);
    }
    for (0..2) |_| {
        try ring.spawn(world);
    }
}

pub fn exit(world: *ecs.World) void {
    _ = world;
}

pub fn update(world: *ecs.World, resources: *Resources, delta: f32) void {
    world.time += delta;

    if (world.jump_intent) {
        ecs.Query.players(world, resources, {}, jump);
    }

    collision.system(world);
    jump_intent.system(world);
    gravity.system(world, delta);
    movement.system(world, delta);
    scroll.system(world, delta);
    entity_wrap.system(world);
    entity_reset.system(world);
    scenery_wrap.system(world);
    difficulty.system(world);
    sound_intent.system(world);
}

pub fn render(world: *ecs.World, resources: *Resources, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);

    sprite.system(world, resources, delta);
    hud.system(world, resources);
    player_hud.system(world, resources, delta);
}

fn jump(
    _: void,
    ent: ecs.Entity,
    _: *ecs.Animation,
    _: *ecs.Position,
    _: *ecs.Velocity,
    _: *ecs.Dimension,
    world: *ecs.World,
) void {
    if (player.isJumping(world, ent)) return;

    world.jump_intents.put(ent, .{ .force = JUMP_FORCE }) catch |err| {
        std.debug.print("Entity jump intent failed {}\n", .{err});
    };

    world.sound_intents.put(ecs.SoundTag.jump, .{ .volume = 0.3 }) catch |err| {
        std.debug.print("Jump sound intent failed {}\n", .{err});
    };
}
