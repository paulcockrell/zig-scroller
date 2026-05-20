const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const gravity = @import("../systems/physics/gravity.zig");
const jump = @import("../systems/movement/jump.zig");
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
const popup_points = @import("../systems/rendering/popup_points.zig");
const AudioTag = @import("../resources/audio_tag.zig").AudioTag;

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

pub fn update(world: *ecs.World, delta: f32) void {
    world.game.time += delta;

    if (world.game.jump_intent) jumpPlayer(world);

    collision.system(world);
    jump_intent.system(world);
    gravity.system(world, delta);
    jump.system(world, delta);
    scroll.system(world, delta);
    entity_wrap.system(world);
    entity_reset.system(world);
    scenery_wrap.system(world);
    difficulty.system(world);
    sound_intent.system(world);
}

pub fn render(world: *ecs.World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);

    sprite.system(world, delta);
    hud.system(world);
    popup_points.system(world, delta);
}

fn jumpPlayer(
    world: *ecs.World,
) void {
    var it = world.ecs.players.iterator();
    while (it.next()) |entry| {
        const ent = entry.key_ptr.*;

        if (player.isJumping(world, ent)) return;

        world.game.jump_intents.put(ent, .{ .force = JUMP_FORCE }) catch |err| {
            std.debug.print("Entity jump intent failed {}\n", .{err});
        };

        world.game.sound_intents.put(AudioTag.jump, .{ .volume = 0.3 }) catch |err| {
            std.debug.print("Jump sound intent failed {}\n", .{err});
        };
    }
}
