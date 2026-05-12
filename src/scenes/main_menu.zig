const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const input = @import("../systems/input/keyboard.zig");
const main_menu = @import("../systems/rendering/main_menu.zig");
const movement = @import("../systems/movement/movement.zig");
const scroll = @import("../systems/rendering/scroll.zig");
const sprite = @import("../systems/rendering/sprite.zig");
const player = @import("../entities/player.zig");

pub fn enter(world: *ecs.World) !void {
    try player.spawn(world);
}

pub fn exit(world: *ecs.World) void {
    world.reset();
}

pub fn update(world: *ecs.World, delta: f32) void {
    input.system(world);
    movement.system(world, delta);
    scroll.system(world, delta);
}

pub fn render(world: *ecs.World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    sprite.system(world, delta);
    main_menu.system(world, delta);
}
