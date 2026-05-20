const std = @import("std");
const raylib = @import("raylib");
const ecs = @import("../ecs.zig");
const main_menu = @import("../systems/rendering/main_menu.zig");
const jump = @import("../systems/movement/jump.zig");
const scroll = @import("../systems/movement/scroll.zig");
const sprite = @import("../systems/rendering/sprite.zig");
const scenery_wrap = @import("../systems/movement/scenery_wrap.zig");
const player = @import("../entities/player.zig");
const platform = @import("../entities/platform.zig");
const background = @import("../entities/background.zig");
const Resources = @import("../resources/resources.zig").Resources;

pub fn enter(world: *ecs.World) !void {
    try player.spawn(world);
    try platform.spawn(world);
    try background.spawn(world);
}

pub fn exit(world: *ecs.World) void {
    world.reset();
}

pub fn update(world: *ecs.World, delta: f32) void {
    if (world.game.jump_intent) {
        world.game.changeScene(ecs.Scene.game_play) catch |err| {
            std.debug.print("Failed to change scene: Main Menu -> Game Play: {}\n", .{err});
        };
    }

    if (world.game.confirm_intent) {
        world.game.changeScene(ecs.Scene.credits) catch |err| {
            std.debug.print("Failed to change scene: Main Menu -> Credits: {}\n", .{err});
        };
    }

    jump.system(world, delta);
    scroll.system(world, delta);
    scenery_wrap.system(world);
}

pub fn render(world: *ecs.World, delta: f32) void {
    raylib.clearBackground(raylib.Color.black);
    sprite.system(world, delta);
    main_menu.system(world);
}
