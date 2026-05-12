const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const input = @import("../systems/input/keyboard.zig");
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

    input.system(world);
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
