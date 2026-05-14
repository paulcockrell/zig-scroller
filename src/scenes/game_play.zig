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
const scroll = @import("../systems/rendering/scroll.zig");
const entity_wrap = @import("../systems/rendering/entity_wrap.zig");
const entity_reset = @import("../systems/gameplay/entity_reset.zig");
const scenery_wrap = @import("../systems/rendering/scenery_wrap.zig");
const sound_intent = @import("../systems/audio/sound_intent.zig");
const player = @import("../entities/player.zig");
const enemy = @import("../entities/enemy.zig");
const ring = @import("../entities/ring.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");

const JUMP_FORCE: f32 = -250.0;

pub fn enter(world: *ecs.World) !void {
    try player.spawn(world);
    try platform.spawn(world);
    try background.spawn(world);
    for (0..5) |_| {
        try enemy.spawn(world);
        try ring.spawn(world);
    }
}

pub fn exit(world: *ecs.World) void {
    world.reset();
}

pub fn update(world: *ecs.World, delta: f32) void {
    world.time += delta;

    if (world.confirm_intent) {
        ecs.Query.players(world, {}, jump);
    }

    if (world.quit_intent) {
        world.changeScene(ecs.Scene.main_menu) catch |err| {
            std.debug.print("Failed to change scene: Game Play -> Main Menu: {}\n", .{err});
        };
    }

    collision.system(world);
    jump_intent.system(world);
    gravity.system(world, delta);
    movement.system(world, delta);
    scroll.system(world, delta);
    entity_wrap.system(world, delta);
    entity_reset.system(world);
    scenery_wrap.system(world, delta);
    difficulty.system(world);
    sound_intent.system(world);
}

pub fn render(world: *ecs.World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    sprite.system(world, delta);
    hud.system(world);
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
